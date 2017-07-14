# coding: UTF-8
require_relative '../../spec_helper_min'
require 'models/user_table_shared_examples'

describe Carto::UserToken do
  include UniqueNamesHelper

  before(:all) do
    bypass_named_maps

    @user = FactoryGirl.create(:carto_user)
    @carto_user = @user

    @user_table = Carto::UserTable.new
    @user_table.user = @user
    @user_table.name = unique_name('user_table')
    @user_table.save

    # The dependent visualization models are in the UserTable class for the AR model
    @dependent_test_object = @user_table
  end

  after(:all) do
    @user_table.destroy
    @user.destroy
  end

  def build_user_token(permissions = 'R') #I will use here the constant in the model but I'm not sure how to import it
    @user_token= Carto::UserToken.new
    @user_token.user_table = @user_table
    @user_token.received_at = DateTime.now
    @user_token.permissions = permissions
    @user_token.save
    @user_token  
  end

  describe('#create_user_token') do
      it 'creates user token without problem' do
	build_user_token
      	expect {@user_table.user_tokens.size}.to eq 1
      end
  end

  describe('#delete_user_token') do
      it 'Delete user_token without deleting the user_table' do
      end
      it 'Delete user_token if we delete the user_table related to it' do
      end
  end

  describe('#check_user_token_permissions') do
      it 'Check if we write RW permissions return is_read_only false' do
      end
      it 'Check if we write R permissions return is_read_only true' do
      end
  end

  describe('#validate_user_token') do
      it 'validate valid user_token for user_table return true' do
      end
      it 'validate invalid user_token return false' do
      end
  end

end
