# NOT USE NOW
# Created for test
#


class CreateXlsxJob < ApplicationJob
  queue_as :print
  sidekiq_options retry: 0

  def perform(collection_ids, options = {})
    model = options[:model]
    items = model.camelize.constantize.where(id: collection_ids)

    success, message = Product::CreateXlsx.call(items, {model: model} )
    if success
      PrintNotifier.with(
                          record: items.first, 
                          message: "Success #{message}",
                          blob: nil,
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
        locals: {bulk_print: nil, message: message}
      )
    else
      PrintNotifier.with(
                          record: items.first, 
                          message: "Error",
                          blob: nil,
                          error: message,
                          model: model,
                          template: 'xlsx'
                        ).deliver(User.find_by_id(options[:current_user_id]))

      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(options[:current_user_id]),
        "bulk_actions",
        target: "modal",
        template: "shared/error_bulk",
        layout: false,
        locals: {error_message: message, error_process: "CreateXlsxJob"}
      )
    end
  end
  
end
