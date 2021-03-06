% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/min_dist.R
\name{min_dist}
\alias{min_dist}
\title{Calculating the minimum distance}
\usage{
min_dist(smap, grouping = rep(1, nrow(smap)))
}
\arguments{
\item{smap}{A matrix showing a spatial map. The first and second column include spatial points along a x-axis and y-axis, respectively.}

\item{grouping}{A integer vector assigning each individual to a group. This argument can be useful when a "smap" contains different experimental replicates. Default setting means that all individuals are belong to a single group.}
}
\value{
Return a scalar of the minimum Euclidian distance that allows all individuals to have at least one neighbor.
}
\description{
A function to calculate a Euclidian distance including at least one neighbor for all individuals.
}
\author{
Yasuhiro Sato (\email{sato.yasuhiro.36c@kyoto-u.jp})
}
