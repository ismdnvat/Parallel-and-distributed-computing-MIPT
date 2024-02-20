#include "KernelAdd.cuh"
#include <iostream>

float elapsedTime(cudaEvent_t start, cudaEvent_t stop) {
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  return ms;
}

int main() {
  int numElements;
  std::cin >> numElements;

  float h_a[numElements];
  float h_b[numElements];
  float h_result[numElements];

  float *d_a, *d_b, *d_result;

  int size = numElements * sizeof(float);

  for (int i = 0; i < numElements; ++i) {
    h_a[i] = 1.0f;
    h_b[i] = 2.0f;
  }

  cudaMalloc((void **) &d_a, size);
  cudaMalloc((void **) &d_b, size);
  cudaMalloc((void **) &d_result, size);

  cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

  int blockSize = 256;
  int gridSize = (numElements + blockSize - 1) / blockSize;
  
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  KernelAdd<<<gridSize, blockSize>>>(numElements, d_a, d_b, d_result);

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  cudaMemcpy(h_result, d_result, size, cudaMemcpyDeviceToHost);

  for (int i = 0; i < numElements; ++i) {
    std::cout << h_result[i] << " ";
  }
  std::cout << std::endl;
  
  float ms = elapsedTime(start, stop);
  std::cout << "Время выполнения ядра: " << ms << " миллисекунд" << std::endl;
  
  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_result);
  return 0;
}
