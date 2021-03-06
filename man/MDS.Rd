% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mult-NMDS.R
\name{MDS}
\alias{MDS}
\title{(Metric) multidimensional scaling}
\usage{
MDS(x, method = "euclidean", k = 2, ...)
}
\arguments{
\item{x}{any \link{Coe} object}

\item{method}{a dissiminarity index to feed \code{method} in \link[stats:dist]{stats::dist} (default: \code{euclidean})}

\item{k}{\code{numeric} number of dimensions to feed \link[stats:cmdscale]{stats::cmdscale} (default: 2)}

\item{...}{additional parameters to feed \link[stats:cmdscale]{stats::cmdscale}}
}
\value{
what is returned by \link[stats:dist]{stats::dist} plus \verb{$fac}. And prepend \code{MDS} class to it.
}
\description{
A wrapper around \link[stats:cmdscale]{stats::cmdscale}.
}
\details{
For Details, see \link[vegan:metaMDS]{vegan::metaMDS}
}
\examples{
x <- bot \%>\% efourier \%>\% MDS
x


}
\seealso{
Other multivariate: 
\code{\link{CLUST}()},
\code{\link{KMEANS}()},
\code{\link{KMEDOIDS}()},
\code{\link{LDA}()},
\code{\link{MANOVA_PW}()},
\code{\link{MANOVA}()},
\code{\link{MSHAPES}()},
\code{\link{NMDS}()},
\code{\link{PCA}()},
\code{\link{classification_metrics}()}
}
\concept{multivariate}
