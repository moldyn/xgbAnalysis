# xgbAnalysis

## About
The xgbAnalysis package is a tool to find suitable reaction coordinates of biomolecular
systems, e.g. proteins, using the [XGBoost](https://arxiv.org/pdf/1603.02754.pdf) algorithm
that can be found [here](https://github.com/dmlc/xgboost). Given a trajectory from a molecular dynamics simulation and
suitable corresponding states, it evaluates, which of the input coordinates describe the
system best, resulting in a low dimensional reaction coordinate of directly interpretable
original coordinates. To obtain states for a given trajectorie the [prodyna](https://github.com/lettis/prodyna/blob/master/vignettes/prodynaTutorial.Rmd)
package can be used. A tutorial can be found in [docs](docs) or [online](https://moldyn.github.io/xgbAnalysis).


## Licensing

The code is published "AS IS" under the simplified BSD2 license. For details, please see [LICENSE](LICENSE).

If you use the code for published works, please cite as

Please cite:
- S.Brandt, F. Sittel, M. Ernst, and G. Stock, *Machine Learning of Biomolecular Reaction Coordinates*, J. Phys. Chem. Lett. 9, 2144, 2018: DOI: [10.1021/acs.jpclett.8b00759](https://pubs.acs.org/doi/full/10.1021/acs.jpclett.8b00759)

## Installation
Install the xgbAnalysis package, using the R-devtools package
```
if ( ! ("devtools" %in% installed.packages())) {
  install.packages("devtools")
}
devtools::install_github("moldyn/xgbAnalysis")
library(xgbAnalysis)
```
