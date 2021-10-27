## Introduction
This repository contains te MatLab implementation code for our IEEE JSTAR Paper: **A Fast and Accurate Similarity-constrained Subspace Clustering Algorithm for Hyperspectral Image** DOI: [10.1109/JSTARS.2021.3120071](https://doi.org/10.1109/JSTARS.2021.3120071)


To reproduce the results of this work, we provide three scripts:

- 'run_HS.m': This script runs the proposed method on an individual dataset and prints the Overall Accuracy, NMI, and running time. All the other results
are stored in the workspace struct variable 'rstl'. Besides, in the parameters variable, there are stored of the used parameters (rho,tau,E,K_s)
in the obtained result.
- 'run_HS_parameters': This script finds, for a given dataset, the 
parameters that provide the best results in terms of overall accuracy.

- 'visual_results': This script generates the visual results presented in the paper for all datasets. The presented results are stored in the subfolder 'Results/Precomputed_Results'. Note that you can select which result to present by changing the line with the comment: %select the results to show.


## Dataset

The proposed subspace clustering approach (SC-SSC) was tested on three well-known and challenging hyperspectral images: Indian Pines, Salinas, and The University of Pavia. These datasets are freely available at:

http://www.ehu.eus/ccwintco/index.php/Hyperspectral_Remote_Sensing_Scenes

We downloaded all of these datasets and placed the .mat files in the subfolder "Full Dataset" for convenience. In addition, we crop the images to select the regions of interest (ROI) presented in the paper and save the resulting files in the subfolder ROI. Please refer to the webpage of each dataset to cite the corresponding work. **We are not the owner of these datasets.**

## Toolbox
We used the superpixels algorithm provided by the [VLFeat](https://www.vlfeat.org/) library. We downloaded version 0.9.21 and placed it in the Toolbox folder of this repository. However, **We are not the owner of this library**. Please give all the credits to their authors. Visit their webpage to check how to cite their work.

## Troubleshooting
If the run_HS.m script fails, please manually download the VLFeat library, place it in the Toolbox folder and compile it to get the corresponding mex file for your operating system.

## How to cite this work
```
@ARTICLE{9573388,  
  author={Hinojosa, Carlos and Vera, Esteban and Arguello, Henry},  
  journal={IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing},   
  title={A Fast and Accurate Similarity-constrained Subspace Clustering Algorithm for Hyperspectral Image},   
  year={2021},  
  volume={},  
  number={},  
  pages={1-1},  
  doi={10.1109/JSTARS.2021.3120071}
  }
```
