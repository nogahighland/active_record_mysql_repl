# frozen_string_literal: true

module ActiverecordMysqlRepl
  module Extensions
    module Tabler
      ::ActiveRecord::Base.subclasses.each do |model|
        define_method(model.table_name) do
          model.find(self)
        end

        define_method(model.table_name.singularize) do
          model.find(self)
        end

        model.column_names.each do |column|
          define_method("#{model.table_name.singularize}_by_#{column}") do
            model.where(column => self)
          end

          define_method("#{model.table_name.singularize}_#{column}_like") do
            model.where("#{column} like ?", "%#{self}%")
          end
        end
      end
    end

    String.include Tabler
    Symbol.include Tabler
    Enumerable.include Tabler
  end
end

