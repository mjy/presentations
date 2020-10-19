require_relative '../../setup'
require 'SVG/Graph/Bar'
require 'csv'

tommys_roles = LOCAL_URL + '/people/' + tommy['id'].to_s + '?include_roles=true' + '&token=' + TOKEN 
puts tommys_roles

b = URI(tommys_roles)
m = JSON.parse(::Net::HTTP.get(b))
ap m
roles = m['roles']

role_data = {}

# Sum the individual roles
roles.each do |r|
  if role_data[r['role_object_type']]
    role_data[r['role_object_type']] += 1
  else
    role_data[r['role_object_type']] = 1
  end
end

ap role_data

x_axis = role_data.sort.collect{|a| a.first}

options = {
  :width             => 640,
  :height            => 300,
  :stack             => :side,
  :fields            => x_axis,
  :graph_title       => "Tommy's roles",
  :show_graph_title  => true,
  :show_x_title      => true,
  :x_title           => 'Type',
  :show_y_title      => true,
  :y_title           => 'Count',
  :y_title_location  => :end,
  :no_css            => true,
  :number_format     => '%s',
  :show_lines        => false,
  :show_x_guidelines => false,
  :show_y_guidelines => false,
  :y_label_format => '%s'
}

g = SVG::Graph::Bar.new(options)

g.add_data( {
  :data => role_data.sort.collect{|a| a.last},
  :title => "Roles",
  :template => '%s'
})


# Write a graph using the Ruby library

File.open('tommys_roles.svg', 'w') {|f| f.write(g.burn_svg_only)}

# Write a dataset to https://www.d3-graph-gallery.com/graph/barplot_ordered.html

CSV.open('tommys_roles.csv', "w") do |csv|
  csv << %w{Role Count}
  role_data.sort.each do |v|
    csv << v
  end
end

