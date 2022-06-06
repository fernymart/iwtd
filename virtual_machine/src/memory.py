class Memory:
    varsMemorySpace = [[], [], []]
    tempMemorySpace = [[], [], []]
    def __init__(self, space):
        self.varsMemorySpace[0] = [0]*space
        self.varsMemorySpace[1] = [0]*space
        self.varsMemorySpace[2] = [0]*space

        self.tempMemorySpace[0] = [0]*space
        self.tempMemorySpace[1] = [0]*space
        self.tempMemorySpace[2] = [0]*space

    def fill(self, pos, val):
        if(pos < 10000):
            self.varsMemorySpace[0][pos - 8000] = int(val)
        elif(pos < 12000):
            self.varsMemorySpace[1][pos - 10000] = float(val)
        elif(pos < 13000):
            val = str(val.replace("\'", ''))
            if len(val):
                raise Exception("Not a char")
            self.varsMemorySpace[2][pos - 12000] = str(val)
        elif(pos < 15000):
            self.tempMemorySpace[0][pos - 13000] = int(val)
        elif(pos < 17000):
            self.tempMemorySpace[1][pos - 15000] = float(val)
        elif(pos < 19000):
            self.tempMemorySpace[2][pos - 17000] = bool(val)

    def at(self, pos):
        if(pos < 10000):
            return self.varsMemorySpace[0][pos - 8000]
        elif(pos < 12000):
            return self.varsMemorySpace[1][pos - 10000]
        elif(pos < 13000):
            return self.varsMemorySpace[2][pos - 12000]
        elif(pos < 15000):
            return self.tempMemorySpace[0][pos - 13000]
        elif(pos < 17000):
            return self.tempMemorySpace[1][pos - 15000]
        elif(pos < 19000):
            return self.tempMemorySpace[2][pos - 17000]

    def printMems(self):
        for mem in self.varsMemorySpace:
            for casilla in mem:
                print(casilla, end=" ")
            print('\n')

        for mem in self.tempMemorySpace:
            for casilla in mem:
                print(casilla, end=" ")
            print('\n')

class constMemory:
    memSpace = [[], [], [], []]
    def __init__(self, space):
        self.memSpace[0] = [0]*space
        self.memSpace[1] = [0]*space
        self.memSpace[2] = [0]*space
        self.memSpace[3] = [0]*space

    def fill(self, pos, val):
        if(pos < 21000):
            # print(pos)
            self.memSpace[0][pos - 19000] = int(val)
        elif(pos < 23500):
            self.memSpace[1][pos - 21000] = float(val)
        elif(pos < 24000):
            val = str(val.replace("\'", ''))
            self.memSpace[2][pos - 23500] = str(val)
        elif(pos < 26000):
            # print(val)
            val = str(val.replace("\"", ''))
            # print("\n\n\n")
            self.memSpace[3][pos - 24000] = str(val)
            

    def at(self, pos):
        # print(pos)
        if(pos < 21000):
            return self.memSpace[0][pos - 19000]
        elif(pos < 23500):
            return self.memSpace[1][pos - 21000]
        elif(pos < 24000):
            return self.memSpace[2][pos - 23500]
        elif(pos < 26000):
            return self.memSpace[3][pos - 24000]


class globalMemory:
    memSpace = [[], [], []]
    def __init__(self, space):
        self.memSpace[0] = [0]*space
        self.memSpace[1] = [0]*space
        self.memSpace[2] = [0]*space

    def fill(self, pos, val):
        if(pos < 6000):
            self.memSpace[0][pos - 5000] = int(val)
        elif(pos < 7000):
            self.memSpace[1][pos - 6000] = float(val)
        elif(pos < 8000):
            print(val)
            val = str(val.replace("\'", ''))
            self.memSpace[2][pos - 7000] = str(val)
        

    def at(self, pos):
        # print(pos)
        if(pos < 6000):
            return self.memSpace[0][pos - 5000]
        elif(pos < 7000):
            return self.memSpace[1][pos - 6000]
        if(pos < 8000):
            return self.memSpace[2][pos - 7000]
        