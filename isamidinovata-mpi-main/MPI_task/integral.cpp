#include <iostream>

using namespace std;

double f(double x) {
  return 4.0 / (1.0 + x * x);
}

double trapezoidal_integral(double a, double b, int N) {
  double h = (b - a) / N;
  double result = (f(a) + f(b)) / 2.0;
  for (int i = 1; i < N; ++i) {
    double x_i = a + i * h;
    result += f(x_i);
  }
  result *= h;
  return result;
}

int main() {
  int N;
  cin >> N;
  clock_t start_time = clock();
  const double a = 0.0;
  const double b = 1.0;
  double integral_I_0 = trapezoidal_integral(a, b, N);
  cout << "Integral I_0 considered the master process consistently = " << integral_I_0 << endl;
  cout << "Program working time = " << clock() - start_time << endl;
  return 0;
}
