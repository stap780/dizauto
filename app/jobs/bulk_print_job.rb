class BulkPrintJob < ApplicationJob
  queue_as :print

  def perform(model, ids, templ_id, current_user_id)
    # sleep 3
    # puts "payment is processed"
    items = model.camelize.constantize.where(id: ids)

    success, blob = BulkPrint.new(items, {templ_id: templ_id}).call
    if success
      PrintNotifier.with(record: items.first, message: "BulkPrint success").deliver(User.find_by_id(current_user_id))
      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(current_user_id),
        "bulk_actions",
        target: "modal",
        template: "shared/success_bulk",
        layout: false,
        locals: {bulk_print: blob}
      )
    else
      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(current_user_id),
        "bulk_actions",
        target: "modal",
        template: "shared/error_bulk",
        layout: false,
        locals: {error_message: blob, error_process: "BulkPrintJob"}
      )
    end
  end
end
