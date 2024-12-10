# frozen_string_literal: true

module ActiverecordMysqlRepl
  module Extensions
    module Hash
      def method_missing(name, *args)
        if (self.keys & [name, name.to_s]).present?
          self[name] || self[name.to_s]
        elsif name.to_s.end_with?('=') && self.keys.include?(name.to_s[0..-2])
          name = name[0..-2]
          self[name] = args.first if self.key?(name)
          self[name.to_sym] = args.first if self.key?(name.to_sym)
        end
      end

      ::Hash.include(Hash)
    end
  end
end

