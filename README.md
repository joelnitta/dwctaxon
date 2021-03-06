
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dwctaxon

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![DOI](https://zenodo.org/badge/434126221.svg)](https://zenodo.org/badge/latestdoi/434126221)
<!-- badges: end -->

The goal of dwctaxon is to facilitate working with [Darwin Core Taxon
data](https://dwc.tdwg.org/terms/#taxon) in R.

The typical use-case of dwctaxon is not create Darwin Core Taxon
datasets from scratch (although you could do that), but rather to enable
easy modification and validation of existing datasets.

The primary motivation for validation is so that the dataset can be used
for taxonomic name resolution, for example with the
[taxastand](https://github.com/joelnitta/taxastand) R package.

## Installation

You can install dwctaxon from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("joelnitta/dwctaxon")
```

## Usage

First, load packages and a dataset to work with:

``` r
library(taxastand)
library(tibble)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(dwctaxon)

filmy_taxonomy
#> # A tibble: 2,729 × 31
#>     taxonID identifier   datasetID datasetName acceptedNameUsa… parentNameUsage…
#>       <dbl> <chr>            <dbl> <chr>                  <dbl>            <dbl>
#>  1 54115096 f5950556e57…       140 World Fern…               NA         54830341
#>  2 54133783 <NA>               140 World Fern…         54115097               NA
#>  3 54115097 bb5e2f01763…       140 World Fern…               NA         54830341
#>  4 54133784 <NA>               140 World Fern…         54115098               NA
#>  5 54115098 002e095eec0…       140 World Fern…               NA         54830341
#>  6 54133785 <NA>               140 World Fern…         54115099               NA
#>  7 54115099 4bd27cdc1fd…       140 World Fern…               NA         54830341
#>  8 54133786 <NA>               140 World Fern…         54115100               NA
#>  9 54133787 <NA>               140 World Fern…         54115100               NA
#> 10 54133788 <NA>               140 World Fern…         54115100               NA
#> # … with 2,719 more rows, and 25 more variables: taxonomicStatus <chr>,
#> #   taxonRank <chr>, verbatimTaxonRank <chr>, scientificName <chr>,
#> #   kingdom <chr>, phylum <chr>, class <chr>, order <chr>, superfamily <lgl>,
#> #   family <chr>, genericName <chr>, genus <chr>, subgenus <lgl>,
#> #   specificEpithet <chr>, infraspecificEpithet <chr>,
#> #   scientificNameAuthorship <chr>, source <lgl>, namePublishedIn <lgl>,
#> #   nameAccordingTo <chr>, modified <chr>, description <chr>, …
```

`filmy_taxonomy` is a taxonomic dataset of filmy ferns included in the
`taxastand` package.

All functions in the `dwctaxon` package start with `dwc_`.

### Validate taxonomy

``` r
# Data not meeting Darwin Core Taxon standards will error
dct_validate(filmy_taxonomy)
#> Error: `check_col_names` failed. Invalid column names present: identifier, superfamily, source, description, isExtinct. See dct_terms for valid column names.
```

### Fix taxonomy

``` r
filmy_taxonomy_fixed <- dct_fix_format(filmy_taxonomy)
#> Dropping the following non-standard columns: identifier, superfamily, source, description, isExtinct
#> Coercing column taxonID from numeric to character
#> Coercing column datasetID from numeric to character
#> Coercing column acceptedNameUsageID from numeric to character
#> Coercing column parentNameUsageID from numeric to character
#> Coercing column subgenus from logical to character
#> Coercing column namePublishedIn from logical to character
#> Coercing column taxonConceptID from logical to character

# Now the validation passes
dct_validate(filmy_taxonomy_fixed)
#> # A tibble: 2,729 × 26
#>    taxonID  datasetID datasetName              acceptedNameUsa… parentNameUsage…
#>    <chr>    <chr>     <chr>                    <chr>            <chr>           
#>  1 54115096 140       World Ferns in Species … <NA>             54830341        
#>  2 54133783 140       World Ferns in Species … 54115097         <NA>            
#>  3 54115097 140       World Ferns in Species … <NA>             54830341        
#>  4 54133784 140       World Ferns in Species … 54115098         <NA>            
#>  5 54115098 140       World Ferns in Species … <NA>             54830341        
#>  6 54133785 140       World Ferns in Species … 54115099         <NA>            
#>  7 54115099 140       World Ferns in Species … <NA>             54830341        
#>  8 54133786 140       World Ferns in Species … 54115100         <NA>            
#>  9 54133787 140       World Ferns in Species … 54115100         <NA>            
#> 10 54133788 140       World Ferns in Species … 54115100         <NA>            
#> # … with 2,719 more rows, and 21 more variables: taxonomicStatus <chr>,
#> #   taxonRank <chr>, verbatimTaxonRank <chr>, scientificName <chr>,
#> #   kingdom <chr>, phylum <chr>, class <chr>, order <chr>, family <chr>,
#> #   genericName <chr>, genus <chr>, subgenus <chr>, specificEpithet <chr>,
#> #   infraspecificEpithet <chr>, scientificNameAuthorship <chr>,
#> #   namePublishedIn <chr>, nameAccordingTo <chr>, modified <chr>,
#> #   taxonConceptID <chr>, scientificNameID <chr>, references <chr>
```

### Add rows

``` r
filmy_taxonomy_fixed |>
    dct_add_row(sci_name = "Hymenophyllum dwctaxonense Nitta", taxonomicStatus = "accepted") |>
    # The new row is added at the end. Slice to that so we can see it.
    slice_tail(n = 1) |>
    select(taxonID, taxonomicStatus, scientificName, modified)
#> # A tibble: 1 × 4
#>   taxonID                          taxonomicStatus scientificName       modified
#>   <chr>                            <chr>           <chr>                <chr>   
#> 1 193e2011c8ace0ed138af91f41a335cc accepted        Hymenophyllum dwcta… 2022-03…
```

### Change status

``` r
filmy_taxonomy_fixed |>
    # The modified entry is 'taxonomicStatus' of the second row. Slice to that so we can see it.
    dct_change_status(taxon_id = "54133783", new_status = "accepted") |>
    slice_head(n = 2) |>
    select(taxonID, taxonomicStatus, scientificName, modified)
#> # A tibble: 2 × 4
#>   taxonID  taxonomicStatus scientificName                modified           
#>   <chr>    <chr>           <chr>                         <chr>              
#> 1 54115096 accepted name   Cephalomanes atrovirens Presl Nov 2018           
#> 2 54133783 accepted        Trichomanes crassum Copel.    2022-03-28 13:37:56
```

### Piping

All the functions in dwctaxon take a dataframe as their first argument,
so they are “pipe-friendly” and can be chained together:

``` r
filmy_taxonomy |>
    dct_fix_format() |>
    dct_change_status(taxon_id = "54133783", new_status = "accepted") |>
    dct_add_row(sci_name = "Hymenophyllum dwctaxonense Nitta", taxonomicStatus = "accepted") |>
    dct_validate()
#> Dropping the following non-standard columns: identifier, superfamily, source, description, isExtinct
#> Coercing column taxonID from numeric to character
#> Coercing column datasetID from numeric to character
#> Coercing column acceptedNameUsageID from numeric to character
#> Coercing column parentNameUsageID from numeric to character
#> Coercing column subgenus from logical to character
#> Coercing column namePublishedIn from logical to character
#> Coercing column taxonConceptID from logical to character
#> # A tibble: 2,730 × 26
#>    taxonID  datasetID datasetName              acceptedNameUsa… parentNameUsage…
#>    <chr>    <chr>     <chr>                    <chr>            <chr>           
#>  1 54115096 140       World Ferns in Species … <NA>             54830341        
#>  2 54133783 140       World Ferns in Species … <NA>             <NA>            
#>  3 54115097 140       World Ferns in Species … <NA>             54830341        
#>  4 54133784 140       World Ferns in Species … 54115098         <NA>            
#>  5 54115098 140       World Ferns in Species … <NA>             54830341        
#>  6 54133785 140       World Ferns in Species … 54115099         <NA>            
#>  7 54115099 140       World Ferns in Species … <NA>             54830341        
#>  8 54133786 140       World Ferns in Species … 54115100         <NA>            
#>  9 54133787 140       World Ferns in Species … 54115100         <NA>            
#> 10 54133788 140       World Ferns in Species … 54115100         <NA>            
#> # … with 2,720 more rows, and 21 more variables: taxonomicStatus <chr>,
#> #   taxonRank <chr>, verbatimTaxonRank <chr>, scientificName <chr>,
#> #   kingdom <chr>, phylum <chr>, class <chr>, order <chr>, family <chr>,
#> #   genericName <chr>, genus <chr>, subgenus <chr>, specificEpithet <chr>,
#> #   infraspecificEpithet <chr>, scientificNameAuthorship <chr>,
#> #   namePublishedIn <chr>, nameAccordingTo <chr>, modified <chr>,
#> #   taxonConceptID <chr>, scientificNameID <chr>, references <chr>
```

It’s often a good idea to include `dct_validate()` to make sure the
modified taxonomic database is still correctly formatted.

## Citing this package

If you use this package, please cite it! Here is an example:

    Nitta, JH (2021) dwctaxon: Tools for working with Darwin Core Taxon data in R. https://doi.org/10.5281/zenodo.6388271

The example DOI above is for the overall package.

Here is the latest DOI, which you should use if you are using the latest
version of the package:

[![DOI](https://zenodo.org/badge/434126221.svg)](https://zenodo.org/badge/latestdoi/434126221)

You can find DOIs for older versions by viewing the “Releases” menu on
the right.

## License

[MIT License](LICENSE.md)
