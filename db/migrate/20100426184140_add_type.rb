class AddType < ActiveRecord::Migration
  def self.up
    add_column :tweets, :url_type, :string
  end

  def self.down
    remove_column :tweets, :url_type
  end
end
