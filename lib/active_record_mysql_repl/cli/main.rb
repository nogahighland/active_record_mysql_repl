#!/usr/bin/env ruby

require 'pry'
require 'colorize'
require 'active_support'
require 'active_support/core_ext'
require 'fileutils'

module ActiveRecordMysqlRepl
  module CLI
    module Main
      def self.run(args)
        opts = CLI::Options.parse(args)
        army_config = Config.load(opts[:c] || '~/.army.yml')

        db_configs = Database::Configs.load(army_config.database_config)
        db_config_key = opts[:d]
        db_config = db_configs[db_config_key]
        return puts db_configs.keys unless db_config

        generate_erf = opts[:e] == 'erd'

        SSHTunnel.tunnel(db_config) do |port|
          Database::Connection.connect(db_config, port) do
            Database::Loader.load_tables(db_config_key, army_config, port)

            if generate_erf
              require 'rails_erd/diagram/graphviz'
              puts "Generating ERD for #{db_config_key}_erd.pdf".gray
              RailsERD::Diagram::Graphviz.create
              FileUtils.mv('erd.pdf', "#{db_config_key}_erd.pdf")
              return
            end

            require 'active_record_mysql_repl/extensions'
            if army_config.extensions_dir.present?
              puts "Loading custom extensions from #{army_config.extensions_dir}".gray
              Extensions.load_external(army_config.extensions_dir)
            end

            clear_screen
            Pry.config.prompt_name = db_config_key.black.send(:"on_#{db_config.prompt_color}")
            Pry.config.rc_file = army_config.pryrc if army_config.pryrc.present?
            Pry.start
          end
        end
      end

      def self.clear_screen
        system('clear')
        system('cls')
      end
    end
  end
end
