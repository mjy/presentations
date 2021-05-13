# A script to create a "nomenclatural" graph suitable for rendering in GraphViz.
# The script takes data from a TaxonWorks instance and turns it into nodes/edges.
require 'pg'

# Requiers an instance of TaxonWorks database running and accessible as the postgres user
conn = PG.connect( dbname: 'taxonworks_development' )

# Store data here
path = __dir__ + '/data/' 

# Target a specific project
project_id = 13

# Each query builds a set of nodes or edges. Cases statements were pre-generated with reference to color palletes in a color_case.rb
queries = {
  edge_taxon_names: "select concat('t', id) t1, concat('t', parent_id) t2, 'color=slateblue2' color from taxon_names where taxon_names.project_id = #{project_id}",
  edge_taxon_name_classifications: "select concat('t', taxon_name_id) t1, concat('tc', id) t2,  case type when ' TaxonNameClassification::Iczn::Unavailable::Excluded::NotForNomenclature' then 'color=forestgreen' when ' TaxonNameClassification::Latinized::PartOfSpeech::Adjective' then 'color=fuchsia'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::CitationOfUnavailableName' then 'color=gainsboro'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::NoDescription' then 'color=ghostwhite'  when ' TaxonNameClassification::Latinized::PartOfSpeech::NounInApposition' then 'color=gold2'  when ' TaxonNameClassification::Iczn::Available::Invalid' then 'color=goldenrod2'  when ' TaxonNameClassification::Iczn::Unavailable::Suppressed::OfficialIndexOfRejectedGenericNamesInZoology' then 'color=gray'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::NotIndicatedAsNewAfter1999' then 'color=green2'  when ' TaxonNameClassification::Iczn::Unavailable' then 'color=greenyellow'  when ' TaxonNameClassification::Iczn::Fossil' then 'color=honeydew2'  when ' TaxonNameClassification::Iczn::Unavailable::Suppressed::OfficialIndexOfRejectedAndInvalidWorksInZoology' then 'color=hotpink2'  when ' TaxonNameClassification::Latinized::PartOfSpeech::NounInGenitiveCase' then 'color=indianred2'  when ' TaxonNameClassification::Iczn::Unavailable::Suppressed::OfficialIndexOfRejectedSpecificNamesInZoology' then 'color=indigo'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::NoTypeFixationAfter1930' then 'color=invis'  when ' TaxonNameClassification::Iczn::Unavailable::NonBinomial::SpeciesNotBinomial' then 'color=ivory2'  when ' TaxonNameClassification::Iczn::Available::Invalid::HomonymyOfTypeGenus' then 'color=khaki2'  when ' TaxonNameClassification::Iczn::Available::Valid' then 'color=lavender'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::NoDiagnosisAfter1930' then 'color=lavenderblush2'  when ' TaxonNameClassification::Iczn::Unavailable::NotLatin' then 'color=lawngreen'  when ' TaxonNameClassification::Iczn::Available::OfficialListOfFamilyGroupNamesInZoology' then 'color=lemonchiffon2'  when ' TaxonNameClassification::Icn::Hybrid' then 'color=lightblue2'  when ' TaxonNameClassification::Iczn::Unavailable::Suppressed::OfficialIndexOfRejectedFamilyGroupNamesInZoology' then 'color=lightcoral'  when ' TaxonNameClassification::Latinized::PartOfSpeech::Participle' then 'color=lightcyan2'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum' then 'color=lightgoldenrod2'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::NoTypeDepositionStatementAfter1999' then 'color=lightgoldenrodyellow'  when ' TaxonNameClassification::Iczn::Unavailable::Excluded::Infrasubspecific' then 'color=lightgray'  when ' TaxonNameClassification::Latinized::Gender::Neuter' then 'color=lightgreen'  when ' TaxonNameClassification::Iczn::Unavailable::LessThanTwoLetters' then 'color=lightgrey'  when ' TaxonNameClassification::Iczn::Unavailable::NomenNudum::NotFromGenusName' then 'color=lightpink2'  when ' TaxonNameClassification::Latinized::Gender::Feminine' then 'color=lightsalmon2'  when ' TaxonNameClassification::Iczn::Available::OfficialListOfSpecificNamesInZoology' then 'color=lightseagreen'  when ' TaxonNameClassification::Iczn::Available::Invalid::SuppressionOfTypeGenus' then 'color=lightskyblue2'  when ' TaxonNameClassification::Iczn::Unavailable::NonBinomial' then 'color=lightslateblue'  when ' TaxonNameClassification::Latinized::Gender::Masculine' then 'color=lightslategray'  when ' TaxonNameClassification::Iczn::Available::Valid::NomenDubium' then 'color=lightslategrey'  when ' TaxonNameClassification::Iczn::Available::OfficialListOfGenericNamesInZoology' then 'color=lightsteelblue2' else 'color=yellowgreen' end as color from taxon_name_classifications where taxon_name_classifications.project_id = #{project_id}",
  edge_taxon_name_relationships:  "select concat('t', subject_taxon_name_id) t1, concat('t', object_taxon_name_id) t2, case type when 'TaxonNameRelationship::OriginalCombination::OriginalSpecies' then 'color=antiquewhite2'  when 'TaxonNameRelationship::Icn::Unaccepting::Synonym::Heterotypic' then 'color=aqua'  when 'TaxonNameRelationship::Typification::Genus::Subsequent::RulingByCommission' then 'color=aquamarine2'  when 'TaxonNameRelationship::OriginalCombination::OriginalForm' then 'color=azure2'  when 'TaxonNameRelationship::Iczn::Invalidating::Usage::IncorrectOriginalSpelling' then 'color=beige'  when 'TaxonNameRelationship::Icn::Unaccepting::Usage::Basionym' then 'color=bisque2'  when 'TaxonNameRelationship::Typification::Genus::Original::OriginalMonotypy' then 'color=black'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Suppression' then 'color=blanchedalmond'  when 'TaxonNameRelationship::Iczn::Invalidating' then 'color=blue2'  when 'TaxonNameRelationship::Typification::Family' then 'color=blueviolet'  when 'TaxonNameRelationship::Iczn::Invalidating::Misapplication' then 'color=brown2'  when 'TaxonNameRelationship::Combination::Genus' then 'color=burlywood2'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Objective::UnnecessaryReplacementName' then 'color=cadetblue2'  when 'TaxonNameRelationship::Typification::Genus::Original::OriginalDesignation' then 'color=chartreuse2'  when 'TaxonNameRelationship::Iczn::Invalidating::Usage::FamilyGroupNameForm' then 'color=chocolate2'  when 'TaxonNameRelationship::OriginalCombination::OriginalGenus' then 'color=coral2'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Objective::SynonymicHomonym' then 'color=cornsilk2'  when 'TaxonNameRelationship::Iczn::Invalidating::Homonym' then 'color=crimson'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Subjective' then 'color=cyan2'  when 'TaxonNameRelationship::OriginalCombination::OriginalSubspecies' then 'color=darkblue'  when 'TaxonNameRelationship::Iczn::Validating::UncertainPlacement' then 'color=darkcyan'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Objective::ReplacedHomonym' then 'color=darkgoldenrod2'  when 'TaxonNameRelationship::Combination::Subgenus' then 'color=darkgray'  when 'TaxonNameRelationship::Iczn::PotentiallyValidating::FirstRevisorAction' then 'color=darkgreen'  when 'TaxonNameRelationship::Typification::Genus::Subsequent::SubsequentMonotypy' then 'color=darkgrey'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Suppression::Partial' then 'color=darkkhaki'  when 'TaxonNameRelationship::Iczn::Invalidating::Homonym::Primary' then 'color=darkmagenta'  when 'TaxonNameRelationship::Iczn::PotentiallyValidating::FamilyBefore1961' then 'color=darkolivegreen2'  when 'TaxonNameRelationship::Combination::Species' then 'color=darkorange2'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Suppression::Total' then 'color=darkorchid2'  when 'TaxonNameRelationship::Icn::Unaccepting::Synonym::Homotypic' then 'color=darkred'  when 'TaxonNameRelationship::OriginalCombination::OriginalVariety' then 'color=darksalmon'  when 'TaxonNameRelationship::OriginalCombination::OriginalSubgenus' then 'color=darkseagreen2'  when 'TaxonNameRelationship::Combination::Subspecies' then 'color=darkslateblue'  when 'TaxonNameRelationship::Iczn::Invalidating::Usage::Misspelling' then 'color=darkslategray2'  when 'TaxonNameRelationship::Iczn::Invalidating::Homonym::Secondary::Secondary1961' then 'color=darkslategrey'  when 'TaxonNameRelationship::Typification::Genus' then 'color=darkturquoise'  when 'TaxonNameRelationship::Iczn::Invalidating::Homonym::Secondary' then 'color=darkviolet'  when 'TaxonNameRelationship::SourceClassifiedAs' then 'color=deeppink2'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Objective' then 'color=deepskyblue2'  when 'TaxonNameRelationship::Typification::Genus::Subsequent::SubsequentDesignation' then 'color=dimgray'  when 'TaxonNameRelationship::Combination::Variety' then 'color=dimgrey'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::ForgottenName' then 'color=dodgerblue2'  when 'TaxonNameRelationship::Icn::Unaccepting::Usage::Misspelling' then 'color=firebrick2'  when 'TaxonNameRelationship::Iczn::Invalidating::Synonym::Objective::UnjustifiedEmendation' then 'color=floralwhite' else 'color=yellowgreen' end as color from taxon_name_relationships where taxon_name_relationships.project_id = #{project_id}",

  edge_citations_on_taxon_names: "select concat('c', id) t1, concat('t', citation_object_id) t2, 'color=gray' color from citations where citation_object_type = 'TaxonName' and citations.project_id = #{project_id}",
  edge_citations_on_taxon_name_classifications: "select concat('c', id) t1, concat('tc', citation_object_id) t2, 'color=lemonchiffon' color from citations where citation_object_type = 'TaxonNameClassification' and citations.project_id = #{project_id}",
  edge_citations_on_taxon_name_relation_subjects: "select concat('c', c.id) t1, concat('t', subject_taxon_name_id) t2, 'color=lemonchiffon' color from citations c join taxon_name_relationships tnr on c.citation_object_id = tnr.id and c.citation_object_type = 'TaxonNameRelationship' where c.project_id = #{project_id}",
  edge_citations_on_taxon_name_relation_objects: "select concat('c', c.id) t1, concat('t', object_taxon_name_id) t2, 'color=lemonchiffon' color from citations c join taxon_name_relationships tnr on c.citation_object_id = tnr.id and c.citation_object_type = 'TaxonNameRelationship' where c.project_id = #{project_id}",

  node_taxon_names: "select concat('t', id) t1, 'color=black' color from taxon_names where taxon_names.project_id = #{project_id}", #  shape=point if you want to change
  node_citations: "select concat('c', id) t1, 'color=lemonchiffon' color from citations where citation_object_type = 'TaxonName' and citations.project_id = #{project_id}",
  node_taxon_name_classifications: "select concat('tc', id) t1, 'color=lightpink' color from taxon_name_classifications where taxon_name_classifications.project_id = #{project_id}",
}

# Merge the files
graph_data = "#{path}graph.csv"
queries.each do |n, q|
  conn.exec("copy (#{q}) to '#{path}#{n}.csv' with csv" )
end
cat = "cat #{queries.keys.collect{|k| path + k.to_s + '.csv'}.join(' ')} > #{graph_data}"
# Shell out to run the merge
`#{cat}`

# Convert the CSV to .dot format
g = File.new(path + 'graph.txt', 'w')

g.puts 'graph {'
g.puts 'node[label="" shape="point" width="0.005" height="0.005"]'
g.puts 'edge[penwidth=0.1]'

f = File.read(graph_data).split("\n").each do |r|
  c = r.split(',')
  g.print c[0]
  
  case c.size
  when 2
    g.print ' ['
    g.print c[1]

  when 3 
    g.print ' -- '
    g.print c[1]
    g.print ' ['
    g.print c[2]
  end
  
  g.puts ']'
end
g.puts '}'

g.close
