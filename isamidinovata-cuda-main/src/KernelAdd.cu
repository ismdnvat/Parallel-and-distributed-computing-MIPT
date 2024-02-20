#include "KernelAdd.cuh"

__global__ void KernelAdd(int numElements, float* x, float* y, float* result) {
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = tid; i < numElements; i += stride) {
    result[i] = x[i] + y[i];
  }
}
