class ProductEtiketkiJob < ApplicationJob
    queue_as :print

    def perform(product_ids)
        # sleep 3
        # puts "payment is processed"
        products = Product.where(id: product_ids)

        success, etiketka = CreateEtiketka.new(products).call
        if success
            Turbo::StreamsChannel.broadcast_replace_to(
                "products",
                target: "modal",
                template: "products/success_etiketki",
                layout: false,
                locals: {etiketka: etiketka}
            )
        end
    end
end