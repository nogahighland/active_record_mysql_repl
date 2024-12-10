# frozen_string_literal: true

require 'net/ssh'
require 'net/ssh/gateway'

module ActiveRecordMysqlRepl
  module SSHTunnel
    EPHEMERAL_PORT = 0

    def self.tunnel(db_config)
      return yield(db_config.port) if block_given? unless db_config.bastion

      puts "Establishing ssh tunnel to #{db_config.remote_host}:#{db_config.port} via #{db_config.ssh_user}#{db_config.bastion}".gray

      gateway = Net::SSH::Gateway.new(db_config.bastion, db_config.ssh_user)
      gateway.open(db_config.remote_host, db_config.port) do |port|
        yield(port) if block_given?
      end
    end
  end
end
