#include <ScalarMul.cuh>

__global__ void ScalarMulBlock(int numElements, float *vector1, float *vector2, float *result) {
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  float sum = 0.0f;

  for (int i = tid; i < numElements; i += stride) {
    sum += vector1[i] * vector2[i];
  }

  atomicAdd(result, sum);
}
