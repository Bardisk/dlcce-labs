import sys

f = open(sys.argv[2], "r")
alldata = f.read().split('\n')
print("readdone!")
f.close()

itr = 0

sample = alldata[itr]
while not (len(sample) > 0 and ((ord(sample[0]) >= ord('A') and ord(sample[0]) <= ord('F')) or (ord(sample[0]) >= ord('0') and ord(sample[0]) <= ord('9')))):
    itr = itr + 1
    sample = alldata[itr]

print("pre done!")

data = []

cnt = 0

while True:
#   print(sample)
    cnt = cnt + 1
    if cnt % 1000 == 0:
       print(cnt)
    tokens = sample.strip().split(',')
#   print(tokens)
    for i in tokens:
#       print(i)
        if not len(i):
            continue
        data.append(i[2])
        data.append(i[1])
        data.append(i[0])
#       print(v)
        
    itr = itr + 1
    if itr == len(alldata):
        break
    sample = alldata[itr]


#print(len(data))

#print(data)
f.close()
print("read done!")

f = open(sys.argv[1], "w")

for i in range(0, len(data), 3):
    f.write("@{:x} {}{}{}\n".format(i//3, data[i+2], data[i+1], data[i]))

f.close()