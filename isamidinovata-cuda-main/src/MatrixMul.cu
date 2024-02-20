#include <MatrixMul.cuh>

__global__ void MatrixMul(int heightA, int widthA, int widthB, float *matrixA, float *matrixB, float *matrixResult) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    int tx = threadIdx.x;
    int ty = threadIdx.y;

    const int blockSize = 16;
    __shared__ float sharedA[blockSize][blockSize];
    __shared__ float sharedB[blockSize][blockSize];

    float result = 0.0;

    for (int m = 0; m < (widthA + blockSize - 1) / blockSize; m++) {
        if (row < heightA && m * blockSize + tx < widthA) {
            sharedA[ty][tx] = matrixA[row * widthA + m * blockSize + tx];
        } else {
            sharedA[ty][tx] = 0.0;
        }

        if (m * blockSize + ty < widthA && col < widthB) {
            sharedB[ty][tx] = matrixB[(m * blockSize + ty) * widthB + col];
        } else {
            sharedB[ty][tx] = 0.0;
        }

        __syncthreads();

        for (int k = 0; k < blockSize; k++) {
            result += sharedA[ty][k] * sharedB[k][tx];
        }

        __syncthreads();
    }

    if (row < heightA && col < widthB) {
        matrixResult[row * widthB + col] = result;
    }
}

