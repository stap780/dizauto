class IncaseImportCheckFileJob < ApplicationJob
    queue_as :incase_import
  
    def perform(incase_import, current_user_id)

      success, message = Incase::Import.new(incase_import).check_file
  
      if success
        # ExportNotifier.with(record: export, message: "ExportJob success").deliver(User.find_by_id(current_user_id))
  
        Turbo::StreamsChannel.broadcast_update_to(
          User.find(current_user_id),
          'check_incase_imports',
          target: "incase_import_#{incase_import.id}",
          partial: 'incase_imports/check_import_info',
          layout: false,
          locals: {success: success, message: message, incase_import: incase_import}
        )
      else
        Turbo::StreamsChannel.broadcast_update_to(
          User.find(current_user_id),
          'check_incase_imports',
          target: "incase_import_#{incase_import.id}",
          partial: 'incase_imports/check_import_info',
          layout: false,
          locals: {success: success, message: message, incase_import: incase_import}
        )
      end

    end
  end