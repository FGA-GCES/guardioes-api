require 'rails_helper'
require 'spec_helper'

def test_household_count(expected)
  expect(Household.all.length).to eq(expected)
end

RSpec.describe Household, type: :model do

  before :all do
    App.new(:app_name=>"cleber institution", :owner_country=>"brazil").save()
  end

  let (:valid_household) {
    Household.new(
      :description => "Clebin's household", 
      :birthdate => , 
      :country => , 
      :gender => , 
      :race => ,
      :user_id => 1,
      :kinship => 
    )
  }

  describe "basic household model functions" do
    context "valid input" do
      it "creates valid Household" do
        expect(valid_household.save()).to be true
      end
      it "deletes household" do
        valid_household.save()
        test_household_count(1)
        Household.all[0].delete()
        test_household_count(0)
      end
      it "updates household" do
        valid_household.save()
        expect(Household.all[0].description).to eq(valid_user.description)
        valid_user.update(:description=>"Clebao's household")
        expect(Household.all[0].description).to eq("Clebao's household")
      end
    end
    context "invalid input" do
      it "fails to update with invalid fields" do
        valid_household.save()
        Household.all[0].update(:description=>"Clebao's household", :user_id=>2)
        expect(Household.all[0].user_id).to eq(valid_household.user_id)
        expect(Household.all[0].description).to eq(valid_household.description)
      end
      it "fails to create household not tied to any user" do
        invalid_household = valid_household
        invalid_household.user_id = 0
        invalid_household.save()
        test_household_count(0)
      end
    end
  end
end
