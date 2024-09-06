class CreateZipXlsxJob < ApplicationJob
  queue_as :print
  sidekiq_options retry: 0

  def perform(collection_ids, options = {})
    model = options[:model]
    items = model.camelize.constantize.where(id: collection_ids)

    #   Admin::UserMailer.with(user: User.find(current_user_id), zipped_blob: zipped_blob).bulk_export_done.deliver_now
    success, zipped_blob = ZipXlsx.call(items, {model: model})
    if success
      PrintNotifier.with(
                          record: items.first, 
                          message: "Success",
                          blob: zipped_blob,
                          error: nil,
                          model: model,
                          template: 'zip'
                        ).deliver(User.find_by_id(options[:current_user_id]))

      Turbo::StreamsChannel.broadcast_replace_to(
                                                  User.find(options[:current_user_id]),
                                                  "bulk_actions",
                                                  target: "modal",
                                                  template: "shared/success_bulk",
                                                  layout: false,
                                                  locals: {bulk_print: zipped_blob, message: nil}
                                                )
    else
      PrintNotifier.with(
                          record: items.first, 
                          message: "Error",
                          blob: nil,
                          error: zipped_blob,
                          model: model,
                          template: 'zip'
                        ).deliver(User.find_by_id(options[:current_user_id]))

      Turbo::StreamsChannel.broadcast_replace_to(
                                                  User.find(options[:current_user_id]),
                                                  "bulk_actions",
                                                  target: "modal",
                                                  template: "shared/error_bulk",
                                                  layout: false,
                                                  locals: {error_message: zipped_blob, error_process: "CreateZipXlsxJob"}
                                                )
    end
  end
end
