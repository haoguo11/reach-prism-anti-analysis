# reach-prism-anti-analysis

## Compatibility
Tested under Matlab 2020b version.

## Running program
To generate figures using the provided example data, simply execute <code>main.m</code>

### Workflow for experimental data analysis
The typical workflow to generate figures is the following:

- First, create both random and shuffled data, then store them in their respective directories. It's important to mention that the demo operates with a repetition count of 100. Should you opt to raise this count, for instance to 10,000 as mentioned in the manuscript, be aware that it will considerably extend the computational time on a typical CPU setup, possibly extending into hours.

- Next, run all Figure scripts <code>Fig2_PCA_projVar_Bars.m</code>, <code>Fig2_projEucD.m</code>, <code>Fig3_PCA_crossProjVar.m</code>, <code>Fig3_alignIdx.m</code>, <code>Fig4_vPCA.m</code>, <code>Fig_correlationMatrix.m</code>, and <code>Fig_PCs.m</code> to generate and save the related figures using the sample data.

### Workflow for RNN modeling data analysis

- To perform the identical analyses on RNN simulation data as conducted on experimental data, begin by executing <code>preprocess_trainedRNN.m</code> to preprocess the activity from the PRR-module.

- Next, run Figure script <code>Fig5_RNN.m</code>
# reach-prism-anti-analysis
