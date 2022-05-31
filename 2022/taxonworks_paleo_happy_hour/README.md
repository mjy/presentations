# TaxonWorks Paleo Happy Hour 2022 

## PaleoDB Data

We found data at [https://paleobiodb.org/classic/displayDownloadGenerator](https://paleobiodb.org/classic/displayDownloadGenerator). We used a script to fetch `https://paleobiodb.org/data1.2/taxa/list.csv?base_name=Onychochilidae&taxon_status=valid&variant=all&show=attr,parent,class,ref` and treat it as a dynamic CSV object that was used to generate a file suitable for batch-import in TaxonWorks.

## Data processing 
Data were processed into the simplest format for batch-importing nomenclature via the user interface in TaxonWorks. Code is in `/src/`.
We piped the results of the script to a derived data file with `ruby go.rb > ../data/derived/Onychochilidae.csv`.

For the purposes of the demonstration where we wanted to show how to add new names, synomyms, and combinations, we script-excluded all rows that referenced the genus `Yuwenia`.

The script used calls the API directly to get the data and produce a CSV file for import:

```
ruby src.go
```
Create a file `my_file.tab`:

```
ruby src.go > my_file.tab 
```

## Batch loading
We used the interfaces  `Data->TaxonName->BatchLoad` to batch load all the names as if they were valid (some are not). We also used the `Data->Source->BatchLoad` to add a BibTeX bibliography.

## Spreadsheet
During the demo we worked from a [Spreadsheet](https://docs.google.com/spreadsheets/d/1fwc0pDpy865YULT727EMiP6SwQ1pXgFPjFPujlsN5qA/edit?usp=sharing), this was essentially the full API result, untrimmed by the script.  This allowed us to add some data not batch-loaded, illustrating TaxonWorks features

## Slides
Most of the presentation was demoed live in TaxonWorks.

[Here](paleo-data-tw-intro-nomenclature-focus_31May2022.pptx.pdf).
