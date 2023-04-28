class ExportJob < ApplicationJob
    queue_as :export
  
    def perform(export)
      # Do something later
      ExportCreator.call(export)
    end
  end