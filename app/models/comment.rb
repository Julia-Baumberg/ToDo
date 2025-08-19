class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :content, length: { minimum: 15 }
end
