class Task < ApplicationRecord
  PRIORITY = %w[1 2 3 4 5].freeze

  validates :priority, inclusion: { in: PRIORITY }

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, uniqueness: { case_sensitive: false }
  validates :description, length: { minimum: 15 }

  scope :recently_added, -> { order('created_at desc').limit(3) }
  scope :by_priority, -> { order(priority: :asc) }
  scope :by_due_date, -> { order(due_date: :asc, priority: :asc) }
  scope :due_soon, ->(items=3) { order(due_date: :asc, priority: :asc).limit(items) }

  scope :with_priority, ->(priority) {
    where(priority: priority).order(due_date: :asc) if priority.present?
  }

  scope :is_completed, -> { where(is_completed: true) }
  scope :not_completed, -> { where("is_completed IS NULL OR is_completed = ?", false)}
end
