# frozen_string_literal: true

require_relative "active_record_mysql_repl/version"
require_relative 'active_record_mysql_repl/config'
require_relative 'active_record_mysql_repl/cli'
require_relative 'active_record_mysql_repl/database'
require_relative 'active_record_mysql_repl/ssh_tunnel'
require_relative 'active_record_mysql_repl/version'
# extensions should be loaded after database connection is established
# require_relative 'active_record_mysql_repl/extensions'

module ActiveRecordMysqlRepl; end
