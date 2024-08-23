class ExportJob < ApplicationJob
  queue_as :export

  def perform(export, current_user_id)
    # Do something later
    success = ExportCreator.call(export)

    if success
      ExportNotifier.with(record: export, message: "ExportJob success").deliver(User.find_by_id(current_user_id))

      Turbo::StreamsChannel.broadcast_replace_to(
        User.find(current_user_id),
        "exports",
        target: "export_#{export.id}",
        partial: "exports/export",
        layout: false,
        locals: {export: export}
      )
    end
  end
  
end