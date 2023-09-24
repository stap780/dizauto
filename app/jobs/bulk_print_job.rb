class BulkPrintJob < ApplicationJob
    queue_as :print

    def perform(model, ids, templ_id)
        # sleep 3
        # puts "payment is processed"
        items = model.camelize.constantize.where(id: ids)

        success, bulk_print = BulkPrint.new(items, {templ_id: templ_id}).call
        if success
            Turbo::StreamsChannel.broadcast_replace_to(
                "bulk_actions",
                target: "modal",
                template: "shared/success_bulk",
                layout: false,
                locals: {bulk_print: bulk_print}
            )
        end
    end
end