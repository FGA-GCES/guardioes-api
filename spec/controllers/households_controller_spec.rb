require 'rails_helper'

RSpec.describe HouseholdsController, type: :controller do

  before(:all) {
    # Register app
    @valid_app = App.new(
      :app_name=>"unb",
      :owner_country=>"brazil"
    )
    # Register admin
    @valid_admin = Admin.new(
        :email => "juse@gmail.com",
        :password => "12345678",
        :first_name => "clebe",
        :last_name => "clebe",
        :is_god => true,
        :app_id => 1
    )
    @valid_app.save()
    @valid_admin.save()
  }

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      :description => "Clebin's household", 
      :birthdate => , 
      :country => , 
      :gender => , 
      :race => ,
      :user_id => 1,
      :kinship =>
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_user_session) { {} }

#  let(:valid_admin_session) {
#    @controller = SessionController
#    post :login, params: {admin: 
#      { :email => @valid_admin.email, :password => @valid_admin.password } }
#    puts "==========="
#    puts response
#    puts "==========="
#    @controller = UsersController
#    # {:Authorization => Admin.reload.api_token}
#    return {}
#  }


  describe "GET #index" do
    it "returns a success response" do
      HouseholdsController = User.create! valid_attributes
      get :index, params: {}, session: valid_admin_session
      expect(response).to be_successful
    end
  end
end
