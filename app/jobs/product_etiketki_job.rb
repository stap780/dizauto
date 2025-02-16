# ProductEtiketkiJob < ApplicationJob
class ProductEtiketkiJob < ApplicationJob
  queue_as :print

  def perform(variant_ids, current_user_id)
    # items = Product.where(id: product_ids)
    # success, blob = Bulk::CreateEtiketka.call(items)

    items = Variant.where(id: variant_ids)

    success, blob = Bulk::CombineEtiketka.call(items)
    if success
      PrintNotifier.with(
        record: items.first, 
        message: 'Success. Создали этикетки',
        blob: blob,
        error: nil,
        model: 'Product',
        template: 'Этикетка'
      ).deliver(User.find_by_id(current_user_id))

      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        'products',
        target: 'modal',
        template: 'shared/success_bulk',
        layout: false,
        locals: { bulk_print: blob, message: nil }
      )
    else
      PrintNotifier.with(
        record: items.first, 
        message: 'Error. При создании этикеток',
        blob: nil,
        error: blob,
        model: 'Product',
        template: 'Этикетка'
      ).deliver(User.find_by_id(current_user_id))

      Turbo::StreamsChannel.broadcast_update_to(
        User.find(current_user_id),
        'products',
        target: 'modal',
        template: 'shared/error_bulk',
        layout: false,
        locals: { error_message: blob, error_process: 'ProductEtiketkiJob' }
      )
    end
  end
end
