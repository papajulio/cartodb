# encoding: UTF-8

require_relative '../../../models/carto/permission'

module Carto
  module Api
    class UserTokenController < ::Api::ApplicationController
      ssl_required :show, :create, :update, :destroy

      REJECT_PARAMS = %w{ format controller action row_id requestId column_id
                          api_key table_id oauth_token oauth_token_secret api_key user_domain }.freeze

      before_filter :set_start_time
      before_filter :load_user_table, only: [:show, :create, :update, :destroy]
      before_filter :read_privileges?, only: [:show]
      before_filter :write_privileges?, only: [:create, :update, :destroy]

      def show
        render_jsonp(@user_table.user_token.first.user_token)
      rescue => e
        CartoDB::Logger.error(message: 'Error loading user_token', exception: e,
                              user_table: @user_table)
        render_jsonp({ errors: ["User Token for User Table with id #{params[:table_id]} not found"] }, 404)
      end

      def create
        if params[:permissions].present?
          @user_table.create_user_token(permissions=params[:permissions], user_table=@user_table)
	else
          @user_table.create_user_token(permissions=PERMISSIONS_READ_ONLY, user_table=@user_table)
        render_jsonp(@user_table.user_token.first.user_token)
      rescue => e
        render_jsonp({ errors: [e.message] }, 400)
      end

      def update
        if params[:permissions].present?
          begin
            resp = @user_table.user_token.update_attributes(permissions=params, filtered_row)
            render_jsonp(@user_table.user_token.first.user_token)
          rescue => e
            CartoDB::Logger.warning(message: 'Error updating user_token', exception: e)
            render_jsonp({ errors: [translate_error(e.message.split("\n").first)] }, 400)
          end
        else
          render_jsonp({ errors: ["permissions can't be blank"] }, 404)
        end
      end

      def destroy
	@user_token.user_token.destroy
        head :no_content
      rescue
        render_jsonp({ errors: ["user_token for user_table with id #{params[:table_id]} not found"] }, 404)
      end

      protected

      def filtered_row
        params.reject { |k, _| REJECT_PARAMS.include?(k) }.symbolize_keys
      end

      def load_user_table
        @user_table = Carto::Helpers::TableLocator.new.get_by_id_or_name(params[:table_id], current_user)
        raise RecordNotFound unless @user_table
      end

      def read_privileges?
        head(401) unless current_user && @user_table.visualization.is_viewable_by_user?(current_user)
      end

      def write_privileges?
        head(401) unless current_user && @user_table.visualization.writable_by?(current_user)
      end
    end
  end
end
