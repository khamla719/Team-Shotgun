class AddColumns < ActiveRecord::Migration
  def change
    add_column :users, :followers_count, :integer, default: 0
    add_column :users, :leaders_count, :integer, default: 0
    add_column :users, :gravatar, :string
  end
end
