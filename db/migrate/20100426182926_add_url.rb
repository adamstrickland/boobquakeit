class AddUrl < ActiveRecord::Migration
  def self.up
    add_column :tweets, :url, :string
  end

  def self.down
    remove_column :tweets, :url
  end
end
