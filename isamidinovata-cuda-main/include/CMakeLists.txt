cmake_minimum_required(VERSION 3.26)
project(include)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(include
        CommonKernels.cuh
        CosineVector.cuh
        Filter.cuh
        KernelAdd.cuh
        KernelMatrixAdd.cuh
        KernelMul.cuh
        MatrixMul.cuh
        MatrixVectorMul.cuh
        ScalarMul.cuh
        ScalarMulRunner.cuh)
