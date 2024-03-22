class IncaseImportColumn < ApplicationRecord
  validates :incase_import_id, presence: true
  belongs_to :incase_import
end
