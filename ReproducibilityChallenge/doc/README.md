# Artifact of Reproducibility Challenge

## Contents of artifact

### Compile

It contains compilation scripts, vectorization report for CPU code, README and environment info. See `compile/README.md` for detail.

### Run

It contains "run" scripts for single CPU and GPU, strong scaling on CPU and GPU. See `run/scripts/README.md` for detail.

### Figures

It contians scripts to draw out version of Figure 9 and Figure 11, the visualization of the output of MemXCT done with Fiji and some comments. See `figures/output/README.md` and `figures/scripts/README.md` for detail.

#### Figures/Table data used in report

Table 4: The STREAM results come from `run/output/single_cpu/single_amd/stream_result.txt` and `run/output/single_cpu/single_intel/stream_result.txt`

Figure 1: It uses `figures/output/{bw, gflops}_single_cpu.pdf`
Figure 2: It uses `figures/output/{bw, gflops}_single_gpu.pdf`
Figure 3: It uses `figures/output/{CDS1, CDS2}_strong_scaling_on_{cpu, gpu}.pdf`
Figure 4: It is from `figures/output/{24.60.CDS3.64.64.1024.1024.32.32.png, v100.12.CDS1.128.128.512.512.48.48.png, p100.16.24.CDS2.128.128.512.512.48.48.png}`. These images are generated by Fiji from corresponding reconstructed tomogram binary.

### Attention

Because CDS2 dataset has problems and the authors release the correct dataset near the end of the competition, we only redo the strong scaling experiment for GPU to generate correct CDS2 tomogram, the output of which is visualized by Fiji and inserted in the final report. Other output binary for CDS2 are all generated by the old CDS2, so they have the correct performance but wrong reconstructed tomogram.
