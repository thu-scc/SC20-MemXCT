import os
import argparse
import subprocess
import pickle
import time

import numpy as np


RESULT_DIR="./result"


def cpu_run(script, thread, tile_size, block_power_max=12, buffer_size_max=48, dataset="ADS2"):
  data = {}
  data['block_size'] = []
  data['buffer_size'] = []
  data['gflops'] = np.zeros(shape=(block_power_max + 1, buffer_size_max))
  data['bw'] = np.zeros(shape=(block_power_max + 1, buffer_size_max))
  data['prep_time'] = np.zeros(shape=(block_power_max + 1, buffer_size_max))
  data['time'] = np.zeros(shape=(block_power_max + 1, buffer_size_max))
  
  start = time.time()
  for i, block_power in enumerate(range(0, block_power_max + 1)):
    block_size = 2 ** block_power
    data['block_size'].append(block_size)
    for j, buffer_size in enumerate(range(1, buffer_size_max + 1)):
      data['buffer_size'].append(buffer_size)
      cmd = "./{} 1 {} {} {} {} {}".format(script, thread, dataset, tile_size, block_size, buffer_size)
      print("CPU for tile_size: {}, block_size: {}, buffer_size: {}, dataset: {}".format(tile_size, block_size, buffer_size, dataset))
      print("\tcmd: {}".format(cmd))
      process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
      stdout, _ = process.communicate()
      process.wait()
  
  end = time.time()
  print("Done Time: {} sec", end - start)

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--script", "-script", required=True, type=str, dest="script", help="script")
  parser.add_argument("--thread", "-thread", required=True, type=int, dest="thread", help="thread")
  parser.add_argument("--tile_size", "-tile", required=True, type=int, dest="tile_size", help="tile_size")
  #parser.add_argument("--block_size", "-block", dest="block_size", help='block size')
  #parser.add_argument("--buffer_size", "-buf", dest="buffer_size", help='buffer size')

  args = parser.parse_args()
  cpu_run(args.script, args.thread, args.tile_size)

  
