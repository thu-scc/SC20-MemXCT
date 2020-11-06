import os
import argparse
import subprocess
import pickle
import time

import numpy as np


RESULT_DIR="./result"

# too old, not maintain


def gpu_run(tile_size, block_power_max=12, buffer_size_max=48, dataset="ADS2"):
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
      cmd = "./run.gpu.sh {} {} {} {} {} {} {}".format(dataset, tile_size, tile_size, block_size, block_size, buffer_size, buffer_size)
      print("GPU for tile_size: {}, block_size: {}, buffer_size: {}, dataset: {}".format(tile_size, block_size, buffer_size, dataset))
      print("\tcmd: {}".format(cmd))
      process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
      stdout, _ = process.communicate()
      process.wait()
  
      li = stdout.decode().strip().split(',')
      assert len(li) == 4
      gflops, bw, prep_time, tot_time = float(li[0]), float(li[1]), float(li[2]), float(li[3])
      data['gflops'][i][j] = gflops
      data['bw'][i][j] = bw
      data['prep_time'][i][j] = prep_time
      data['time'][i][j] = tot_time
  
  end = time.time()
  pickle.dump(data, open("result/{}.gpu.pkl".format(tile_size), "wb"))
  print("Done Time: {} sec", end - start)

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument("--tile_size", "-tile", required=True, type=int, dest="tile_size", help="tile_size")
  #parser.add_argument("--block_size", "-block", dest="block_size", help='block size')
  #parser.add_argument("--buffer_size", "-buf", dest="buffer_size", help='buffer size')

  args = parser.parse_args()
  gpu_run(args.tile_size)

  
