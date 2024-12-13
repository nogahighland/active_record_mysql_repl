# frozen_string_literal: true

COMPLETION = <<~COMPLETION
  #!/usr/bin/env bash
  
  function _army() {
    _arguments \
      '-c[path to .armyrc file]:.armyrc:_files' \
      '-d[Database name]:database:->database' \
      '-e[output erd]:output erd:->erd'
  
    case "$state" in
      database)
        slice=("${words[@]:1}")
        _values 'Database name' $(_database ${slice})
        ;;
      erd)
        _values 'Generate ERD' erd ''
    esac
  }
  
  function _database {
    army ${@}
  }
  
  compdef _army army
COMPLETION

module ActiveRecordMysqlRepl
  module CLI
    module ZshCompletion
      def self.generate
        COMPLETION
      end
    end
  end
end
