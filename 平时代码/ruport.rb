require 'rubygems'
require 'ruport'
table = Ruport::Data::Table.new :column_names => ["country","wine"],
        :data => [["Framce","Bordeaux"],["China","Erba"]]
puts table.to_text
