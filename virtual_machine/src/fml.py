import memory
import sys

print('Number of arguments:', len(sys.argv), 'arguments.')
print ('Argument List:', str(sys.argv))

# mem = memory.Memory(10, 12, 13, 14, 15, 16, 2000, 2000, 2000, 2000, 2000, 2000)

# mem.printMems()
def memAt(memAdd):
    if(memAdd >= 13000 and memAdd < 17000):
        return constantTable.at(17000)

quints = []
obj = ''
with open(sys.argv[1], 'r') as fi:
    for line in fi:
        if '~~~~' in line:
            break
        print (line)

    for line in fi:
        if '~~~~' in line:
            break
        print (line)
    
    for line in fi:
        print(line)
        quints.append(line)

ip = 0
for ip in range(len(quints)):
    quint = quints[ip].split(' ')
    if(quint[0] == "WRITE"):
        print(memAt(quint[1]))
        print(f'opcode = {quint[0]} {quint[1]} {quint[2]} {quint[3]} {quint[4]}')

print(obj)