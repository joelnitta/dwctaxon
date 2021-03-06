% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dct_add_row.R
\name{dct_add_row}
\alias{dct_add_row}
\title{Add one entry to a taxonomic database}
\usage{
dct_add_row(tax_dat, taxon_id = NULL, sci_name, strict = FALSE, ...)
}
\arguments{
\item{tax_dat}{Dataframe; taxonomic database in Darwin Core format}

\item{taxon_id}{taxonID to use for new entry; optional, will be
assigned automatically if not provided.}

\item{sci_name}{scientificName to use for new entry}

\item{strict}{Logical; should taxonomic checks be run on the updated
taxonomic database?}

\item{...}{Additional data to include, specified as sets of named
character strings; e.g., \code{parentNameUsageID = "6SH4"}. The name of
each string must be a valid column name for data in Darwin Core format.}
}
\value{
Dataframe; taxonomic database in Darwin Core format
}
\description{
Add one entry to a taxonomic database
}
\examples{
tibble::tibble(
  taxonID = "123",
  scientificName = "Foogenus barspecies"
) |>
dct_add_row(
  sci_name = "Foogenus barspecies var. bla",
  parentNameUsageID = "123",
  nameAccordingTo = "me",
  strict = TRUE
)
}
