% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/coo-ldk-utilities.R
\name{get_slidings}
\alias{get_slidings}
\title{Extracts sliding landmarks coordinates}
\usage{
get_slidings(Coo, partition)
}
\arguments{
\item{Coo}{an Ldk object}

\item{partition}{numeric which one(s) to get.}
}
\value{
a list of list(s) of coordinates.
}
\description{
From an \link{Ldk} object.
}
\examples{
# for each example below a list with partition containign shapes is returned
# extracts the first partition
get_slidings(chaff, 1) \%>\% names()
# the first and the fourth
get_slidings(chaff, c(1, 4)) \%>\%  names()
# all of them
get_slidings(chaff) \%>\%  names
# here we want to see it
get_slidings(chaff, 1)[[1]] \%>\%  Ldk \%>\% stack
}
\seealso{
Other ldk/slidings methods: 
\code{\link{add_ldk}()},
\code{\link{def_ldk}()},
\code{\link{def_slidings}()},
\code{\link{get_ldk}()},
\code{\link{rearrange_ldk}()},
\code{\link{slidings_scheme}()}
}
\concept{ldk/slidings methods}
