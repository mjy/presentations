

# turn a three column "edge" csv with the third column attributes into a graph

puts 'graph {'
puts 'node[label="" shape="point"]'


f = File.read('data/citations.csv').split("\n").each do |r|
  c = r.split(',')
  print c[0]
  print ' -- '
  print c[1]
  print ' ['
  print c[2]
  puts ']'
end
puts '}'
