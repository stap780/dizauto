class CreateXlsxJob < ApplicationJob
  include Sidekiq::Job
  queue_as :print

  def perform(collection_ids, options = {})
    return if cancelled?

    model = options[:model]
    items = model.camelize.constantize.where(id: collection_ids)

    success, message = Product::CreateXlsx.call(items, {model: "Product"})
    if success
      PrintNotifier.with(
        record: items.first,
        message: "Success #{message}",
        blob: nil,
        error: nil,
        model: model,
        template: "xlsx"
      ).deliver(User.find_by_id(options[:current_user_id]))

      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(options[:current_user_id]),
        "bulk_actions",
        target: "modal",
        template: "shared/success_bulk",
        layout: false,
        locals: {bulk_print: blob, message: nil}
      )
    else
      PrintNotifier.with(
        record: items.first,
        message: "Error",
        blob: nil,
        error: message,
        model: model,
        template: "xlsx"
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

  def cancelled?
    Sidekiq.redis { |c| c.exists("cancelled-#{jid}") == 1 } # Use c.exists? on Redis >= 4.2.0
  end

  def self.cancel!(jid)
    Sidekiq.redis { |c| c.set("cancelled-#{jid}", 1, ex: 86_400) }
  end
end
