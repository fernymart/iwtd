#include <iostream>


int cube[4][4][12] = {
    {
        {0, 0, 0, 0, 3, 3, 3, 3, 3, -1,-1, 0},
        {1, 1, 1, 1, 3, 3, 3, 3, 3, -1,-1, 0},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1}
    },
    {
        {1, 1, 1, 1, 3, 3, 3, 3, 3, -1,-1, 1},
        {1, 1, 1, 1, 3, 3, 3, 3, 3, -1,-1, 1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1}
    },
    {
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,  2},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1}
    },
    {
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 , -1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1},
        {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1},
        {-1,-1,-1,-1, 3, 3, 3, 3, 3, 3, 3,-1}
    }
};

int checkCube(int operador, int operandoIzq, int operandoDer){
    return cube[operandoIzq][operandoDer][operador];
}
