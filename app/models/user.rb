class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 5 }

  before_save :generate_slug

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.username)
    user = User.find_by(slug: the_slug)
    count = 2

    while user && user != self
      the_slug = append_suffix(the_slug, count)
      user = User.find_by(slug: the_slug)
      count += 1
    end
    
    self.slug = the_slug
  end

  def to_slug(str)
    str.downcase.strip.gsub(/\s*[^A-Za-z0-9]+\s*/, '-')
  end

  def append_suffix(slug, count)
    split_slug = slug.split('-')

    if split_slug.last.to_i != 0
      slug = split_slug.slice(0...-1).join('-')
    end

    "#{slug}-#{count}"
  end
end