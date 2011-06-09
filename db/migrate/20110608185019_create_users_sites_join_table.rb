class CreateUsersSitesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :users_sites, :id => false do |t|
      t.integer :site_id
      t.integer :user_id
    end
    
  end

  def self.down
    drop_table :users_sites
  end
end
