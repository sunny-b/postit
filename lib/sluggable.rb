module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug
    class_attribute :slug_column
  end

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    object = self.class.find_by(slug: the_slug)
    count = 2

    while object && object != self
      the_slug = append_suffix(the_slug, count)
      object = self.class.find_by(slug: the_slug)
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

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end