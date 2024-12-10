# frozen_string_literal: true

module ActiveRecordMysqlRepl
  module CLI
    module Options
      def self.parse(args)
        %w[c d e].map do |key|
          [key.to_sym, args.index("-#{key}") ? args[args.index("-#{key}") + 1] : nil]
        end.to_h
      end
    end
  end
end
