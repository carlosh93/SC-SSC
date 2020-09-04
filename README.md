# SC-SSC
MatLab Implementation Code for the Paper: A fast and accurate similarity-constrained subspace clustering algorithm for land cover segmentation


To improve the reproducibility of this work, we provide three scripts:

- 'run_HS.m': This script runs the proposed method on an individual dataset
and prints the Overall Accuracy, NMI, and running time. All the other results
are stored in the workspace struct variable 'rstl'. Besides, in the 
parameters variable, there are stored of the used parameters (rho,tau,E,K_s)
in the obtained result.

- 'run_HS_parameters': This script finds, for a given dataset, the 
parameters that provide the best results in terms of overall accuracy.

- 'visual_results': This script generates the visual results presented in 
the paper for all datasets. The presented results are stored in the 
subfolder 'Results/Precomputed_Results'. Note that you can select which
result to present by changing the line with the comment: %select the results 
to show.

