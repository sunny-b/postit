class AddSlugToPostsCategoriesUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string
    add_column :categories, :slug, :string
    add_column :posts, :slug, :string
  end
end
