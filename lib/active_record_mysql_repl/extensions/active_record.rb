# frozen_string_literal: true

module ActiverecordMysqlRepl
  module Extensions
    module ActiveRecord
      module Base
        def as(name = nil)
          reflect_on_all_associations(name).map(&:name)
        end

        def describe
          [
            "# #{table_name}",
            exec_sql("DESCRIBE #{table_name}").tab(:h),
            exec_sql("SHOW INDEX FROM #{table_name}").tab(:h)
          ].join("\n")
        end

        alias_method :desc, :describe
        alias_method :d, :describe

        def show_ddl
          exec_sql("SHOW CREATE TABLE #{table_name}")[0]["Create Table"]
        end

        alias_method :ddl, :show_ddl
      end

      ::ActiveRecord::Base.extend(Base)
    end
  end
end
