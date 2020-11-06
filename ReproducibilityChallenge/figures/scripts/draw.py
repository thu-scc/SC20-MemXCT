import collections
import matplotlib.pyplot as plt
import subprocess
import numpy as np
import os
import argparse


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
  

def single_cpu(args):
  input_dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_cpu", args.hostname)
  datasets = ["ADS1", "ADS2", "ADS3", "ADS4"]

  data = {}
  for ds in datasets:
    data[ds] = []

  files = [name for name in os.listdir(input_dir_addr) if os.path.isfile(os.path.join(input_dir_addr, name))]
  files = [name for name in files if name.endswith("out")]

  for f in files:
    res = parse_output(os.path.join(input_dir_addr, f))
    para = f.split('.')    
    para.pop()
    ds = para[1]
    if ds not in datasets:
      raise Exception("Unknown dataset: {}".format(ds))
    data[ds].append((f, res))

  # sort by gflops
  for ds in datasets:
    data[ds].sort(key=lambda x: x[1].av_gflops, reverse=True)
    if len(data[ds]) == 0:
      print("No result for {} dataset".format(ds))
    else:
      print("Best avGFLOPS {} for {} dataset comes from {}".format(data[ds][0][1].av_gflops, ds, data[ds][0][0]))
  

  label_list = []
  num_list = []
  plt.clf()
  # draw gflops for single cpu
  for ds in datasets:
    if len(data[ds]) > 0:
      label_list.append(ds)
      num_list.append(data[ds][0][1].av_gflops)
  plt.bar(label_list, num_list, color='grey', label='MemXCT')
  plt.ylabel("GFLOPS")
  plt.title("GFLOPS for single CPU")
  plt.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "gflops_single_cpu.png"))
  

  # sort by bw
  for ds in datasets:
    data[ds].sort(key=lambda x: x[1].av_bw, reverse=True)
    if len(data[ds]) == 0:
      print("No result for {} dataset".format(ds))
    else:
      print("Best bw {} comes from {}".format(data[ds][0][1].av_bw, data[ds][0][0]))

  label_list = []
  num_list = []
  plt.clf()
  # draw bw for single cpu
  for ds in datasets:
    if len(data[ds]) > 0:
      label_list.append(ds)
      num_list.append(data[ds][0][1].av_bw)
  plt.bar(label_list, num_list, color='grey')
  plt.title("Memory B/W Utilization (GB/s) for single cpu")
  plt.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "bw_single_cpu.png"))
  

def single_gpu(args):
  dir_addr = os.path.join(GLOBAL_INPUT_DIR, "single_gpu")
  datasets = ["ADS1", "ADS2"]
  gpu_types = ["k80", "p100", "v100"]
  data = {}
  for gt in gpu_types:
    data[gt] = {}
    for ds in datasets:
      data[gt][ds] = []

  files = []
  for path, _, file_list in os.walk(dir_addr):
    # find all output for single gpu
    for fn in file_list:
      if fn.endswith("out"):
        files.append(os.path.join(path, fn))
  
  for f in files:
    res = parse_output(f)
    para = os.path.basename(f).split('.')
    para.pop()
    gpu_type = para[0]
    if gpu_type not in gpu_types:
      raise Exception("Unknown gpu type: {}".format(gpu_type))
    ds = para[2] 
    if ds not in datasets:
      raise Exception("Unknown dataset: {}".format(ds))
    data[gpu_type][ds].append((f, res))
  
  # sort by gflops
  for gpu_type in gpu_types:
    for ds in datasets:
      data[gpu_type][ds].sort(key=lambda x: x[1].av_gflops, reverse=True)
      if len(data[gpu_type][ds]) == 0:
        print("No result for {} dataset on {}".format(ds, gpu_type))
      else:
        print("Best avGFLOPS {} for {} dataset comes from {} ".format(data[gpu_type][ds][0][1].av_gflops, ds, data[gpu_type][ds][0][0]))
  

  # draw gflops for single gpu
  plt.clf()
  fig = plt.figure(figsize=(9, 5))
  for i, gpu_type in enumerate(gpu_types):
    #ax = plt.subplot(131 + i)
    ax = fig.add_subplot(131 + i)
    label_list = []
    num_list = []
    for ds in datasets:
      if len(data[gpu_type][ds]) > 0:
        label_list.append(ds)
        num_list.append(data[gpu_type][ds][0][1].av_gflops)
    #plt.bar(label_list, num_list, color='grey')
    ax.bar(label_list, num_list, color='grey')
    ax.set_title(gpu_type)
  fig.text(0.05, 0.5, 'GFLOPS', va='center', rotation='vertical')
  #plt.ylabel("GFLOPS")
  fig.suptitle("GFLOPS for single GPU")
  plt.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "gflops_single_gpu.png"))
  

  # sort by bw
  for gpu_type in gpu_types:
    for ds in datasets:
      data[gpu_type][ds].sort(key=lambda x: x[1].av_bw, reverse=True)
      if len(data[gpu_type][ds]) == 0:
        print("No result for {} dataset on {}".format(ds, gpu_type))
      else:
        print("Best avGFLOPS {} for {} dataset comes from {} ".format(data[gpu_type][ds][0][1].av_bw, ds, data[gpu_type][ds][0][0]))
  

  # draw bw for single gpu
  plt.clf()
  for i, gpu_type in enumerate(gpu_types):
    ax = plt.subplot(131 + i)
    label_list = []
    num_list = []
    for ds in datasets:
      if len(data[gpu_type][ds]) > 0:
        label_list.append(ds)
        num_list.append(data[gpu_type][ds][0][1].av_gflops)
    plt.bar(label_list, num_list, color='grey')
    ax.set_title(gpu_type)
  plt.suptitle("Memory B/W Utilization (GB/s) for single GPU")
  plt.legend()
  plt.savefig(os.path.join(GLOBAL_OUTPUT_DIR, "bw_single_gpu.png"))



def strong_scaling_for_cpu(args):
  pass

def strong_scaling_for_gpu(args):
  pass

def draw_info(args):
    print('please run "python draw.py {positional argument} --help" to see guidance')

if __name__ == "__main__":
  parser = argparse.ArgumentParser(prog="draw_single_device", description="empty")
  parser.set_defaults(func=draw_info)
  subparsers = parser.add_subparsers()

  # single cpu
  parser_sc = subparsers.add_parser("sc", help="single cpu")
  parser_sc.add_argument("--hostname", "-host", type=str, required=True)
  parser_sc.set_defaults(func=single_cpu)


  # single gpu
  parser_sg = subparsers.add_parser("sg", help="single gpu")
  parser_sg.set_defaults(func=single_gpu)


  # strong scaling for cpu
  parser_ssc = subparsers.add_parser("ssc", help="strong scaling for cpu")
  parser_ssc.add_argument("--hostname", "-host", type=str, required=True)
  parser_ssc.set_defaults(func=strong_scaling_for_cpu)


  # strong scaling for gpu
  parser_ssg = subparsers.add_parser("ssg", help="strong scaling for gpu ")
  parser_ssg.add_argument("--hostname", "-host", type=str, required=True)
  parser_ssg.set_defaults(func=strong_scaling_for_gpu)


  args = parser.parse_args()
  args.func(args)