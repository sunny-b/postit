class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  before_save :generate_slug

  validates :title, presence: true, length: {minimum: 1}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true

  def total_votes
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.title)
    post = Post.find_by(slug: the_slug)
    count = 2

    while post && post != self
      the_slug = append_suffix(the_slug, count)
      post = Post.find_by(slug: the_slug)
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