#include <CosineVector.cuh>
#include <math.h>
#include <iostream>

int main() {
  int numElements;
  std::cin >> numElements;

  float hostVector1[numElements];
  float hostVector2[numElements];

  for (int i = 0; i < numElements; ++i) {
    hostVector1[i] = 1.0f;
    hostVector2[i] = 2.0f;
  }
  std::cout << CosineVector(numElements, hostVector1, hostVector2, numElements) << std::endl;

  return 0;
}
