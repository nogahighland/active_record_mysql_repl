# frozen_string_literal: true

require "terminal-table"
require "csv"
require "clipboard"
require "json"

module ActiverecordMysqlRepl
  module Extensions
    module Object
      def tabulate(orientation = nil)
        arr = if is_a?(Array)
          self
        elsif is_a?(::ActiveRecord::Relation)
          to_a
        else
          [self]
        end

        arr = arr.map do |e|
          if e.is_a?(::ActiveRecord::Base)
            values = e.attributes.transform_values do |v|
              next JSON.pretty_generate(v) if v.is_a?(Enumerable) && v.size > 0
              next "NULL" if v.nil?
              next '""' if v == ""
              v.to_s
            end
            next values
          end
          e
        end

        raise "#{arr} is not an array of hash".red unless arr.all? { |e| e.is_a?(Hash) }
        raise "#{arr} contains Hashes with different keys".red unless arr.map(&:keys).uniq.size == 1

        orientation = case orientation
        when :vertical, :v
          :vertical
        when :horizontal, :h
          :horizontal
        else
          if arr.first.keys.size > 5
            :vertical
          else
            :horizontal
          end
        end

        t = Terminal::Table.new

        case orientation
        when :horizontal
          t.headings = arr.first.keys
          t.rows = arr.map(&:values)

        when :vertical
          t.headings = ["Name", "Value"]
          arr.each.with_index do |row, i|
            row.each { |col, val| t.add_row [col, val] }
            t.add_separator if i < arr.size - 1
          end
        end

        t.to_s
      end

      alias_method :tab, :tabulate
      alias_method :table, :tabulate
      alias_method :to_table, :tabulate

      def csv(orientation = nil)
        arr = if is_a?(Array)
          self
        elsif is_a?(::ActiveRecord::Relation)
          to_a
        else
          [self]
        end

        arr = arr.map do |e|
          if e.is_a?(::ActiveRecord::Base)
            values = e.attributes.transform_values do |v|
              next JSON.pretty_generate(v) if v.is_a?(Enumerable) && v.size > 0
              next "NULL" if v.nil?
              next '""' if v == ""
              v.to_s
            end
            next values
          end
          e
        end

        raise "#{arr} is not an array of hash".red unless arr.all? { |e| e.is_a?(Hash) }
        raise "#{arr} contains Hashes with different keys".red unless arr.map(&:keys).uniq.size == 1

        orientation = case orientation
        when :vertical, :v
          :vertical
        when :horizontal, :h
          :horizontal
        else
          if arr.first.keys.size > 5
            :vertical
          else
            :horizontal
          end
        end

        CSV.generate do |csv|
          case orientation
          when :horizontal
            csv << arr.first.keys
            arr.each { |row| csv << row.values }
          when :vertical
            arr.each do |row|
              row.each { |col, val| csv << [col, val] }
              csv << []
            end
          end
        end
      end

      def copy
        Clipboard.copy(to_s)
      end
      alias_method :cp, :copy

      alias_method :j, :to_json

      def jp
        JSON.pretty_generate(JSON.parse(to_json))
      end
    end
  end

  ::Object.include(Extensions::Object)
end
