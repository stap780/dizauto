# AiGetContentJob < ApplicationJob
class AiGetContentJob < ApplicationJob
  queue_as :ai_get_content
  sidekiq_options retry: 0

  def perform(product, task_id, current_user_id)
    ai = AiMitup.new

    loop do
      result = ai.get_content(task_id)
      if result['error'].nil? && result['contents']['text'].present?
        Turbo::StreamsChannel.broadcast_replace_to(
          User.find(current_user_id),
          'ai_description',
          target: "ai_result_content_product_#{product.id}",
          partial: 'products/ai/result_content',
          locals: {product: product, result: result['contents']['text']} 
        )
        break
      end
      sleep(5) # wait for 5 seconds before retrying
    end
  end

end
