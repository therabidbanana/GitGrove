require 'ar_openid_store/migration'
class AddOpenId < ActiveRecord::Migration

  def self.up
    create_openid_tables
  end
  
  def self.down
    drop_openid_tables
  end
  
end

