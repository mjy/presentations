require_relative 'setup'
require 'json'
require 'csv'

# Tommy's collectors 

tommy_id = tommy['id']
tommy_name = tommy['cached']

def get_specimens(collector_id)
  url = LOCAL_URL + '/collecting_events' + '?collector_ids[]=' + collector_id.to_s + '&project_id=1' + '&per=1000' + '&token=' + TOKEN 
  b = URI(url)
  JSON.parse(::Net::HTTP.get(b))
end

def get_born_year(collector_id)
  url = LOCAL_URL + '/people' + '/' + collector_id.to_s + '?project_id=1' + '&token=' + TOKEN 
  b = URI(url)
  p = JSON.parse(::Net::HTTP.get(b))
  p['year_born']
end

tommys_specimens = get_specimens(tommy_id)
ap tommys_specimens.first

@unique_collectors = {
  tommy_id => {
    name: tommy_name,
    born: get_born_year(tommy_id) 
  }
} 

@nodes = []
@links = []

def recurse_collectors(start_id, level = 0)
  specimens = get_specimens(start_id)
  specimens.each do |s|
    s['collector_roles'].each do |r|
      id = r.dig('person', 'id')
      
      next if id == start_id || @unique_collectors.keys.include?(id)
      name = r.dig('person', 'name')
    
      @unique_collectors[id] = { name: name, born: get_born_year(id) }

      @nodes.push({"id": name, "group": level})
      @links.push({
        source_id: start_id,
        target_id: id,
        source: @unique_collectors[start_id][:name], 
        target: name,
        value: 1
      })
      # puts @unique_collectors.join(',')
      puts id.to_s + ',' + start_id.to_s
      recurse_collectors(id, level + 1)
    end
  end
end

recurse_collectors(tommy_id)
ap @nodes
ap @links

def edge_type(year1, year2)
  if year1.nil? || year2.nil?
    'unknown'
  elsif year1.to_i < year2.to_i
    'younger'
  else
    'older'
  end
end


# Write a dataset usable at https://observablehq.com/@d3/mobile-patent-suits?collection=@d3/d3-force

CSV.open('tommy_collectors_connection.csv', "w") do |csv|
  csv << %w{source target type}
  @links.each do |l|
    y1 = @unique_collectors[l[:source_id]][:born]
    y2 = @unique_collectors[l[:target_id]][:born]

    csv << [ l[:source], l[:target], edge_type(y1, y2) ]
  end
end

# Write a dataset usable at https://observablehq.com/@d3/force-directed-graph

data = { "nodes": @nodes, "links": @links }
File.open('tommys_collectors.json', 'w') {|f| f.write(data.to_json) }

