class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :task_assignments
  has_many :tasks, through: :task_assignments

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
