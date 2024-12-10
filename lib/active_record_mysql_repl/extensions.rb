# frozen_string_literal: true

require_relative 'extensions/object'
require_relative 'extensions/global'
require_relative 'extensions/active_record'
require_relative 'extensions/hash'
require_relative 'extensions/tabler'

module ActiveRecordMysqlRepl
  module Extensions
    def self.load_external(dir)
      Dir.glob("#{dir}/*.rb").each do |file|
        require file
      end
    end
  end
end

