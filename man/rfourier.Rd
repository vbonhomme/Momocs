% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/core-out-rfourier.R
\name{rfourier}
\alias{rfourier}
\alias{rfourier.default}
\alias{rfourier.Out}
\alias{rfourier.list}
\title{Radii variation Fourier transform (equally spaced radii)}
\usage{
rfourier(x, ...)

\method{rfourier}{default}(x, nb.h, smooth.it = 0, norm = FALSE, ...)

\method{rfourier}{Out}(x, nb.h = 40, smooth.it = 0, norm = TRUE, thres = pi/90, ...)

\method{rfourier}{list}(x, ...)
}
\arguments{
\item{x}{A \code{list} or \code{matrix} of coordinates or an \code{Out} object}

\item{...}{useless here}

\item{nb.h}{\code{integer}. The number of harmonics to use. If missing, 12 is used on shapes;
99 percent of harmonic power on Out objects, both with messages.}

\item{smooth.it}{\code{integer}. The number of smoothing iterations to
perform.}

\item{norm}{\code{logical}. Whether to scale the outlines so that the mean
length of the radii used equals 1.}

\item{thres}{\code{numeric} a tolerance to feed \link{is_equallyspacedradii}}
}
\value{
A list with following components:
\itemize{
\item \code{an} vector of \eqn{a_{1->n}} harmonic coefficients
\item \code{bn} vector of \eqn{b_{1->n}} harmonic coefficients
\item \code{ao} ao harmonic coefficient.
\item \code{r} vector of radii lengths.
}
}
\description{
\code{rfourier} computes radii variation Fourier analysis from a matrix or a
list of coordinates where points are equally spaced radii.
}
\details{
see the JSS paper for the maths behind. The methods for \code{Out} objects
tests if coordinates have equally spaced radii using \link{is_equallyspacedradii}. A
message is printed if this is not the case.
}
\note{
Silent message and progress bars (if any) with \code{options("verbose"=FALSE)}.

Directly borrowed for Claude (2008), and called \code{fourier1} there.
}
\examples{
data(bot)
coo <- coo_center(bot[1]) # centering is almost mandatory for rfourier family
coo_plot(coo)
rf  <- rfourier(coo, 12)
rf
rfi <- rfourier_i(rf)
coo_draw(rfi, border='red', col=NA)

# Out method
bot \%>\% rfourier()
}
\references{
Claude, J. (2008) \emph{Morphometrics with R}, Use R! series,
Springer 316 pp.
}
\seealso{
Other rfourier: 
\code{\link{rfourier_i}()},
\code{\link{rfourier_shape}()}
}
\concept{rfourier}
