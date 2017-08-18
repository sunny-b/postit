class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  before_save :generate_slug

  validates :name, presence: true, length: {minimum: 3}, uniqueness: true

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.name)
    category = Category.find_by(slug: the_slug)
    count = 2

    while category && category != self
      the_slug = append_suffix(the_slug, count)
      category = Category.find_by(slug: the_slug)
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