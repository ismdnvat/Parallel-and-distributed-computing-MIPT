#include <ScalarMul.cuh>
#include <iostream>

float elapsedTime(cudaEvent_t start, cudaEvent_t stop) {
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  return ms;
}

int main() {
  int numElements;
  std::cin >> numElements;

  float hostVector1[numElements];
  float hostVector2[numElements];

  for (int i = 0; i < numElements; ++i) {
    hostVector1[i] = 1.0f;
    hostVector2[i] = 2.0f;
  }
  float *deviceVector1, *deviceVector2, *deviceResult;

  cudaMalloc((void **) &deviceVector1, numElements * sizeof(float));
  cudaMalloc((void **) &deviceVector2, numElements * sizeof(float));
  cudaMalloc((void **) &deviceResult, sizeof(float));

  cudaMemcpy(deviceVector1, hostVector1, numElements * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(deviceVector2, hostVector2, numElements * sizeof(float), cudaMemcpyHostToDevice);

  int blockSize = numElements;
  int gridSize = (numElements + blockSize - 1) / blockSize;

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  ScalarMulBlock<<<gridSize, blockSize, blockSize * sizeof(float)>>>(numElements, deviceVector1, deviceVector2, deviceResult);

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  float hostResult;
  cudaMemcpy(&hostResult, deviceResult, sizeof(float), cudaMemcpyDeviceToHost);

  std::cout << hostResult << std::endl;

  float ms = elapsedTime(start, stop);
  std::cout << "Время выполнения ядра: " << ms << " миллисекунд" << std::endl;
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  cudaFree(deviceVector1);
  cudaFree(deviceVector2);
  cudaFree(deviceResult);

  return 0;
}
