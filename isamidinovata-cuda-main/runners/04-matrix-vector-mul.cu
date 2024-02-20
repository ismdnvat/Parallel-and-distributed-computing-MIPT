#include <MatrixVectorMul.cuh>
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
  int width = numElements;
  float h_matrix[height][width];
  float h_transpon_vector[width];
  float h_result[height];
  for (int i = 0; i < height; ++i) {
    for (int j = 0; j < width; ++j) {
      h_matrix[i][j] = 4;
      h_transpon_vector[i] = 2;
    }
  }
  float *d_matrix, *d_vector, *d_result;
  int size_of_matrix = height * width * sizeof(float);
  int size_of_vector = width * sizeof(float);
  int size_of_result = height * sizeof(float);
  
  cudaMalloc((void **) &d_matrix, size_of_matrix);
  cudaMalloc((void **) &d_vector, size_of_vector);
  cudaMalloc((void **) &d_result, size_of_result);

  cudaMemcpy(d_matrix, h_matrix, size_of_matrix, cudaMemcpyHostToDevice);
  cudaMemcpy(d_vector, h_transpon_vector, size_of_vector, cudaMemcpyHostToDevice);
  
  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);

  MatrixVectorMul<<<height, 1>>>(height, width, d_matrix, d_vector, d_result);

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  cudaMemcpy(h_result, d_result, size_of_result, cudaMemcpyDeviceToHost);
  
  for (int i = 0; i < height; ++i) {
    std::cout << h_result[i] << " ";
  }
  std::cout << std::endl;

  float ms = elapsedTime(start, stop);
  std::cout << "Время выполнения ядра: " << ms << " миллисекунд" << std::endl;
  
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  cudaFree(d_matrix);
  cudaFree(d_vector);
  cudaFree(d_result);
  
  return 0;
}
