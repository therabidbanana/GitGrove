class AddRebuildTokenToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :rebuild_token, :string
  end

  def self.down
    remove_column :sites, :rebuild_token
  end
end
