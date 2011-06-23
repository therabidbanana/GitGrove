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
    create_token
  end

  def create_token
    self.services.create(:provider => 'token', :uid => rand(36**8).to_s(36))
  end

  def token
    self.services.find_by_provider('token').uid
  end

  def admin?
    return self.is_admin
  end
    
end
