require_relative 'setup'
require 'json'
require 'csv'

project = 1 

# curl '127.0.0.1:3000/api/v1/collection_objects/1164994/digital_specimen_example?token=DSAsj1HepILcmA8N4WXKVA&project_id=1' | jq 


url = LOCAL_URL + '/collection_objects' + '/1164994' + '/digital_specimen_example' + '?project_id=' + project.to_s + '&token=' + TOKEN 
b = URI(url)
object = JSON.parse(::Net::HTTP.get(b))
puts b
ap object

@links = [ ]

def add_link(source, target, type)
  @links.push({
    source: source,
    target: target,
    type: type 
  })

end


object['related'].each do |r|
  add_link(
     object['collection_object']['global_id'],
     r['global_id'],
     r['type']
  )

  if r['roles']
    r['roles'].each do |s|
      add_link(
        r['global_id'],
        s.dig('person', 'global_id'),
        s['type']
      )
    end
  end

  if r['biological_association_object']
    add_link(
      r['global_id'],
      r.dig('biological_association_object', 'global_id'),
      r.dig('biological_association_object', 'type'),
    )
  end
end


# Write a dataset usable at https://observablehq.com/@d3/mobile-patent-suits?collection=@d3/d3-force

CSV.open('digital_specimen.csv', "w") do |csv|
  csv << %w{source target type}
  @links.each do |l|
    csv << [ l[:source], l[:target], l[:type] ]
  end
end

# Write a dataset usable at https://observablehq.com/@d3/force-directed-graph

# data = { "nodes": @nodes, "links": @links }
# File.open('digital_specimen.json', 'w') {|f| f.write(data.to_json) }




=begin

names.each do |n|
  y = n['year'].nil? ? 9999 : n['year']
  valid = (n['id'] == n['cached_valid_taxon_name_id'] ? 'valid' : 'invalid')

  if names_year[y]
    if names_year[y][valid]
      names_year[y][valid] += 1
    else
      names_year[y][valid] = 1
    end
  else
    names_year[y] = { valid => 1 }
  end
end

# ap names_year

CSV.open('cucujoidea_valid_year.csv', "w") do |csv|
  csv << %w{year valid invalid}
  (1758..2020).each do |y|
#  names_year.keys.sort.each do |y|
    csv << [ y, (names_year.dig(y, 'valid') ? names_year.dig(y, 'valid') : 0) , (names_year.dig(y, 'invalid') ? names_year.dig(y, 'invalid') : 0) ]
  end
end

=end
