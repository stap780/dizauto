module NotificationExtensions
    extend ActiveSupport::Concern

    included do
        belongs_to :organization

        scope :filter_by_type, ->(type) { where(type:) }
        scope :exclude_type, ->(type) { where.not(type:) }
    end

    # You can also add instance methods here
end

module EventExtensions

end
