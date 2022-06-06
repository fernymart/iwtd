from asyncio.windows_events import NULL
import memory
import sys
import pygame

# print('Number of arguments:', len(sys.argv), 'arguments.')
# print ('Argument List:', str(sys.argv))

# mem = memory.Memory(10, 12, 13, 14, 15, 16, 2000, 2000, 2000, 2000, 2000, 2000)

# mem.printMems()

# pygame.init()

screen = NULL
def memAt(memAdd):
    if(memAdd >= 26000 and memAdd < 27000):
        return pointersTemp.at(memAdd)
    elif(memAdd >= 19000 and memAdd < 26000):
        return constantTable.at(memAdd)
    elif(memAdd >= 8000 and memAdd < 19000):
        return mainTable.at(memAdd)
    elif(memAdd >= 5000 and memAdd < 8000):
        return globalTable.at(memAdd)
    elif(memAdd < 0):
        x = pointersTemp.at(-memAdd)
        return memAt(x)

def fillMemAt(memAdd, val):
    if(memAdd >= 26000 and memAdd < 27000):
        pointersTemp.fill(memAdd, val)
    elif(memAdd >= 19000 and memAdd < 26000):
        constantTable.fill(memAdd, val)
    elif(memAdd >= 8000 and memAdd < 19000):
        mainTable.fill(memAdd, val)
    elif(memAdd >= 5000 and memAdd < 8000):
        globalTable.fill(memAdd, val)
    elif(memAdd < 0):
        x = pointersTemp.at(-memAdd);
        fillMemAt(x, val)

def fillPointsTo(memAdd, val):
    x = pointersTemp.at(memAdd);
    fillMemAt(x, val)

def getPointsTo(memAdd):
    x = pointersTemp.at(memAdd)
    return memAt(x)

pointersTemp = memory.pointerMemory(1000)
constantes = []
quints = []
obj = ''
with open(sys.argv[1], 'r') as fi:
    for line in fi:
        if '~~~~' in line:
            break
        constantes.append(line)
        # print (line)

    for line in fi:
        if '~~~~' in line:
            break
        # print (line)
    
    for line in fi:
        # print(line)
        quints.append(line)

constantTable = memory.constMemory(len(constantes))
for cons in constantes:
    constEntry = cons.split('"')
    constantTable.fill(int(constEntry[0]), constEntry[1])

globalTable = memory.globalMemory(1000)
mainTable = memory.Memory(2000)

ip = 0
# print(type(ip))
while True and ip <= len(quints):
    # print(type(ip))
    quint = quints[int(ip)].split(' ')
    # print(quint)
    if(quint[0] == "WRITE"):
        print(memAt(int(quint[1])))
        # print(f'opcode = {quint[0]} {quint[1]} {quint[2]} {quint[3]} {quint[4]}')
        ip+=1
    elif(quint[0] == "READ"):
        inP = input()
        fillMemAt(int(quint[1]), inP)
        ip+=1
    elif(quint[0] == "+"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) + memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "-"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) - memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "*"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) * memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "/"):
        denom = memAt(int(quint[2]))
        if denom == 0:
            raise Exception("Trying to divide by zero")
        fillMemAt(int(quint[3]), memAt(int(quint[1])) / denom)
        ip+=1
    elif(quint[0] == ">"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) > memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == ">="):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) >= memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "<"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) < memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "<="):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) <= memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "=="):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) == memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "!="):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) != memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "&&"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) and memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "||"):
        fillMemAt(int(quint[3]), memAt(int(quint[1])) or memAt(int(quint[2])))
        ip+=1
    elif(quint[0] == "="):
        fillMemAt(int(quint[3]), memAt(int(quint[1])))
        ip+=1
    elif(quint[0] == "GOTOF"):
        # print(int(quint[1]), memAt(int(quint[1])))
        if(not bool(memAt(int(quint[1])))):
            ip = int(quint[3])
        else:
            ip+=1
    elif(quint[0] == "GOTO"):
        # print(ip)
        ip = int(quint[3])
        # print(ip)
    elif(quint[0] == "ERA"):
        ip += 1
    elif(quint[0] == "RET"):
        ip += 1
    elif(quint[0] == "ENDPROC"):
        ip += 1
    elif(quint[0] == "GOTOSUB"):
        ip += 1
    elif(quint[0] == "GOTOMAIN"):
        ip += 1
    elif(quint[0] == "CR_CANV"):
        pygame.init();
        width = memAt(int(quint[1]))
        height = memAt(int(quint[2]))
        screen=pygame.display.set_mode([width, height])
        screen.fill((255, 255, 255))
        pygame.display.update()
        ip += 1
    elif(quint[0] == "CL_CANV"):
        screen.fill((255, 255, 255))
        pygame.display.update()
        ip += 1
    elif(quint[0] == "DEL_CANV"):
        pygame.quit()
        screen = NULL
        ip += 1
    elif(quint[0] == "DR_RECT"):
        rX = memAt(int(quint[1]))
        rY = memAt(int(quint[2]))
        rWidth = memAt(int(quint[3]))
        rHeight = memAt(int(quint[4]))
        pygame.draw.rect(screen, (0, 0, 0), (rX, rY, rWidth, rHeight))
        pygame.display.update()
        ip += 1
    elif(quint[0] == "DR_LINE"):
        lX = memAt(int(quint[1]))
        lY = memAt(int(quint[2]))
        lWidth = memAt(int(quint[3]))
        lHeight = memAt(int(quint[4]))
        pygame.draw.line(screen, (0, 0, 0), (lX, lY), (lWidth, lHeight))
        pygame.display.update()
        ip += 1
    elif(quint[0] == "DR_PIX"):
        pX = memAt(int(quint[1]))
        pY = memAt(int(quint[2]))
        pygame.draw.line(screen, (0, 0, 0), (pX, pY, 1, 1))
        pygame.display.update()
        ip += 1
    elif(quint[0] == "VER"):
        if(not((memAt(int(quint[1])) >= memAt(int(quint[2]))) and (memAt(int(quint[1])) < memAt(int(quint[3]))))):
            raise Exception("Index out of bounds")
        ip += 1
    elif(quint[0] == "END_FILE"):
        break

# print("ASFASD")
# pygame.quit()
sys.exit();
# pygame.quit();
# print(obj)