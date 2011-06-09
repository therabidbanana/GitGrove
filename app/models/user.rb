class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  has_and_belongs_to_many :sites, :join_table => :users_sites
  
  attr_accessible :name, :email
  after_create :grant_admin

  def grant_admin
    if User.all.size == 1
      self.is_admin = true
      self.save
    end
  end

  def admin?
    return self.is_admin
  end
    
end
