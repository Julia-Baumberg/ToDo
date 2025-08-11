class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, format: {
    with: /\S+@\S+/
  }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }
  validates :username,
            presence: true, format: { with: /\A[A-Z0-9]+\z/i },
            uniqueness: { case_sensitive: false }

  has_many :tasks

  # before_save :set_slug

  # def to_param
  #   slug
  # end

  private

  # def set_slug
  #   self.slug = name.parameterize
  # end


end
