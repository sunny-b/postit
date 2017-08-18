class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }

  sluggable_column :username
end