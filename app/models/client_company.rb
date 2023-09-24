class ClientCompany < ApplicationRecord
    belongs_to :client
    belongs_to :company

    # validates :client_id, presence: true
    # validates :company_id, presence: true

end
