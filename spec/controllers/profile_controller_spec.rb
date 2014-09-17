require 'rails_helper'

describe ProfileController do
  describe "GET show" do
    it "returns http success" do
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :show
      expect(response).to be_success
    end
  end
end
