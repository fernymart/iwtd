#include <iostream>

struct Ops {
    int add;
    int sub;
    int mult;
    int div;
};

void printCube(Ops cube[3][3]) {
    for(int i=0; i<3; i++) {
        for(int j=0; j<3; j++) {
            std::cout << "CELDA [ " << i << " ] [ " << j << " ]" << std::endl;
            std::cout << "ADD: " << cube[i][j].add << std::endl;
            std::cout << "SUB: " << cube[i][j].sub << std::endl;
            std::cout << "MULT: " << cube[i][j].mult << std::endl;
            std::cout << "DIV: " << cube[i][j].div << std::endl;
            std::cout << std::endl;
        }
    }
}

void populate(Ops semCube[3][3]) {
    // [0][0]   in-in
    semCube[0][0].add = 0;
    semCube[0][0].sub = 0;
    semCube[0][0].mult = 0;
    semCube[0][0].div = 1;

    // [0][1]   in-flt
    semCube[0][1].add = 1;
    semCube[0][1].sub = 1;
    semCube[0][1].mult = 1;
    semCube[0][1].div = 1;

    // [0][2]   in-ch
    semCube[0][2].add = -1;
    semCube[0][2].sub = -1;
    semCube[0][2].mult = -1;
    semCube[0][2].div = -1;

    // [1][0]   flt-in
    semCube[1][0].add = 1;
    semCube[1][0].sub = 1;
    semCube[1][0].mult = 1;
    semCube[1][0].div = 1;

    // [1][1]   flt-flt
    semCube[1][1].add = 1;
    semCube[1][1].sub = 1;
    semCube[1][1].mult = 1;
    semCube[1][1].div = 1;

    // [1][2]   flt-ch
    semCube[1][2].add = -1;
    semCube[1][2].sub = -1;
    semCube[1][2].mult = -1;
    semCube[1][2].div = -1;

    // [2][0]   ch-in
    semCube[2][0].add = -1;
    semCube[2][0].sub = -1;
    semCube[2][0].mult = -1;
    semCube[2][0].div = -1;

    // [2][1]   ch-flt
    semCube[2][1].add = -1;
    semCube[2][1].sub = -1;
    semCube[2][1].mult = -1;
    semCube[2][1].div = -1;

    // [2][2]   ch-ch
    semCube[2][2].add = -1;
    semCube[2][2].sub = -1;
    semCube[2][2].mult = -1;
    semCube[2][2].div = -1;
}

int main() {
    /*
       Representación cubo semántico
       Matriz de 2 dimensiones, cada casilla es un struct que tiene como atributos/miembros a las operaciones (+ - * /)
       int resultado = semCube[0][0].add
    
        0   -->   in
        1   -->   flt
        2   -->   ch
        -1  -->   err

        OP1     OP2     +   -   *   /
        -------------------------------
        in      in      0   0   0   1
        in      flt     1   1   1   1
        in      ch      -1  -1  -1  -1
        flt     in      1   1   1   1
        flt     flt     1   1   1   1
        flt     ch      -1  -1  -1  -1
        ch      in      -1  -1  -1  -1
        ch      flt     -1  -1  -1  -1
        ch      ch      -1  -1  -1  -1

    */

    Ops semCube[3][3];
    populate(semCube);
    printCube(semCube);
}