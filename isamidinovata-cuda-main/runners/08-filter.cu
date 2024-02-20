#include <Filter.cuh>
#include <iostream>

float elapsedTime(cudaEvent_t start, cudaEvent_t stop) {
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  return ms;
}

int main() {
  int numElements;
  float value;
  std::cin >> numElements >> value;

  OperationFilterType type = GT;
  float h_array[numElements];
  for (int i = 0; i < numElements; ++i) {
    h_array[i] = i;
  }
  float h_value = 0.5f;
  float h_result[numElements];
  int h_valid_res;

  float *d_array, *d_value, *d_result;
  int* d_valid_res;
  int arraySize = numElements * sizeof(float);
  cudaMalloc((void**)&d_array, arraySize);
  cudaMalloc((void**)&d_value, sizeof(float));
  cudaMalloc((void**)&d_result, arraySize);
  cudaMalloc((void**)&d_valid_res, sizeof(int));

  cudaMemcpy(d_array, h_array, arraySize, cudaMemcpyHostToDevice);
  cudaMemcpy(d_value, &h_value, sizeof(float), cudaMemcpyHostToDevice);

  int blockSize = 256;
  int gridSize = (numElements + blockSize - 1) / blockSize;
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  Filter<<<gridSize, blockSize>>>(numElements, d_array, type, d_value, d_result, d_valid_res);

  cudaMemcpy(&h_result, d_result, arraySize, cudaMemcpyDeviceToHost);
  cudaMemcpy(&h_valid_res, d_valid_res, arraySize, cudaMemcpyDeviceToHost);
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  for (int i = 0; i < numElements; ++i) {
    std::cout << h_array[i] << " ";
  }
  std::cout << std::endl;
  for (int i = 0; i < h_valid_res; ++i) {
    std::cout << h_result[i] << " ";
  }
  std::cout << std::endl;
  float ms = elapsedTime(start, stop);
  std::cout << "Время выполнения ядра: " << ms << " миллисекунд" << std::endl;

  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  cudaFree(d_array);
  cudaFree(d_value);
  cudaFree(d_result);
  cudaFree(d_valid_res);
  return 0;
}
