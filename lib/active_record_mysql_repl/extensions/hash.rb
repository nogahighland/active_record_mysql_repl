# frozen_string_literal: true

module ActiverecordMysqlRepl
  module Extensions
    module Hash
      def method_missing(name, *args)
        if (keys & [name, name.to_s]).present?
          self[name] || self[name.to_s]
        elsif name.to_s.end_with?("=") && keys.include?(name.to_s[0..-2])
          name = name[0..-2]
          self[name] = args.first if key?(name)
          self[name.to_sym] = args.first if key?(name.to_sym)
        end
      end

      def respond_to_missing?(sym, include_private)
        (keys & [name, name.to_s]).present? || name.to_s.end_with?("=") && keys.include?(name.to_s[0..-2])
      end

      ::Hash.include(Hash)
    end
  end
end
