# frozen_string_literal: true

module ActiverecordMysqlRepl
  module Extensions
    module ActiveRecord
      module Base
        def as(name = nil)
          self.reflect_on_all_associations(name).map(&:name)
        end

        def describe
          [
            exec_sql("DESCRIBE #{self.table_name}").tab(:h),
            exec_sql("SHOW INDEX FROM #{self.table_name}").tab(:h)
          ].join("\n")
        end

        alias desc describe
        alias d describe

        def show_ddl
          exec_sql("SHOW CREATE TABLE #{self.table_name}")[0]['Create Table']
        end

        alias ddl show_ddl
      end

      ::ActiveRecord::Base.extend(Base)
    end
  end
end

