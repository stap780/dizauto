class ExportJob < ApplicationJob
  queue_as :export

  def perform(export_id, current_user_id)
    # Do something later
    success = ExportCreator.call(export_id)

    if success
      ExportNotifier.with(record: Export.find_by_id(export_id), message: "ExportJob success").deliver(User.find_by_id(current_user_id))

      # Turbo::StreamsChannel.broadcast_replace_to(
      #   User.find(current_user_id),
      #   "exports",
      #   target: "export_#{export.id}",
      #   partial: "exports/export",
      #   layout: false,
      #   locals: {export: export}
      # )
    end
  end

end