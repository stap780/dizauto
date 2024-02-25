class CreateZipXlsxJob < ApplicationJob
    queue_as :print
  
    def perform(collection_ids, options={})
        model =  options[:model]
        items = model.camelize.constantize.where(id: collection_ids)
  
    #   Admin::UserMailer.with(user: User.find(current_user_id), zipped_blob: zipped_blob).bulk_export_done.deliver_now
        success, zipped_blob = ZipXlsx.new(items, {filename: options[:filename], template: options[:template]} ).call
        if success
            Turbo::StreamsChannel.broadcast_replace_to(
                User.find(options[:current_user_id]),
                "products",
                target: "modal",
                template: "shared/success_bulk",
                layout: false,
                locals: {bulk_print: zipped_blob}
            )
        else
            Turbo::StreamsChannel.broadcast_replace_to(
                User.find(options[:current_user_id]),
                "products",
                target: "modal",
                template: "shared/error_bulk",
                layout: false,
                locals: {error_message: zipped_blob, error_process: 'CreateZipXlsxJob'}
            )
        end

    end
  end