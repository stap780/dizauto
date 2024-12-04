class IncaseImportStartImportJob < ApplicationJob
    queue_as :incase_import
  
    def perform(incase_import, current_user_id)

      success, message = Incase::Import.new(incase_import).import
  
      if success
        IncaseImportNotifier.with(record: incase_import, message: 'IncaseImportStartImportJob success').deliver(User.find_by_id(current_user_id))
  
        Turbo::StreamsChannel.broadcast_replace_to(
          User.find(current_user_id),
          "incase_imports",
          target: "modal",
          partial: "incase_imports/import_finish",
          layout: false,
          locals: {success: success, message: message, incase_import: incase_import}
        )
      else
        Turbo::StreamsChannel.broadcast_replace_to(
          User.find(current_user_id),
          "incase_imports",
          target: "modal",
          partial: "incase_imports/import_finish",
          layout: false,
          locals: {success: success, message: message, incase_import: incase_import}
        )
      end

    end
  end