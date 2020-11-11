# Figures scripts

## Requirements

We use matplotlib to draw plots. Use `pip3` to install matplotlib:

```bash
pip3 install -U matplotlib
```

## Draw plots

We use one unified `draw.py` to collect data from `run/output`(data must be prepared before) and print figures. It contains four subcommands: `sc` for single CPU, `sg` for single GPU, `ssc` for strong scaling for CPU and `ssg` for strong scaling for GPU.

Some example usage:

```shell
# Plot single CPU results to figures/output.
# Output files contains: bw_single_cpu.pdf, gflops_single_cpu.pdf
python3 draw.py sc


# Plot single GPU results to figures/output.
# Output files contains: bw_single_gpu.pdf, gflops_single_gpu.pdf
python3 draw.py sg


# Plot strong scaling for cpu results to figures/output.
# Output files contains: CDS1_strong_scaling_on_cpu.pdf, CDS2_strong_scaling_on_cpu.pdf
python3 draw.py ssc


# Plot strong scaling for gpu results to figures/output.
# Output files contains: CDS1_strong_scaling_on_gpu.pdf, CDS2_strong_scaling_on_gpu.pdf
python3 draw.py ssg

```

There is a optional parameter `-f/--format FORMAT` to specify the output file format. `FORMAT` can be `png`, `pdf`, `eps` and so on.

The remaining `parse.sh` script will be used by `draw.py` to parse the standard result from MemXCT. No need to directly use it.

## Fiji usage

We use Fiji to convert reconstructed tomogram binary to PNG files.

Take CDS2 as example:

1. Select File->Import->Raw...
2. Choose generated binary
3. Select `32-bit Real` to Image type
4. Width and Height of CDS2 are both 1024 pixels respectively
5. Enable `Little-endian byte order`
6. Click OK, a visualization is presented
7. Then, Select File->Save As->PNG...
8. Put the PNG under artifact directory
