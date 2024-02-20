#include <MatrixVectorMul.cuh>

__global__ void MatrixVectorMul(int height, int width, float *matrix, float *vector, float *result) {
  int row = blockIdx.x * blockDim.x + threadIdx.x;
  if (row < height) {
    float sum = 0.0f;
    for (int col = 0; col < width; ++col) {
      int index = row * width + col;
      sum += matrix[index] * vector[col];
    }
    result[row] = sum;
  }
}

