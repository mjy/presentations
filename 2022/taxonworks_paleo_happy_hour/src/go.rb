# This script was used in the TaxonWorks Paleo Happy Hour presentation.
# It calls the peleobiodb.org API, gets a result, and turns it in to a simplified CSV file suitable for batch loading into TaxonWorks.

require 'open-uri'
require 'csv'
require 'amazing_print'
require 'byebug'

query = 'https://paleobiodb.org/data1.2/taxa/list.csv?base_name=Onychochilidae&taxon_status=valid&variant=all&show=attr,parent,class,ref'

f = CSV.new(URI.open(query),col_sep: ",", headers: true)

# Alternately read from a local file
# f = CSV.read('../data/original/pbdb_data.csv', col_sep: ",", headers: true)

ranks = %w{phylum class order family genus}
all_ranks = %w{phylum class order family subfamily genus subgenus species}

d = [] # One record per export row.
observed_ranks = []

f.each do |row|

  # Skip some records for the purposes of the demonstration.
  next if (row['taxon_name'] =~ /Yuwenia/) || (row['genus'] =~ /Yuwenia/)
  
  n = {} 
  ranks.each do |r|
    n[r] = row[r]
  end

  n[row['taxon_rank']] = row['taxon_name'].split(' ').last

  n['author_year'] = row['taxon_attr'] 
  d.push n
  observed_ranks.push row['taxon_rank']
end

if ARGV.include? 'debug' 
  a = (observed_ranks.uniq - all_ranks)
  if !a.empty?
    puts "you missed #{a}!"
  else
    puts "all ranks accounted for"
  end
end

print all_ranks.join("\t")
puts "\tauthor_year"
d.each do |record|
 all_ranks.each do |r|
   print record[r]&.gsub(/[\(\)]/, '') # Strip parenthesis from Subgenus etc.
   print "\t"
 end
 print record['author_year']
 print "\n"
end









