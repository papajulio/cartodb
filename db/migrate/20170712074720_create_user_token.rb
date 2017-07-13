require 'carto/db/migration_helper'

include Carto::Db::MigrationHelper

migration(
  Proc.new do
    create_table :user_tokens do
      Uuid        :id, primary_key: true, default: 'uuid_generate_v4()'.lit
      foreign_key :user_table_id, :user_tables, null: false, type: :uuid, on_delete: :cascade
      DateTime    :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      String :permissions, :null => false
      Uuid :token, :null => false, default: 'uuid_generate_v4()'.lit
    end

    alter_table :user_tokens do
      add_index [:user_table_id]
    end
  end,
  Proc.new do
    drop_table :user_tokens
  end
)
