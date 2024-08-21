class ProductEtiketkiJob < ApplicationJob
  queue_as :print

  def perform(product_ids, current_user_id)
    items = Product.where(id: product_ids)

    success, blob = CreateEtiketka.new(items).call
    if success
      PrintNotifier.with(
                        record: items.first, 
                        message: "Success. ID #{product_ids.take(5)} ...",
                        blob: blob,
                        error: nil,
                        model: 'Product',
                        template: 'Этикетка'
                        ).deliver(User.find_by_id(current_user_id))

      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        "products",
        target: "modal",
        template: "shared/success_bulk",
        layout: false,
        locals: {bulk_print: blob, message: nil}
      )
    else
      PrintNotifier.with(
                        record: items.first, 
                        message: "Error. ID #{product_ids.take(5)} ...",
                        blob: nil,
                        error: blob,
                        model: 'Product',
                        template: 'Этикетка'
                        ).deliver(User.find_by_id(current_user_id))


      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        "products",
        target: "modal",
        template: "shared/error_bulk",
        layout: false,
        locals: {error_message: blob, error_process: "ProductEtiketkiJob"}
      )
    end
  end
end
