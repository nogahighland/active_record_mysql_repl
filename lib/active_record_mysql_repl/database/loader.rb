# frozen_string_literal: true

require "json"
require "active_record"
require "active_support/all"

module ActiveRecordMysqlRepl
  module Database
    module Loader
      def self.load_tables(db_config_key, army_config, port)
        puts "Loading tables".gray

        tables = ActiveRecord::Base.connection.tables
        association_settings = army_config.associations.present? ? Associations.load(army_config.associations) : {}
        association_setting = association_settings[db_config_key]
        analyzed_tables = if association_setting.present?
          Associations.analyze(tables, association_setting)
        else
          Associations.analyze(tables)
        end

        skipped = []
        analyzed_tables.each do |analyzed_table|
          # defer model definition for tables with `has_many: :xxx, through: xxx` associations
          if analyzed_table.has_many.any? { |hm| hm.is_a?(Hash) && hm.key?(:through) }
            skipped << analyzed_table
            next
          end
          define_model(analyzed_table)
        end

        skipped.each do |analyzed_table|
          define_model(analyzed_table)
        end
      end

      def self.define_model(analyzed_table)
        klass = Class.new(ActiveRecord::Base)

        analyzed_table.has_many.each do |has_many|
          if has_many.is_a?(String)
            klass.has_many has_many.to_sym
          elsif has_many.is_a?(Hash)
            klass.has_many has_many[:name].to_sym, **has_many.except(:name)
          end
        end

        analyzed_table.has_one.each do |has_one|
          klass.has_one has_one[:name].to_sym, class_name: has_one[:class_name], foreign_key: has_one[:foreign_key]
        end

        analyzed_table.belongs_to.each do |belongs_to|
          if belongs_to.is_a?(String)
            klass.belongs_to belongs_to.to_sym
          elsif belongs_to.is_a?(Hash)
            klass.belongs_to belongs_to[:name].to_sym, class_name: belongs_to[:class_name].to_sym
          end
        end

        # allow type column
        klass.inheritance_column = :_type_disabled
        klass.table_name = analyzed_table.name

        Object.const_set(analyzed_table.name.classify, klass)
      end
    end
  end
end
