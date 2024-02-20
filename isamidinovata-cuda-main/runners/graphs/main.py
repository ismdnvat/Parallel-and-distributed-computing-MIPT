import matplotlib.pyplot as plt

x_list = [32., 64., 128., 256., 512., 1024.]
y1_list = [0.169984, 0.200256, 0.1727, 0.19232, 0.312576, 0.32]

plt.title('Graph of acceleration versus number of processes')
plt.xlabel('matrixSize')
plt.ylabel('program running time, milliseconds')

plt.plot(x_list, y1_list, label="KernelMatrixMul", marker='o')

plt.legend()

filename = "graphKernelMatrixMul.png"
plt.savefig(filename)

plt.show()
