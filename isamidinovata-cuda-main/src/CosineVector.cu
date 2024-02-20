#include <CosineVector.cuh>
#include <math.h>

__global__ void CosineAngle(int numElements, const float *vector1, const float *vector2, float *result) {
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  float dotProduct = 0.0f;
  float lengthVector1 = 0.0f;
  float lengthVector2 = 0.0f;

  for (int i = tid; i < numElements; i += stride) {
    dotProduct += vector1[i] * vector2[i];
    lengthVector1 += vector1[i] * vector1[i];
    lengthVector2 += vector2[i] * vector2[i];
  }

  __shared__ float sharedDotProduct[1024];
  __shared__ float sharedLengthVector1[1024];
  __shared__ float sharedLengthVector2[1024];
  sharedDotProduct[threadIdx.x] = dotProduct;
  sharedLengthVector1[threadIdx.x] = lengthVector1;
  sharedLengthVector2[threadIdx.x] = lengthVector2;
  __syncthreads();

  int threadCount = blockDim.x;
  while (threadCount > 1) {
    int halfThreadCount = (threadCount + 1) / 2;
    if (threadIdx.x < halfThreadCount) {
      int otherIndex = threadIdx.x + halfThreadCount;
      if (otherIndex < threadCount) {
        sharedDotProduct[threadIdx.x] += sharedDotProduct[otherIndex];
        sharedLengthVector1[threadIdx.x] += sharedLengthVector1[otherIndex];
        sharedLengthVector2[threadIdx.x] += sharedLengthVector2[otherIndex];
      }
    }
    __syncthreads();
    threadCount = halfThreadCount;
  }
  if (threadIdx.x == 0) {
    atomicAdd(result, sharedDotProduct[0] / (sqrtf(sharedLengthVector1[0]) * sqrtf(sharedLengthVector2[0])));
  }
}

float elapsedTime(cudaEvent_t start, cudaEvent_t stop) {
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  return ms;
}

float CosineVector(int numElements, float *vector1, float *vector2, int blockSize) {
  float *deviceVector1, *deviceVector2, *deviceResult;

  cudaMalloc((void **) &deviceVector1, numElements * sizeof(float));
  cudaMalloc((void **) &deviceVector2, numElements * sizeof(float));
  cudaMalloc((void **) &deviceResult, sizeof(float));

  cudaMemcpy(deviceVector1, vector1, numElements * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(deviceVector2, vector2, numElements * sizeof(float), cudaMemcpyHostToDevice);

  int gridSize = (numElements + blockSize - 1) / blockSize;

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  CosineAngle<<<gridSize, blockSize, blockSize
      * sizeof(float)>>>(numElements, deviceVector1, deviceVector2, deviceResult);

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  float hostResult;
  cudaMemcpy(&hostResult, deviceResult, sizeof(float), cudaMemcpyDeviceToHost);

  float ms = elapsedTime(start, stop);
  //std::cout << "Время выполнения ядра: " << ms << " миллисекунд" << std::endl;
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  cudaFree(deviceVector1);
  cudaFree(deviceVector2);
  cudaFree(deviceResult);

  return hostResult;
}
