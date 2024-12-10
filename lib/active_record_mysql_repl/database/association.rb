# frozen_string_literal: true

module ActiveRecordMysqlRepl
  module Database
    class Associations
      class AnalyzedTable
        attr_accessor :name, :has_many, :has_one, :belongs_to
        def initialize(name)
          @name = name
          @has_many = []
          @has_one = []
          @belongs_to = []
        end
      end

      def self.load(path)
        new(YAML.load_file(path, aliases: true))
      end

      def initialize(associations)
        @associations = associations.map { |key, association| [key, Association.new(association)] }.to_h
      end

      def [](key)
        @associations[key]
      end

      # Analyze the relationship between tables based on the information of *_id columns
      # For example, if users.company_id exists, users belongs_to companies and companies has_many users
      def self.analyze(tables, association_settings)
        analyzed_tables = tables.map { |table| [table, AnalyzedTable.new(table)] }.to_h

        analyzed_tables.each do |table_name, table|
          association_setting = association_settings[table_name]
          columns = ActiveRecord::Base.connection.columns(table_name)
          columns.each do |column|
            next if association_setting.present? && association_setting.ignore_columns[table_name].include?(column.name)

            associatable = column.name.gsub(/_id$/, '') if column.name.end_with?('_id')
            next if associatable.blank? || associatable == 'class' # reserved word

            if analyzed_tables.keys.include?(associatable.pluralize)
              table.belongs_to << associatable.singularize if associatable
              analyzed_tables[associatable.pluralize].has_many << table_name.pluralize
            else
              associatable_table_name = associatable.split('_').last
              if analyzed_tables.keys.include?(associatable_table_name.pluralize)
                table.belongs_to << { name: associatable, class_name: associatable_table_name.classify, foreign_key: :id }
              else
                table.belongs_to << { name: associatable, class_name: table_name.singularize.classify, foreign_key: :id }
              end
            end
          end

          next if association_setting.blank?

          # merge yaml settings
          [:has_many, :belongs_to].each do |type|
            ass = table_associations_setting.fetch(type.to_s, []).symbolize_keys
            table.send(type).concat(ass) unless ass.blank?
          end
        end

        analyzed_tables.values
      end
    end

    class Association
      def initialize(association)
        @association = association
      end

      def [](table)
        table = (@association.keys - ['ignore_columns']) & [table]
        @association[table] if table.present?
      end

      def ignore_columns(table)
        @association.fetch('ignore_columns', {}).fetch(table, [])
      end
    end
  end
end
