##### Main Coo (Out/Opn/Ldk) plotters

# plot ----------------------------------------------------
#' Plots Coo objects: plot (quick review)
#'
#' Allows to plot shapes, individually, for \link{Coo} (\link{Out}, \link{Opn} or \link{Ldk}) objects.
#' @param x the \link{Coo} object
#' @param id the id of the shape to plot, if not provided a
#' random shape is plotted. If passed with \code{'all'} all shapes are plotted,
#' one by one.
#' @param ... further arguments to be passed to \link{coo_plot}
#' @keywords Graphics Out Opn Ldk
#' @seealso \link{panel.Coo}, \link{stack.Coo}.
#' @examples
#' \dontrun{
#' data(bot)
#' plot(bot, 5)
#' plot(bot)
#' plot(bot, 5, pch=3, points=TRUE) # an example of '...' use
#' }
#' @method plot Coo
#' @export
plot.Coo <- function(x, id, ...) {
  Coo <- x
  if (missing(id)) {
    repeat {
      id <- sample(length(Coo), 1)
      coo_plot(Coo$coo[[id]], main = names(Coo)[id], ...)
      readline(prompt = "Press <Enter> to continue, <Esc> to quit...")
    }
  }
  if (id[1] == "all") {
    id <- 1:length(Coo)
  }
  if (is.numeric(id)) {
    if (length(id) == 1) {
      coo_plot(Coo$coo[[id]], main = names(Coo)[id], ...)
    } else {
      for (i in seq(along = id)) {
        coo_plot(Coo$coo[[id[i]]], main = names(Coo)[id[i]],
                 ...)
        readline(prompt = "Press <Enter> to continue, <Esc> to quit...")
      }
    }
  }
}

# todo: gestion links plot.Ldk <- plot.Coo

# stack ----------------------------------------------------
#' Plots Coo objects: stack (all shapes in the same frame)
#'
#' Plots all the outlines, on the same graph, from a \link{Coo} (\link{Out}, \link{Opn} or \link{Ldk})
#' object.
# @method stack Coo
#' @param x The \code{Coo} object to plot.
#' @param cols A \code{vector} of colors for drawing the outlines.
#' Either a single value or of length exactly equals to the number of coordinates.
#' @param borders A \code{vector} of colors for drawing the borders.
#' Either a single value or of length exactly equals to the number of coordinates.
#' @param points logical whether to draw or not points
#' @param first.point logical whether to draw or not the first point
#' @param centroid logical whether to draw or not the centroid
#' @param ldk \code{logical}. Whether to display landmarks (if any).
#' @param ldk.pch A \code{pch} for these landmarks
#' @param ldk.col A color for these landmarks
#' @param ldk.cex A \code{cex} fro these landmarks
#' @param ldk_links logical whether to draw links (of the mean shape)
#' @param ldk_confell logical whether to draw conf ellipses
#' @param ldk_contour logical whether to draw contour lines
#' @param ldk_chull logical whether to draw convex hull
#' @param ldk_labels logical whether to draw landmark labels
#' @param xy.axis whether to draw or not the x and y axes
#' @param title a title for the plot. The name of the \code{Coo} by default
#' @param nb.pts the number of points to use for the shape reconstruction
#' @param ... further arguments to be passed to \link{coo_plot} 
#' @seealso \link{panel.Coo}, \link{plot.Coo}.
#' @note When applied on a \link{OutCoe} object, a wrapper 
#' for \code{stack(as.Out(OutCoe), ...)}. In that case, 
#' \code{...} feeds \code{stack} itself. (same thing for \code{OpnCoe} to come)
#' @keywords Graphics Out Opn Ldk
#' @examples
#' \dontrun{
#' data(bot)
#' stack(bot)
#' bot.f <- efourier(bot, 12)
#' stack(bot.f)
#' data(mosquito)
#' stack(mosquito, borders='#1A1A1A22', first.point=FALSE)
#' data(hearts)
#' stack(hearts)
#' stack(hearts, ldk=FALSE)
#' stack(hearts, borders='#1A1A1A22', ldk=TRUE, ldk.col=col_summer(4), ldk.pch=20)
#' }
#' @rdname stack.Coo
#' @aliases stack.Coo
#' @export
stack.Coo <- 
  function(x,
           cols, borders, points = FALSE,
           first.point = TRUE, centroid = TRUE,
           ldk = TRUE,
           ldk.pch = 3, ldk.col = "#FF000055",
           ldk.cex = 0.5, ldk_links = FALSE,
           ldk_confell = FALSE, ldk_contour = FALSE,
           ldk_chull = FALSE, ldk_labels = FALSE,
           xy.axis = TRUE, title=substitute(x), ...) {
    Coo <- x
    # we handle for missing cols
    if (missing(cols)) {
      cols <- rep(NA, length(Coo))
    }
    # or when provided fro an irregular lenght
    if (length(cols) != length(Coo)) {
      cols <- rep(cols[1], length(Coo))
    }
    # same thing for borders
    if (missing(borders)) {
      borders <- rep("#0000003F", length(Coo))
    }
    if (length(borders) != length(Coo)) {
      borders <- rep(borders[1], length(Coo))
    }
    # we define local par (margins)
    op <- par(mar = c(3, 3, 2, 1))
    on.exit(par(op))
    # we calculate data range
    wdw <- apply(do.call(rbind, Coo$coo), 2, range)
    plot(NA, type = "n",
         asp = 1, xlim = wdw[, 1], ylim = wdw[, 2],
         las = 1, cex.axis = 2/3, 
         ann = TRUE, frame = FALSE,  main=title)
    if (xy.axis) {
      abline(h = 0, v = 0, col = "grey80", lty = 2)
    }
    # should be lapply-ed but how to keep cols/borders ?
    for (i in 1:length(Coo)) {
      coo_draw(Coo$coo[[i]], col = cols[i], border = borders[i],
               points = points, first.point = TRUE, centroid = centroid)
      if (ldk & length(Coo$ldk) != 0) {
        points(Coo$coo[[i]][Coo$ldk[[i]], ], pch = ldk.pch,
               col = ldk.col, cex = ldk.cex)
      }
    }
  }

#' @rdname stack.Coo
#' @export
stack.OutCoe <- function(x, nb.pts=120, ...){
  OutCoe <- x
  Out <- as.Out(x, nb.pts=nb.pts)
  stack(Out, title=paste0(substitute(x),"_i"),...)}

#' @rdname stack.Coo
#' @export
stack.Ldk <- function(x, cols, borders, first.point = TRUE, centroid = TRUE,
                      ldk = TRUE, ldk.pch = 20, ldk.col = "#33333333", ldk.cex = 0.3,
                      ldk_links = FALSE, ldk_confell = FALSE, ldk_contour = FALSE,
                      ldk_chull = FALSE, ldk_labels = FALSE, xy.axis = TRUE, title=substitute(x), ...) {
  Coo <- x
  if (missing(cols)) {
    cols <- rep(NA, length(Coo))
  }
  if (length(cols) != length(Coo)) {
    cols <- rep(cols[1], length(Coo))
  }
  if (missing(borders)) {
    borders <- rep("#33333355", length(Coo))
  }
  if (length(borders) != length(Coo)) {
    borders <- rep(borders[1], length(Coo))
  }
  op <- par(mar = c(3, 3, 2, 1))
  on.exit(par(op))
  wdw <- apply(l2a(lapply(Coo$coo, function(x) apply(x, 2,
                                                     range))), 2, range)
  plot(NA, xlim = wdw[, 1], ylim = wdw[, 2], asp = 1, las = 1,
       cex.axis = 2/3, ann = FALSE, frame = FALSE)
  title(title)
  if (xy.axis) {
    abline(h = 0, v = 0, col = "grey80", lty = 2)
  }
  for (i in 1:length(Coo)) {
    points(Coo$coo[[i]], pch = ldk.pch, col = ldk.col, cex = ldk.cex)
  }
  # Specific to Ldk not very clean below #todo
  A <- l2a(Coo$coo)
  mA <- mshape(A)
  points(mA, pch = 20, cex = ifelse(ldk.cex > 0.5, ldk.cex *
                                      1.5, 1), col = "grey20")
  if (ldk_confell) {
    ldk_confell(A, conf = 0.9)
  }
  if (ldk_contour) {
    ldk_contour(A, nlevels = 3, col = "grey20")
  }
  if (ldk_chull) {
    ldk_chull(A)
  }
  if (ldk_links) {
    if (is.matrix(Coo$links))
      ldk_links(mshape(A), Coo$links)
  }
  if (ldk_labels) {
    ldk_labels(mshape(A))
  }
}

# panel ---------------------------------------------------
#' Plots Coo objects: panel (family picture)
#'
#' Plots all the outlines, side by side, from
#' a \link{Coo} (\link{Out}, \link{Opn} or \link{Ldk}) objects.
#'
#' @param x The \code{Coo} (or \code{OutCoe}) object  to plot.
#' @param cols A \code{vector} of colors for drawing the outlines.
#' Either a single value or of length exactly equal to the number of coordinates.
#' @param borders A \code{vector} of colors for drawing the borders.
#' Either a single value or of length exactly equals to the number of coordinates.
#' @param fac a factor within the $fac slot for colors
#' @param reorder a factor or a numeric to reorder shapes
#' @param palette a color \link{palette}
#' @param names whether to plot names or not. If TRUE uses shape names, otherwise
#' pass a character for the names of the files
#' @param cex.names a cex for the names
#' @param points logical (for Ldk) whether to draw points
#' @param points.pch (for Ldk) and a pch for these points
#' @param points.cex (for Ldk) and a cex for these points
#' @param points.col (for Ldk) and a col  for these points
#' @param nb.pts the number of points to use for the shape reconstruction
#' @param ... further arguments to maintain consistency with the generic \link{plot}.
#' @note When applied on a \link{OutCoe} object, a wrapper 
#' for \code{panel(as.Out(OutCoe), ...)}. In that case, 
#' \code{...} feeds \code{panel} itself. (same thing for \code{OpnCoe} to come)
#' @seealso \link{stack.Coo}, \link{plot.Coo}.
#' @keywords Graphics Out Opn Ldk
#' @examples
#' data(mosquito)
#' panel(mosquito, names=TRUE, cex.names=0.5)
#' data(olea)
#' panel(olea)
#' data(bot)
#' bot.f <- efourier(bot, 12)
#' panel(bot.f)
#' # an illustration of the use of fac
#' panel(bot, fac='type', palette=col_spring, names=TRUE)
#' @aliases panel.Coo
#' @rdname panel.Coo
#' @export
panel <- function(x, ...) {
  UseMethod("panel")
}
#' @rdname panel.Coo
#' @export
panel.Out <- function(x, cols, borders, fac, reorder = NULL,
                      palette = col_summer, names = NULL, cex.names = 0.6, points = TRUE,
                      points.pch = 3, points.cex = 0.2, points.col, ...) {
  Coo <- x
  if (!missing(fac)) {
    
    if (missing(cols)) {
      cols <- palette(nlevels(Coo$fac[, fac]))[Coo$fac[,
                                                       fac]]
    } else {
      cols <- cols[Coo$fac[, fac]]
    }
  }
  if (missing(cols)) {
    cols <- rep(NA, length(Coo))
  }
  if (length(cols) != length(Coo)) {
    cols <- rep(cols[1], length(Coo))
  }
  if (missing(borders)) {
    borders <- rep("#333333", length(Coo))
  }
  if (length(borders) != length(Coo)) {
    borders <- rep(borders[1], length(Coo))
  }
  if (!missing(reorder))
    reorder <- Coo$fac[, reorder]
  pos <- coo_listpanel(Coo$coo, cols = cols, borders = borders,
                       reorder = reorder, poly = TRUE)
  if (!is.null(names)) {
    if (is.logical(names)) {
      text(pos[, 1], pos[, 2], labels = names(Coo), cex = cex.names)
    } else {
      if (length(names) != length(Coo)) {
        if (is.null(reorder)) {
          text(pos[, 1], pos[, 2], labels = Coo$fac[,
                                                    names], cex = cex.names)
        } else {
          text(pos[, 1], pos[, 2], labels = Coo$fac[,
                                                    names][order(reorder)], cex = cex.names)
        }
      } else {
        text(pos[, 1], pos[, 2], labels = names, cex = cex.names)
      }
    }
  }
}

#' @rdname panel.Coo
#' @export
panel.OutCoe <- function(x, nb.pts=120, ...){
  OutCoe <- x
  Out <- as.Out(x, nb.pts=nb.pts)
  panel(Out, title=paste0(substitute(x),".i"),...)}


#' @rdname panel.Coo
#' @export
panel.Opn <- function(x, cols, borders, fac, reorder = NULL,
                      palette = col_summer, names = NULL, cex.names = 0.6, points = TRUE,
                      points.pch = 3, points.cex = 0.2, points.col, ...) {
  Coo <- x
  if (!missing(fac)) {
    
    if (missing(cols)) {
      cols <- palette(nlevels(Coo$fac[, fac]))[Coo$fac[,
                                                       fac]]
    } else {
      cols <- cols[Coo$fac[, fac]]
    }
  }
  if (missing(cols)) {
    cols <- rep(NA, length(Coo))
  }
  if (length(cols) != length(Coo)) {
    cols <- rep(cols[1], length(Coo))
  }
  if (missing(borders)) {
    borders <- rep("#333333", length(Coo))
  }
  if (length(borders) != length(Coo)) {
    cols <- rep(borders[1], length(Coo))
  }
  if (!missing(reorder))
    reorder <- Coo$fac[, reorder]
  pos <- coo_listpanel(Coo$coo, cols = cols, borders = borders,
                       reorder = reorder, poly = FALSE)
  if (!is.null(names)) {
    if (is.logical(names)) {
      text(pos[, 1], pos[, 2], labels = names(Coo), cex = cex.names)
    } else {
      if (length(names) != length(Coo)) {
        if (is.null(reorder)) {
          text(pos[, 1], pos[, 2], labels = Coo$fac[,
                                                    names], cex = cex.names)
        } else {
          text(pos[, 1], pos[, 2], labels = Coo$fac[,
                                                    names][order(reorder)], cex = cex.names)
        }
      } else {
        text(pos[, 1], pos[, 2], labels = names, cex = cex.names)
      }
    }
  }
}

#' @rdname panel.Coo
#' @export
panel.Ldk <- function(x, cols, borders, fac, reorder = NULL,
                      palette = col_summer, names = NULL, cex.names = 0.6, points = TRUE,
                      points.pch = 3, points.cex = 0.2, points.col = "#333333",
                      ...) {
  Coo <- x
  if (!missing(fac)) {
    if (missing(borders)) {
      borders <- palette(nlevels(Coo$fac[, fac]))[Coo$fac[,
                                                          fac]]
    } else {
      borders <- borders[Coo$fac[, fac]]
    }
  }
  if (missing(borders)) {
    borders <- rep("#333333", length(Coo))
  }
  if (length(borders) != length(Coo)) {
    borders <- rep(borders[1], length(Coo))
  }
  if (!missing(reorder))
    reorder <- Coo$fac[, reorder]
  pos <- coo_listpanel(Coo$coo, cols = cols, borders = borders,
                       reorder = reorder, poly = FALSE, points = points, points.pch = points.pch,
                       points.cex = points.cex, points.col = points.col)
  if (!is.null(names)) {
    if (is.logical(names)) {
      text(pos[, 1], pos[, 2], labels = names(Coo), cex = cex.names)
    } else {
      if (length(names) != length(Coo)) {
        if (is.null(reorder)) {
          text(pos[, 1], pos[, 2], labels = Coo$fac[,
                                                    names], cex = cex.names)
        } else {
          text(pos[, 1], pos[, 2], labels = Coo$fac[,
                                                    names][order(reorder)], cex = cex.names)
        }
      } else {
        text(pos[, 1], pos[, 2], labels = names, cex = cex.names)
      }
    }
  }
}

##### end graphics Coo