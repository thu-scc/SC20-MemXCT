import collections
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import subprocess
import numpy as np
import os
import argparse

plt.rcParams.update({'font.size': 18})

GLOBAL_INPUT_DIR="../../run/output/"
GLOBAL_OUTPUT_DIR="../output/"


Result = collections.namedtuple('Result', [
  'av_gflops',
  'tot_gflops',
  'av_bw',
  'tot_bw',
  'tot_time',
  'proj_ktime', # kernel time
  'proj_ctime', # communication time
  'proj_rtime', # reduction time
  'backproj_ktime',
  'backproj_ctime',
  'backproj_rtime'
])

Result.__new__.__defaults__ = (None, ) * len(Result._fields)

def exec_cmd(cmd):
  process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
  stdout, _ = process.communicate()
  process.wait()

  return stdout.decode().strip()


def parse_output(output_file):
  res = exec_cmd("./parse.sh {}".format(output_file))
  res = res.strip().split(',')
  res = [float(n.strip()) for n in res]
  assert len(res) == 11, "len is {}".format(len(res))
  

  return Result(av_gflops=res[0],
                tot_gflops=res[1],
                av_bw=res[2],
                tot_bw=res[3],
                tot_time=res[4],
                proj_ktime=res[5],
                proj_ctime=res[6],
                proj_rtime=res[7],
                backproj_ktime=res[8],
                backproj_ctime=res[9],
                backproj_rtime=res[10])
  
def get_best_result_for_single(dir_addr, datasets, name, get_ds, key, reverse=False):
  data = {}
  for ds in datasets:
    data[ds] = []
  files = [name for name in os.listdir(dir_addr) if os.path.isfile(os.path.join(dir_addr, name))]
  files = [name for name in os.listdir(dir_addr) if os.path.isfile(os.path.join(dir_addr, name)) and name.endswith("out")]
  for f in files:
    try:
      res = parse_output(os.path.join(dir_addr, f))
    except:
      print("Got error parsing {}, skipping".format(f))
      continue
    para = f.split('.')    
    para.pop()
    ds = get_ds(para)
    if ds not in datasets:
      print("Warn: Unknown dataset: {}".format(ds))
      continue
    data[ds].append((f, res))
  for ds in datasets:
    data[ds].sort(key=lambda x: key(x[1]), reverse=reverse)
    if len(data[ds]) == 0:
      raise Exception("No result for {} dataset".format(ds))
    else:
      print("Best {} {} for {} dataset comes from {}".format(name, key(data[ds][0][1]), ds, data[ds][0][0]))
  num_list = []
  for ds in datasets:
    num_list.append(key(data[ds][0][1]))
  return num_list    

def single_cpu(args):
  intel_dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_cpu", "single_intel")
  amd_dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_cpu", "single_amd")
  datasets = ["CDS1", "CDS2"]

  intel_gflops_list = get_best_result_for_single(intel_dir_addr, datasets, "avGFLOPS(intel)", get_ds=lambda x: x[1], key=lambda x: x.av_gflops, reverse=True)
  intel_bw_list = get_best_result_for_single(intel_dir_addr, datasets, "avBW(intel)", get_ds=lambda x: x[1], key=lambda x: x.av_bw, reverse=True)
  amd_gflops_list = get_best_result_for_single(amd_dir_addr, datasets, "avGFLOPS(amd)", get_ds=lambda x: x[1], key=lambda x: x.av_gflops, reverse=True)
  amd_bw_list = get_best_result_for_single(amd_dir_addr, datasets, "avBW(amd)", get_ds=lambda x: x[1], key=lambda x: x.av_bw, reverse=True)

  # gflops
  plt.clf()
  width = 0.35
  x = np.arange(2)
  fig, ax = plt.subplots(figsize=(6, 6))
  ax.bar(x - width/2, intel_gflops_list, width, color='grey', label='Intel')
  ax.bar(x + width/2, amd_gflops_list, width, color='orange', label='AMD')
  ax.set_title('GFLOPS for single CPU')
  ax.set_xticks(x)
  ax.set_xticklabels(datasets)
  ax.grid(True, axis='y')
  ax.spines['left'].set_visible(False)
  ax.spines['top'].set_visible(False)
  ax.spines['right'].set_visible(False)
  ax.legend(loc='center')
  fig.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "gflops_single_cpu." + args.format), format=args.format)

  # bw
  # TODO: add STREAM result into the figure!
  plt.clf()
  width = 0.35
  x = np.arange(2)
  fig, ax = plt.subplots(figsize=(6, 6))
  ax.bar(x - width/2, intel_bw_list, width, color='grey', label='Intel')
  ax.bar(x + width/2, amd_bw_list, width, color='orange', label='AMD')
  #ax.axhline(82, x[0] - width/2, x[0] + width/2, linewidth=4, marker='o', label='Intel EBW(82 GB/s)')
  ax.set_title('Memory B/W Utilization (GB/s)')
  ax.set_xticks(x)
  ax.set_xticklabels(datasets)
  ax.grid(True, axis='y')
  ax.spines['left'].set_visible(False)
  ax.spines['top'].set_visible(False)
  ax.spines['right'].set_visible(False)
  ax.legend(loc='center')
  fig.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "bw_single_cpu." + args.format), format=args.format)


def single_gpu(args):
  k80_dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_gpu", "single_k80")
  p100_dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_gpu", "single_p100")
  v100_dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_gpu", "single_v100")

  datasets = ["CDS1", "CDS2"]
  gpu_types = ["k80", "p100", "v100"]

  k80_gflops_list = get_best_result_for_single(k80_dir_addr, datasets, "avGFLOPS(k80)", get_ds=lambda x: x[2], key=lambda x: x.av_gflops, reverse=True)
  k80_bw_list = get_best_result_for_single(k80_dir_addr, datasets, "avBW(k80)", get_ds=lambda x: x[2], key=lambda x: x.av_bw, reverse=True)
  p100_gflops_list = get_best_result_for_single(p100_dir_addr, datasets, "avGFLOPS(p100)", get_ds=lambda x: x[2], key=lambda x: x.av_gflops, reverse=True)
  p100_bw_list = get_best_result_for_single(p100_dir_addr, datasets, "avBW(p100)", get_ds=lambda x: x[2], key=lambda x: x.av_bw, reverse=True)
  v100_gflops_list = get_best_result_for_single(v100_dir_addr, datasets, "avGFLOPS(v100)", get_ds=lambda x: x[2], key=lambda x: x.av_gflops, reverse=True)
  v100_bw_list = get_best_result_for_single(v100_dir_addr, datasets, "avBW(v100)", get_ds=lambda x: x[2], key=lambda x: x.av_bw, reverse=True)


  x = np.array([0, 1.5]) # the label locations
  width = 0.35  # the width of the bars

  # gflops
  plt.clf()
  fig, ax = plt.subplots(figsize=(6, 6))
  ax.bar(x - width, k80_gflops_list, width, color='grey', label='K80')
  ax.bar(x, p100_gflops_list, width, color='orange', label='P100')
  ax.bar(x + width, v100_gflops_list, width, color='darkturquoise', label='V100')
  ax.set_title('GFLOPS for single GPU')
  ax.set_xticks(x)
  ax.set_xticklabels(datasets)
  ax.grid(True, axis='y')
  ax.spines['left'].set_visible(False)
  ax.spines['top'].set_visible(False)
  ax.spines['right'].set_visible(False)
  ax.legend(loc='center')
  fig.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "gflops_single_gpu." + args.format), format=args.format)


  # bw
  plt.clf()
  fig, ax = plt.subplots(figsize=(6, 6))
  ax.bar(x - width, k80_bw_list, width, color='grey', label='K80')
  ax.bar(x, p100_bw_list, width, color='orange', label='P100')
  ax.bar(x + width, v100_bw_list, width, color='darkturquoise', label='V100')
  ax.set_title('Memory B/W Utilization (GB/s)')
  ax.set_xticks(x)
  ax.set_xticklabels(datasets)
  ax.grid(True, axis='y')
  ax.spines['left'].set_visible(False)
  ax.spines['top'].set_visible(False)
  ax.spines['right'].set_visible(False)
  ax.legend(loc='center')
  fig.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "bw_single_gpu." + args.format), format=args.format)


def get_result_for_strong_scaling(dir_addr, scaling_num, dataset, get_node, key):
  files = [name for name in os.listdir(dir_addr) if os.path.isfile(os.path.join(dir_addr, name))]
  files = [name for name in files if name.endswith("out") and dataset in name ]

  num_list = []
  data = {}
  for n in scaling_num:
    data[n] = []

  for f in files:
    try:
      res = parse_output(os.path.join(dir_addr, f))
    except:
      print("Got error parsing {}, skipping".format(f))
      continue
    para = f.split('.')
    para.pop()
    node_num = int(get_node(para))
    if node_num not in scaling_num:
      raise Exception("Unknown node num: {}".format(node_num))
    data[node_num].append(key(res))
  
  for n in scaling_num:
    assert len(data[n]) == 1
    num_list.append(data[n][0])
  return num_list

def strong_scaling_for_cpu(args):
  dir_addr = os.path.join(GLOBAL_INPUT_DIR, "strong_scaling_on_cpu", "multi_intel")
  datasets = ["CDS1", "CDS2"]
  scaling_num = [1, 2, 4]
  
  for ds in datasets:
    num_list = get_result_for_strong_scaling(dir_addr, scaling_num, ds,
      get_node=lambda x: x[0],
      key=lambda x:
        (x.tot_time,
          x.proj_ktime + x.backproj_ktime,
          x.proj_ctime + x.backproj_ctime,
          x.proj_rtime + x.backproj_rtime))

    tot_time_list = [x[0] for x in num_list ]
    ktime_list = [x[1] for x in num_list ]
    ctime_list = [x[2] for x in num_list ]
    rtime_list = [x[3] for x in num_list ]

    fig, ax = plt.subplots(figsize=(8, 6))
    ideal_list = [ktime_list[0]]
    for _ in range(len(scaling_num) - 1):
      ideal_list.append(ideal_list[-1] / 2)
    ax.plot(scaling_num, tot_time_list, marker='o', markersize=12, color='deepskyblue', label='Total')
    ax.plot(scaling_num, ktime_list, marker='o', markersize=12, color='orangered', label='Kernel')
    ax.plot(scaling_num, ctime_list, marker='o', markersize=12, color='orange', label='Comm')
    ax.plot(scaling_num, rtime_list, marker='o', markersize=12, color='purple', label='Reduction')
    ax.plot(scaling_num, ideal_list, linewidth=2, color='black', label='Ideal')

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Number of Nodes")
    ax.set_ylabel("Solution Time(s)")
    ax.set_title("{} Strong Scaling on CPU".format(ds))
    ax.xaxis.set_minor_formatter(FuncFormatter(lambda x, pos: '%d' % x))
    ax.xaxis.set_major_formatter(FuncFormatter(lambda x, pos: '%d' % x))
    ax.grid(True, which='both')
    ax.legend()
    fig.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "{}_strong_scaling_on_cpu.".format(ds) + args.format), format=args.format)

def strong_scaling_for_gpu(args):
  dir_addr = os.path.join(GLOBAL_INPUT_DIR, "strong_scaling_on_gpu", "multi_p100")
  datasets = ["CDS1", "CDS2"]
  scaling_num = [1, 2, 4]
  
  for ds in datasets:
    num_list = get_result_for_strong_scaling(dir_addr, scaling_num, ds,
      get_node=lambda x: int(x[1]) // 4,
      key=lambda x:
        (x.tot_time,
          x.proj_ktime + x.backproj_ktime,
          x.proj_ctime + x.backproj_ctime,
          x.proj_rtime + x.backproj_rtime))

    tot_time_list = [x[0] for x in num_list ]
    ktime_list = [x[1] for x in num_list ]
    ctime_list = [x[2] for x in num_list ]
    rtime_list = [x[3] for x in num_list ]

    fig, ax = plt.subplots(figsize=(8, 6))
    ideal_list = [ktime_list[0]]
    for _ in range(len(scaling_num) - 1):
      ideal_list.append(ideal_list[-1] / 2)

    ax.plot(scaling_num, tot_time_list, marker='o', markersize=12, color='deepskyblue', label='Total')
    ax.plot(scaling_num, ktime_list, marker='o', markersize=12, color='orangered', label='Kernel')
    ax.plot(scaling_num, ctime_list, marker='o', markersize=12, color='orange', label='Comm')
    ax.plot(scaling_num, rtime_list, marker='o', markersize=12, color='purple', label='Reduction')

    ax.plot(scaling_num, ideal_list, linewidth=2, color='black', label='Ideal')

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Number of Nodes")
    ax.set_ylabel("Solution Time(s)")
    ax.set_title("{} Strong Scaling on P100".format(ds))
    ax.xaxis.set_minor_formatter(FuncFormatter(lambda x, pos: '%d' % x))
    ax.xaxis.set_major_formatter(FuncFormatter(lambda x, pos: '%d' % x))
    ax.grid(True, which='both')
    ax.legend()
    fig.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "{}_strong_scaling_on_gpu.".format(ds) + args.format), format=args.format)

def draw_info(args):
    print('please run "python draw.py {positional argument} --help" to see guidance')

if __name__ == "__main__":
  parser = argparse.ArgumentParser(prog="draw_single_device", description="empty")
  parser.set_defaults(func=draw_info)
  subparsers = parser.add_subparsers()

  # single cpu
  parser_sc = subparsers.add_parser("sc", help="single cpu")
  parser_sc.add_argument("--format", "-f", type=str, default="pdf")
  parser_sc.set_defaults(func=single_cpu)


  # single gpu
  parser_sg = subparsers.add_parser("sg", help="single gpu")
  parser_sg.add_argument("--format", "-f", type=str, default="pdf")
  parser_sg.set_defaults(func=single_gpu)


  # strong scaling for cpu
  parser_ssc = subparsers.add_parser("ssc", help="strong scaling for cpu")
  parser_ssc.add_argument("--format", "-f", type=str, default="pdf")
  parser_ssc.set_defaults(func=strong_scaling_for_cpu)


  # strong scaling for gpu
  parser_ssg = subparsers.add_parser("ssg", help="strong scaling for gpu ")
  parser_ssg.add_argument("--format", "-f", type=str, default="pdf")
  parser_ssg.set_defaults(func=strong_scaling_for_gpu)


  args = parser.parse_args()
  args.func(args)
