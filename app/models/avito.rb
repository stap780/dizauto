# Avito < ApplicationRecord
class Avito < ApplicationRecord

  include NormalizeDataWhiteSpace
  after_create_commit { broadcast_append_to 'avitos' }
  after_update_commit { broadcast_replace_to 'avitos' }
  after_destroy_commit { broadcast_remove_to 'avitos' }

  validates :title, presence: true
  validates :api_id, presence: true, uniqueness: true
  validates :api_secret, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end


  def api_work?
    return false unless api_id.present? && api_secret.present?

    result = Avito::OrderImport.new(self).check
    result.nil? ? false : true
  end

end
