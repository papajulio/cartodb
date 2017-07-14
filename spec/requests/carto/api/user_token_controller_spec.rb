# encoding: utf-8

require_relative '../../../spec_helper'

describe Carto::Api::UserTokenController do
  describe '#show user_token tests' do

    before(:all) do
      @user = FactoryGirl.create(:valid_user)
    end

    before(:each) do
      bypass_named_maps
      delete_user_data @user
      @table = create_table(user_id: @user.id)
    end

    after(:all) do
      bypass_named_maps
      @user.destroy
    end

    let(:params) { { api_key: @user.api_key, table_id: @table.name, user_domain: @user.username } }

    it "Insert a new user_token and get the token" do
      payload = {
        permissions: "R"
      }

      post_json api_v1_tables_records_create_url(params.merge(payload)) do |response|
        response.status.should be_success
        response.body[:user_token].should exists
      end
    end

    it "Get user_token that exist" do
	#Should go ok
    end

    it "Get user_token that doesn't exist should return 404" do
    end

    it "Update a user_token and change permissions" do
	#Should go ok
    end

    it "Update a row that doesn't exist" do
	#Should fail with a 404
    end

    it "Remove a user_token" do
	#Should go ok
    end

    it "Remove a user_token without permissions" do
	#Should fail with a 403
    end
  end
end
