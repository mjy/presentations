require_relative 'setup'

# Find Tommy's Identifiers

tommys_ids = LOCAL_URL + '/identifiers?' + 'object_global_id=' + tommy['global_id'] + '&project_id=1' + '&token=' + TOKEN
puts tommys_ids
b = URI(tommys_ids)
m = JSON.parse(::Net::HTTP.get(b))
ap m
