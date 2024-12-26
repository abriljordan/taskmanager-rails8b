class Category < ApplicationRecord
    has_many :tasks, dependent: :nullify

    validates :name, presence: true, length: { within: 2..50 }

    scope :sorted, -> { order(:name) }
    scope :with_tasks, -> { joins(:tasks).distinct }

    after_create :log_creation
    after_update :log_update
    after_destroy :log_destruction

    private

    def log_creation
      logger.debug("Category created: #{name}")
    end

    def log_update
      logger.debug("Category updated: #{name}")
    end

    def log_destruction
      logger.debug("Category destroyed: #{name}")
    end
end
