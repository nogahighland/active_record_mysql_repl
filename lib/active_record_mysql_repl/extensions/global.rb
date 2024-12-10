# frozen_string_literal: true

module ActiverecordMysqlRepl
  module Extensions
    module Global
      def tables
        ::ActiveRecord::Base.connection.tables.map(&:singularize).map(&:classify)
      end

      def models
        ::ActiveRecord::Base.subclasses
      end

      def transaction
        ::ActiveRecord::Base.transaction { yield }
      end

      def exec_sql(sql)
        res = ::ActiveRecord::Base.connection.select_all(sql)
        res.rows.map do |row|
          res.columns.zip(row).to_h
        end
      end
    end

    Kernel.include(Global)
  end
end

