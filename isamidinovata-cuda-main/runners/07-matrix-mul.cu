#include <MatrixMul.cuh>
#include <iostream>

float elapsedTime(cudaEvent_t start, cudaEvent_t stop) {
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  return ms;
}

int main() {
  int height1;
  int width1;
  int height2;
  int width2;
  std::cin >> height1 >> width1;
  std::cin >> height2 >> width2;
  
  float h_A[height1][width1];
  float h_B[height2][width2];
  float h_result[height1][width2];
  for (int i = 0; i < height1; ++i) {
    for (int j = 0; j < width1; ++j) {
      h_A[i][j] = 1.0f + i * j;
    }
  }
  for (int i = 0; i < height2; ++i) {
    for (int j = 0; j < width2; ++j) {
      h_B[i][j] = 2.0f + i * j;
    }
  }
  float *d_A, *d_B, *d_result;
  int size1 = height1 * width1 * sizeof(float);
	int size2 = height2 * width2 * sizeof(float);
	int size_of_res = height1 * width2 * sizeof(float);
  cudaMalloc((void **) &d_A, size1);
  cudaMalloc((void **) &d_B, size2);
  cudaMalloc((void **) &d_result, size_of_res);

  cudaMemcpy(d_A, h_A, size1, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, size2, cudaMemcpyHostToDevice);

  dim3 blockSize(16, 16);
  dim3 gridSize((width2 + blockSize.x - 1) / blockSize.x, (height1 + blockSize.y - 1) / blockSize.y);
  
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);
  
  MatrixMul<<<gridSize, blockSize>>>(height1, width2, width2, d_A, d_B, d_result);
  
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  
  cudaMemcpy(h_result, d_result, size_of_res, cudaMemcpyDeviceToHost);
  
  for (int i = 0; i < height1; ++i) {
    for (int j = 0; j < width1; ++j) {
      std::cout << h_A[i][j] << " ";
    }
    std::cout << std::endl;
  }
  
  for (int i = 0; i < height2; ++i) {
    for (int j = 0; j < width2; ++j) {
      std::cout << h_B[i][j] << " ";
    }
    std::cout << std::endl;
  }
  
  for (int i = 0; i < height1; ++i) {
    for (int j = 0; j < width2; ++j) {
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

