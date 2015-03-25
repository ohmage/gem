require 'formatador'

module Ohmage
  module CliHelpers
    def self.format_output(d, table, fields, no_table_field) # rubocop:disable MethodLength
      # accepts an ohmage entity array and returns output (table or newline given table boolean)
      output = []
      d.each do |i|
        @line = {}
        fields.each do |f|
          @line.merge!(f.to_sym => i.send(f).to_s)
        end
        output << @line
      end
      if table
        Formatador.display_compact_table(output, fields)
      else
        output.each do |v|
          Formatador.display_line(v[no_table_field])
        end
      end
    end
  end
end
