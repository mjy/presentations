require_relative '../../setup'
require 'SVG/Graph/Bar'
require 'csv'

# Tommy's specimens

tommys_specimens = LOCAL_URL + '/collecting_events' + '?collector_ids[]=' +  tommy['id'].to_s + '&project_id=1' + '&per=10000' + '&token=' + TOKEN 
puts tommys_specimens

b = URI(tommys_specimens)
m = JSON.parse(::Net::HTTP.get(b))
ap m.count

ap m.first

collection_by_year = {}

m.each do |s|
  y =  collection_by_year[s['start_date_year']] 
  if y
    collection_by_year[s['start_date_year']]  += 1
  else
    collection_by_year[s['start_date_year']] = 1
  end
end

puts collection_by_year

x_axis = collection_by_year.sort.collect{|a| a.first}

options = {
  :width             => 640,
  :height            => 300,
  :stack             => :side,
  :fields            => x_axis,
  :graph_title       => "Tommy's collecting",
  :show_graph_title  => true,
  :show_x_title      => true,
  :x_title           => 'Type',
  :show_y_title      => true,
  :y_title           => 'Count',
  :y_title_location  => :end,
  :no_css            => true,
  :show_lines        => false,
  :show_x_guidelines => false,
  :show_y_guidelines => false,
  :y_label_format => '%s',
   number_format: '%1i',
}

g = SVG::Graph::Bar.new(options)

g.add_data( {
  :data => collection_by_year.sort.collect{|a| a.last},
  :title => "Year",
  :template => '%s'
})

File.open('tommys_collecting.svg', 'w') {|f| f.write(g.burn_svg_only)}

# Write a dataset to https://www.d3-graph-gallery.com/graph/barplot_ordered.html

CSV.open('tommys_collecting.csv', "w") do |csv|
  csv << %w{Year Count}
  collection_by_year.sort.each do |v|
    csv << v
  end
end



