# frozen_string_literal: true

require 'rails_erd/diagram/graphviz'

module ActiveRecordMysqlRepl
  module Erd
    def generate
      RailsERD::Diagram::Graphviz.create
    end
  end
end
