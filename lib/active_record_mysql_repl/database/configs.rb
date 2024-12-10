# frozen_string_literal: true

module ActiveRecordMysqlRepl
  module Database
    class Configs
      attr_reader :configs

      def self.load(path)
        new(YAML.load_file(path))
      end

      def [](key)
        configs[key]
      end

      def keys
        configs.keys
      end

      private

      def initialize(configs)
        @configs = configs.map { |key, config| [key, Config.new(config)] }.to_h
      end
    end

    private

    class Config
      attr_reader *%i[
        bastion
        ssh_user
        remote_host
        database
        port
        user
        password
        prompt_color
      ]

      def initialize(config)
        @bastion = config["bastion"]
        @ssh_user = config["ssh_user"]
        @remote_host = config["remote_host"]
        @database = config["database"]
        @port = config["port"]
        @user = config["user"]
        @password = config["password"]
        @prompt_color = config["prompt_color"]
      end
    end
  end
end
