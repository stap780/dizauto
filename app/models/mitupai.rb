# The Mitupai class inherits from ApplicationRecord - https://ai.mitup.ru/
class Mitupai < ApplicationRecord
  validates :api_url, presence: true, uniqueness: true
  validates :api_key, presence: true, uniqueness: true

  after_create_commit { broadcast_append_to 'mitupais' }
  after_update_commit { broadcast_replace_to 'mitupais' }
  after_destroy_commit { broadcast_remove_to 'mitupais' }

  def work?
    api_url.present? && api_key.present?
  end

end
