class ExportJob < ApplicationJob
  queue_as :export
  sidekiq_options retry: 0

  def perform(export, current_user_id)
    # Do something later
    success, result = ExportCreator.call(export)

    if success
      ExportNotifier.with(record: export, message: "ExportJob success").deliver(User.find_by_id(current_user_id))

      # Turbo::StreamsChannel.broadcast_replace_to(
      #   User.find(current_user_id),
      #   "exports",
      #   target: "export_#{export.id}",
      #   partial: "exports/export",
      #   layout: false,
      #   locals: {export: export}
      # )
    else
      ExportNotifier.with(record: export, message: "ExportJob error #{result}").deliver(User.find_by_id(current_user_id))
    end
  end
end
