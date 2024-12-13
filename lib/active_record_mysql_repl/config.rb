# frozen_string_literal: true

require "yaml"

module ActiveRecordMysqlRepl
  class Config
    def self.load(path)
      new(path, YAML.load_file(path))
    end

    def database_config
      raise "database_config is not defined" unless @database_config
      File.join(@army_config_dir, @database_config)
    end

    def associations
      File.join(@army_config_dir, @associations) if @associations.present?
    end

    def extensions_dir
      File.join(@army_config_dir, @extensions_dir) if @extensions_dir.present?
    end

    def pryrc
      File.join(@army_config_dir, @pryrc) if @pryrc.present?
    end

    private

    def initialize(path, config)
      @army_config_dir = File.dirname(File.absolute_path(path))
      @database_config = config["database_config"]
      @associations = config["associations"]
      @extensions_dir = config["extensions_dir"]
      @pryrc = config["pryrc"]
    end
  end
end
