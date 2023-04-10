import sys
import os

if len(sys.argv) <= 1:
    print("No input file!")
    exit(-1)

filename = sys.argv[1]
data = bytes()
with open(filename, "rb") as f:
    data = f.read()
    f.close()

filename = [(sys.argv[2] + str(i) + ".txt") for i in range(4)]

data_size = 262144
length = len(data) / 4
zero = 0

for i in range(4):
    with open(filename[i], "w") as f:
        for j in range(int(data_size / 4)):
            f.write("@")
            f.write(hex(j)[2:].zfill(4))
            f.write("  ")
            if j < length:
                f.write(hex(data[i + j * 4])[2:].zfill(2))
            else:
                f.write(str(zero).zfill(2))
            f.write("\n")

