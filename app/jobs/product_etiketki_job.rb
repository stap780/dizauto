class ProductEtiketkiJob < ApplicationJob
  queue_as :print

  def perform(product_ids, current_user_id)
    products = Product.where(id: product_ids)

    success, etiketka = CreateEtiketka.new(products).call
    if success
      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        "products",
        target: "modal",
        template: "shared/success_bulk",
        layout: false,
        locals: {bulk_print: etiketka}
      )
    else
      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        "products",
        target: "modal",
        template: "shared/error_bulk",
        layout: false,
        locals: {error_message: etiketka, error_process: "ProductEtiketkiJob"}
      )
    end
  end
end
