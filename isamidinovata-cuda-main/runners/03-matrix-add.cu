#include <KernelMatrixAdd.cuh>
#include <iostream>

float elapsedTime(cudaEvent_t start, cudaEvent_t stop) {
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  return ms;
}

int main() {
  int numElements;
  std::cin >> numElements;
  int height = numElements;
  int width = 10;
  int pitch = width;
  float h_A[height][width];
  float h_B[height][width];
  float h_result[height][width];
  for (int i = 0; i < height; ++i) {
    for (int j = 0; j < width; ++j) {
      h_A[i][j] = 1;
      h_B[i][j] = 2;
    }
  }
  float *d_A, *d_B, *d_result;
  int size = height * width * sizeof(float);

  cudaMalloc((void **) &d_A, size);
  cudaMalloc((void **) &d_B, size);
  cudaMalloc((void **) &d_result, size);

  cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

  dim3 blockSize(16, 16);
  dim3 gridSize((width + blockSize.x - 1) / blockSize.x, (height + blockSize.y - 1) / blockSize.y);
  
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);
  
  KernelMatrixAdd<<<gridSize, blockSize>>>(height, width, pitch, d_A, d_B, d_result);
  
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  
  cudaMemcpy(h_result, d_result, size, cudaMemcpyDeviceToHost);
  
  for (int i = 0; i < height; ++i) {
    for (int j = 0; j < width; ++j) {
      std::cout << h_result[i][j] << " ";
    }
    std::cout << std::endl;
  }
  float ms = elapsedTime(start, stop);
  std::cout << "Время выполнения ядра: " << ms << " миллисекунд" << std::endl;
  
  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_result);
  
  return 0;
}
