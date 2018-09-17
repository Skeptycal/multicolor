#' Multi-color crawling text
#'
#' @description This function works on single lines of text only.
#' It produces a gif-like representation of the text unfolding from left to right.
#'
#' @export
#'
#' @param txt (character) Some text to color, stripped of line breaks
#' @param colors (character) A vector of colors, defaulting to
#' the Viridis Plasma palette.
#'
#' Must all be \href{https://github.com/r-lib/crayon#256-colors}{\code{crayon}}-supported
#' colors. Any colors in \code{colors()} or hex values (see \code{?rgb})
#' are fair game.
#' @param viridis_dir (numeric: -1 or 1) For Viridis colors, direction of colors to be applied.
#' Defaults to -1, i.e. brighter to darker.
#' @param pause (numeric) Seconds to pause between characters in seconds. Defaults to 0.
#' @param ... Further args.
#'
#' @details This function requires as many colors as there are characters in your string and
#' prints them one at a time. Provided colors will be recycled if needed.
#'
#' It cannot be used with RGUI (R.app on some systems) or other environments that do not support
#' colored text. See \code{multicolor:::use_color} for more info.
#'
#' @return A string, printed in \code{colors} with \code{pause} seconds between printing each character.
#'
#' @examples \dontrun{
#' crawl()
#'
#' crawl("It was a dark and stormy night")
#'
#' crawl("Taste the rainbow", colors = "rainbow")
#'
#' options("keep.source = FALSE")
#' cat("\014")
#' crawl('A long time ago in a galaxy far, far away...')
#' cat('\n')
#' cat('\n')
#' crawl("It is a period of civil war. Rebel spaceships, striking from a hidden base,")
#' cat('\n')
#' crawl('have won their first victory against the evil Galactic Empire.', viridis_dir = 1)
#' }

crawl <- function(txt = "hello world!", colors = NULL, viridis_dir = -1, pause = 0, ...) {
  if (use_color() == FALSE) stop("Colors cannot be applied in this environment. Please use another application, such as RStudio or a color-enabled terminal.")

  if (!is.character(txt) || length(txt) != 1) {
    stop("txt must be a character vector of length 1.")
  }

  if (!is.numeric(pause) || pause < 0) stop("pause must be a number > 0.")

  if (is.null(colors)) colors <- viridisLite::plasma(stringr::str_length(txt) + 1, direction = viridis_dir, begin = 0.3)

  colors <- insert_rainbow(colors)

  colors <- rep(colors, length.out = stringr::str_length(txt) + 1)

  for (i in seq(nchar(txt))) {
    multi_color(stringr::str_sub(txt, i, i),
      colors = colors[ (1 + ((i - 1) %% (length(colors)))):(2 + ((i - 1) %% (length(colors))))],
      type = "crawl", ...
    )
    Sys.sleep(pause)
  }
}