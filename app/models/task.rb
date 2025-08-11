class Task < ApplicationRecord
  PRIORITY = %w[1 2 3 4 5].freeze

  validates :priority, inclusion: { in: PRIORITY }

  belongs_to :user

  validates :title, uniqueness: { case_sensitive: false }
  validates :description, length: { minimum: 25 }

  scope :recently_added, -> { order('created_at desc').limit(3) }
  scope :by_priority, -> { order(priority: :asc) }
  scope :due_soon, ->(items=3) { order(due_date: :asc, priority: :asc).limit(items) }

  scope :with_priority, ->(priority) {
    where(priority: priority).order(due_date: :asc) if priority.present?
  }

end
