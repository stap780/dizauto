class CreateXlsxJob < ApplicationJob
  queue_as :print

  def perform(collection_ids, options = {})
    model = options[:model]
    items = model.camelize.constantize.where(id: collection_ids)

    success, blob = Product::CreateXlsx.call(items, {model: "Product"} )
    if success
      PrintNotifier.with(
                          record: items.first, 
                          message: "Success",
                          blob: blob,
                          error: nil,
                          model: model,
                          template: 'xlsx'
                        ).deliver(User.find_by_id(options[:current_user_id]))

      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(options[:current_user_id]),
        "bulk_actions",
        target: "modal",
        template: "shared/success_bulk",
        layout: false,
        locals: {bulk_print: blob, message: nil}
      )
    else
      PrintNotifier.with(
                          record: items.first, 
                          message: "Error",
                          blob: nil,
                          error: blob,
                          model: model,
                          template: 'xlsx'
                        ).deliver(User.find_by_id(options[:current_user_id]))

      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(options[:current_user_id]),
        "bulk_actions",
        target: "modal",
        template: "shared/error_bulk",
        layout: false,
        locals: {error_message: blob, error_process: "CreateXlsxJob"}
      )
    end
  end
end
