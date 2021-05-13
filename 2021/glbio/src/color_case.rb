# Creates a SQL CASE statement that produces a color refrence for each type of incoming data

field = 'type'

# Swap out  references to files as needed
values = File.open('config/observed_taxon_name_classifications.txt').read.split("\n")

# x11 colors
colors = File.open('config/reduced_palette.txt').read.split("\n")

puts

print 'case ' + field 
values.each_with_index do |v, i|
  print " when '#{v}' then 'color=#{colors[i + 46]}' "
end
print " else 'color=yellowgreen' end as color"

puts
puts
