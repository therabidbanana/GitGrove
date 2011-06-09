module LoginHelpers
  def create_google_user(email)
    u = User.create(:name => email, :email => email)
    u.services.create(:uid => email, :provider => 'google')
    u
  end
end
World(LoginHelpers)
