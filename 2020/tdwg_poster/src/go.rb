require_relative 'setup'
require 'json'
require 'csv'

tommy_id = tommy['id']
tommy_name = tommy['cached']

project = 14 

url = LOCAL_URL + '/taxon_names' + '?nomenclature_group=' + 'Species'  + '&project_id=' + project.to_s +  '&per=10000' + '&token=' + TOKEN 
b = URI(url)
names  = JSON.parse(::Net::HTTP.get(b))
puts b
puts names.count

names_year = {}

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

