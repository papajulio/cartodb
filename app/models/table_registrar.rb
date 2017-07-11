# encoding: utf-8

module CartoDB
  class TableRegistrar
    def initialize(user, table_klass=nil)
      @user         = user
      @table_klass  = table_klass
    end

    def register(table_name, data_import_id)
      @table = build_table(table_name, data_import_id)
      set_metadata_from_data_import_id(table, data_import_id)
      table.save
      table.optimize
      table.map.recalculate_bounds!
    end

    def exists?(user, table_name)
      !table_klass.where(user_id: user.id, name: table_name).empty?
    end

    attr_reader :user, :table

    private

    attr_reader :table_klass
    attr_writer :table

    def build_table(table_name, data_import_id)
      table = @table_klass.new
      table.user_id = @user.id
      table.instance_eval { self[:name] = table_name }
      table.migrate_existing_table = table_name
      table.data_import_id = data_import_id
      table
    end

    def external_visualization(data_import_id)
      external_data_import = Carto::ExternalDataImport.find_by_data_import_id(data_import_id)
      external_source = Carto::ExternalSource.find(external_data_import.external_source_id)
      external_source.visualization
    rescue ActiveRecord::RecordNotFound => _e
    end

    def set_metadata_from_data_import_id(table, data_import_id)
      if external_visualization(data_import_id)
        table.description = visualization.description
        table.set_tag_array(visualization.tags)
      end
    rescue => e
      CartoDB.notify_exception(e)
      raise e
    end
  end # TableRegistrar
end # CartoDB
