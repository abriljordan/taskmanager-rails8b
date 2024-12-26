class Task < ApplicationRecord
  attr_accessor :skip_titleize_name

  # Associations
  belongs_to :category, optional: true
  has_many :task_assignments
  has_many :users, through: :task_assignments
  has_many :tags_tasks
  has_many :tags, through: :tags_tasks
  has_and_belongs_to_many :tags

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :position, presence: true, numericality: { greater_than: 0 }
  validate :description_has_no_prohibited_words

  # Callbacks
  before_validation :titleize_name, unless: :skip_titleize_name
  before_validation :set_default_position, if: -> { position.blank? || position < 1 }
  before_create :log_create
  before_update :log_update
  after_save :log_save
  after_commit :cleaning_reminder, if: :too_many_records?

  # Scopes
  scope :complete, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :sorted, -> { order(:position) }
  scope :search, ->(kw) { where("LOWER(name) LIKE ?", "%#{kw.downcase}%") }

  private

  # Custom validation method
  def description_has_no_prohibited_words
    return unless description.present?

    prohibited_words = [ "later", "eventually", "someday" ]
    prohibited_words.each do |word|
      if description.include?(word)
        errors.add(:description, "cannot contain prohibited word: #{word}")
      end
    end
  end

  # Titleize the name before saving
  def titleize_name
    self.name = name.titleize
  end

  # Set the default position if not provided
  def set_default_position
    max_position = Task.maximum(:position) || 0
    self.position = max_position + 1
  end

  # Logging methods
  def log_create
    logger.debug("Task being created: #{name}")
  end

  def log_update
    logger.debug("Task being updated: #{name}")
  end

  def log_save
    logger.debug("Task was saved: #{name}")
  end

  # Reminder to clean up old records
  def cleaning_reminder
    logger.debug("Remember to prune old tasks")
  end

  # Check if there are too many tasks
  def too_many_records?
    Task.count > 4
  end
end
