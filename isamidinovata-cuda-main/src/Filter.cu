#include <Filter.cuh>

__global__ void Filter(
    int numElements,
    float* array,
    OperationFilterType type,
    float* value,
    float* result,
    int* validElementCount
) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    validElementCount = 0;

    for (int i = tid; i < numElements; i += stride) {
        bool condition = false;
        if (type == GT) {
            condition = array[i] > *value;
        } else if (type == LT) {
            condition = array[i] < *value;
        }
        if (condition) {
            int index = atomicAdd(validElementCount, 1);
            result[index] = array[i];
        }
    }
}

