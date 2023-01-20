
<!-- README.md is generated from README.Rmd. Please edit that file -->

# peanutX

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of peanutX from
[GitHub](https://github.com/) with:

``` r
library(devtools)
devtools::install_github("yuan-yin-truly/peanutX@dev")
```

## Quick Start

Import CITE-seq dataset as a `SingleCellExperiment` or a `Seurat`
object, or a matrix object of ADTs x Droplets. You can use [PBMC
10K](https://www.10xgenomics.com/resources/datasets/10-k-pbm-cs-from-a-healthy-donor-gene-expression-and-cell-surface-protein-3-standard-3-0-0)
as an example dataset.

``` r
library(DropletUtils)

sce_filtered <- read10xCounts('filtered_feature_bc_matrix')
adt_filtered <- sce_filtered[rowData(sce_filtered)$Type == 'Antibody Capture',]
```

The model needs cluster labels for droplets reflecting their cell types.
We will implement a default clustering procedure when it is not supplied
by the user in the near future. But for now, you can use `Seurat` to
generate cluster labels.

``` r
library(Seurat)

adt_seurat <- CreateSeuratObject(counts(adt_filtered),
                                        assay = 'ADT')
adt_seurat <- NormalizeData(adt_seurat,
                                    normalization.method = "CLR",
                                    margin = 2)
adt_seurat <- ScaleData(adt_seurat,
                        assay = "ADT")
adt_seurat <- RunPCA(adt_seurat,
                     assay = "ADT",
                     features = rownames(adt_seurat),
                     reduction.name = "pca_adt",
                     reduction.key = "pcaadt_",
                     npcs = 10)
                     
adt_seurat <- FindNeighbors(adt_seurat,
                            dims = 1:10,
                            assay = "ADT",
                            reduction = "pca_adt",
                            verbose = FALSE)

adt_seurat <- FindClusters(adt_seurat,
                           resolution = 0.2)

                      
cell_type <- Idents(adt_seurat)
cell_type <- as.integer(cell_type$adtClusterID)
```

To decontaminate, peanutX has 4 input params: count matrix (ADT x
Droplets), cell cluster vector (1 x Droplets), and 2 prior parameters.
The output is a list of decontaminated count matrix and inferred model
parameters.

``` r
counts <- as.matrix(counts(adt_filtered))
out <- peanutXdecontaminate(counts,
                            cell_type, 
                            2e-5, 
                            2e-6)

decontaminated_counts <- out$decontaminated_counts
```

## Vignettes

Under development.
