#include <iostream>
#include <cmath>
#include <vector>
#include <mpi.h>
#include <sys/times.h>

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

int main(int argc, char** argv) {
  int N;
  cin >> N;
  MPI_Init(&argc, &argv);
  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  double start_time = MPI_Wtime();
  MPI_Status status;
  const double a = 0.0;
  const double b = 1.0;

  double local_integral = trapezoidal_integral(a + rank * (b - a) / size, a + (rank + 1) * (b - a) / size, N / size);
  if (rank != 0) {
    MPI_Send(&local_integral, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);

  } else {
    vector<double> all_integrals(size, 0);
    all_integrals[0] = local_integral;
    for (int i = 1; i < size; ++i) {
      MPI_Recv(&all_integrals[i], 1, MPI_DOUBLE, i, 0, MPI_COMM_WORLD, &status);
    }

    for (auto i = 0; i < size; ++i) {
      cout << "Процесс " << i << " = " << all_integrals[i] << endl;
    }

    double total_integral = 0.0;
    for (auto iterator : all_integrals) {
      total_integral += iterator;
    }
    cout << "Integral I, calculated by adding all parts of the integral = " << total_integral << endl;
    double integral_I_0 = trapezoidal_integral(a, b, N);
    cout << "Integral I_0 considered the master process consistently = " << integral_I_0 << endl;
    double end_time = MPI_Wtime();
    cout << "Program working time = " << end_time - start_time << endl;
  }
  MPI_Finalize();
  return 0;
}
