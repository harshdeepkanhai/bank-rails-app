require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  
  describe "account" do

    before :each do
      @user = User.create(name: "Example User", email: "user@example.com", password: "botreetest", password_confirmation: "botreetest")
      @account = BankAccount.new(amount: 4000 , user_id: @user.id)
    end

    it "should be valid" do
      expect(@account).to be_valid
    end

    it "should be present" do
      @account.user_id = nil
      expect(@account).not_to be_valid
    end 
end
end