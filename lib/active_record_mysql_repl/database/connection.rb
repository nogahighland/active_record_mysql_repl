# frozen_string_literal: true

module ActiveRecordMysqlRepl
  module Database
    module Connection
      MAX_RETRY = 3

      def self.connect(db_config, port)
        conn = {
          adapter: "mysql2",
          host: "127.0.0.1",
          port: port,
          username: db_config.user,
          password: db_config.password,
          database: db_config.database
        }

        ActiveRecord::Base.logger = Logger.new(STDOUT)
        ActiveRecord::Base.establish_connection(conn)

        puts "Ensureing connection to #{db_config.database} on port 127.0.0.1:#{port}".gray

        tables = nil
        (1..MAX_RETRY - 1).to_a.each do |time|
          tables = ActiveRecord::Base.connection.tables
        rescue => e
          puts "#{e}, Retry #{time}/#{MAX_RETRY}".red
          sleep time * time
          next
        end

        if tables.blank?
          raise "Retred #{MAX_RETRY} times, but failed to connect to database."
        end

        yield if block_given?
      end
    end
  end
end
