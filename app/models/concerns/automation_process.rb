# module Automation
module AutomationProcess
  extend ActiveSupport::Concern

  included do
    after_create_commit :automation_create
    after_update_commit :automation_update

    def automation_create
      Automation.new(self).create
    end

    def automation_update
      Automation.new(self).update
    end
  end
end