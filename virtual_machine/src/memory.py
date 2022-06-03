class Memory:
    varsMemorySpace = [[], [], []]
    tempMemorySpace = [[], [], []]
    def __init__(self, varsIntSpace, varsFltSpace, varsCharSpace, tempIntSpace, tempFltSpace, tempBoolSpace, baseVarInt, baseVarFlt, baseVarChar, baseTempInt, baseTempFlt, baseTempBool):
        self.varsMemorySpace[0] = [0]*varsIntSpace
        self.varsMemorySpace[1] = [0]*varsFltSpace
        self.varsMemorySpace[2] = [0]*varsCharSpace

        self.tempMemorySpace[0] = [0]*tempIntSpace
        self.tempMemorySpace[1] = [0]*tempFltSpace
        self.tempMemorySpace[2] = [0]*tempBoolSpace

    def printMems(self):
        for mem in self.varsMemorySpace:
            for casilla in mem:
                print(casilla, end=" ")
            print('\n')

        for mem in self.tempMemorySpace:
            for casilla in mem:
                print(casilla, end=" ")
            print('\n')
