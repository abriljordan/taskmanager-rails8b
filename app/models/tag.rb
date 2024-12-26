class Tag < ApplicationRecord
  has_and_belongs_to_many :tasks
  has_many :tag_tasks
  has_many :tasks, through: :tags_tasks
  validates :name, presence: true, uniqueness: true, length: { maximum: 20 },
  format: { without: /\s/, message: "cannot contain spaces" }

  #  validates :description, presence: true, length: { maximum: 255 } # Add this line for description validation

  scope :sorted, -> { order(:name) }

  def display_name
    name.titleize
  end

  after_create :log_creation

  private

  def log_creation
    logger.debug("Tag created: #{name}")
  end
end
