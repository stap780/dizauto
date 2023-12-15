class ProductEtiketkiJob < ApplicationJob
    queue_as :print

    def perform(product_ids, current_user_id)
        # sleep 3
        # puts "payment is processed"
        products = Product.where(id: product_ids)

        success, etiketka = CreateEtiketka.new(products).call
        if success
            Turbo::StreamsChannel.broadcast_replace_to(
                User.find(current_user_id),
                "products",
                target: "modal",
                template: "products/success_etiketki",
                layout: false,
                locals: {etiketka: etiketka}
            )
        end
    end
end