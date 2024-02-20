import matplotlib.pyplot as plt

x_list = [1, 2, 3, 4, 5, 6, 7, 8]
y1_list = [0.000191124, 0.000281571, 0.000207138, 0.000227889, 0.000292998, 0.000217713, 0.000208492, 0.000220197]
y2_list = [0.048546, 0.038773, 0.0304359, 0.0308784, 0.0250719, 0.0223924, 0.0211275, 0.0160602]
y3_list = [0.0340173, 0.0390675, 0.0249637, 0.0226056, 0.0280264, 0.0258929, 0.0214388, 0.0337731]
work_time_1_p = 220
for i in y1_list:
    i /= work_time_1_p
for i in y2_list:
    i /= work_time_1_p
for i in y3_list:
    i /= work_time_1_p

plt.title('Graph of acceleration versus number of processes')
plt.xlabel('number of processes')
plt.ylabel('acceleration')

plt.plot(x_list, y1_list, label="N = 1.000", marker='o')
plt.plot(x_list, y2_list, label="N = 1.000.000", marker='o')
plt.plot(x_list, y3_list, label="N = 100.000.000", marker='o')

plt.legend()

filename = "graph.png"
plt.savefig(filename)

plt.show()
