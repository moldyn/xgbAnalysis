% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/feature.selection.plotter.R
\name{plt.feature.selection}
\alias{plt.feature.selection}
\title{Accuracy loss plot based on feature selection}
\usage{
plt.feature.selection(dir = "featureSelection", pdim = 10, width = 1.5,
  saveplot = T, pre = "", xlim = NA, ylim = NA)
}
\arguments{
\item{dir}{path of 'feature.selection' file (see \link{\code{feature.selection}})}

\item{pdim}{dimension of plot, default=10}

\item{width}{proportion of width to height, default=1.5}

\item{saveplot}{save plot?(T/F) default = T}

\item{pre}{plot prefix}

\item{xlim}{zoom on x-axis, e.g. xlim = 280:300}

\item{ylim}{zoom an y-axis, e.g. ylim = c(0,0.25). Use c() with other than natural numbers}
}
\description{
Plot the accuracy as a function of the number of dismissed features.
}
