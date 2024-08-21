class ProductPriceUpdateJob < ApplicationJob
  queue_as :default

  def perform(product_ids, price_type, price_move, price_shift, price_points, current_user_id)
    products = Product.where(id: product_ids)

    success, message = Product::PriceUpdate.new( products, {price_type: price_type, price_move: price_move, price_shift: price_shift, price_points: price_points} ).call
    if success
      PriceUpdateNotifier.with(
                        record: products.first, 
                        message: "Success",
                        blob: nil,
                        error: nil,
                        model: 'Product'
                        ).deliver(User.find_by_id(current_user_id))

      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        "bulk_actions",
        target: "modal",
        template: "shared/success_bulk",
        layout: false,
        locals: {bulk_print: nil, message: message }
      )
    else
      PriceUpdateNotifier.with(
                        record: products.first, 
                        message: "Error",
                        blob: nil,
                        error: message,
                        model: 'Product'
                        ).deliver(User.find_by_id(current_user_id))


      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        "bulk_actions",
        target: "modal",
        template: "shared/error_bulk",
        layout: false,
        locals: {error_message: message, error_process: "Product Price Update Job"}
      )
    end
  end

end
