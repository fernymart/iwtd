# I Want To Develop, compilador para Ferocious Memory Language

Fecha: 6 de junio de 2022

Equipo: FML

Integrantes:
- Fernando Martínez Ortiz A01138576

## Avance #9
Fecha: 5 de junio de 2022
Se completa la generación de código de arreglos y de estatutos especiales del lenguaje FML. Se completa la máquina virtual. No se completa la implementación de funciones.

## Avance #8
Fecha: 3 de junio de 2022
Avances en la máquina virtual y mejora a la clase de mapa de memoria de ejecución. Se completa la generación de código de las funciones.

## Avance #7
Fecha: 30 de mayo de 2022
Se completa la generación de código de los estatutos lineales y no lineales. Se avanza en el modelado del mapa de memoria de ejecución.

## Avance #6
Fecha: 24 de mayo de 2022
Se separó el equipo. Se completaron casi todos los estatutos lineales. Se actualizó la propuesta de lenguaje para agregar componentes gráficos y que los arreglos solo sean de una dimensión debido al tiempo.

## Avance #5
Fecha: 19 de mayo de 2022
Se habló sobre separar el equipo y se le envió un correo a la maestra. No se hizo ningún avance en el compilador fuera de investigar el uso correcto del estatuto union en Flex y Bison.

## Avance #4
Fecha: 9 de mayo de 2022
En este avance nos concentramos en leer documentación sobre Flex/Bison e investigar sobre los cuádruplos y cómo terminar la estructura de la tabla de símbolos. También dentro de la carpeta de `/tests` se crearon archivos para probar la implementación de los cuádruplos cuando se tenga lista. Se cambió el diseño de la tabla de símbolos pues antes las variables globales y las funciones se guardaban en una misma tabla (es decir, una entrada podía ser de tipo variable, función o clase) y al crear una función se creaba un apuntador a otra tabla.

## Avance #3
Fecha: 1 de mayo de 2022
En este avance se agregaron las estructuras de la tabla de símbolos y del cubo semántico. Sin embargo, su integración e implementación en el código de analizador sintáctico sigue en proceso.

## Avance #2
Fecha: 24 de abril de 2022
En este avance se comenzó a diseñar la estructura de datos correspondiente a la tabla de símbolos.

## Avance #1
Fecha: 13 de abril de 2022
Este avance incluye los analizadores de léxico y de sintaxis, hechos con Flex y Bison, respectivamente.
La parte del analizador léxico se incluye en el archivo de `lexer.h` y el analizador sintáctico en el archivo `parser.y`.
De igual manera, se incluye un archivo llamado `example.txt`, el cual sirve como un ejemplo de un programa escrito en FML.

## Checklist
- [X] Léxico
- [X] Sintaxis
- [X] Tabla de símbolos
- [X] Cubo semántico
- [X] Cuádruplos expresiones
- [X] Cuádruplos estatutos lineales
- [X] Cuádruplos estatutos condicionales
- [X] Cuádruplos estatutos cíclicos
- [X] Cuádruplos de arreglos
- [ ] Cuádruplos de funciones
- [X] Cuádruplos de funciones especiales del lenguaje
- [X] Mapa de memoria
- [X] Estatutos lineales en máquina virtual
- [X] Estatutos no lineales en máquina virtual
- [X] Verificación y pointers de arreglos en máquina virtual
- [ ] Funciones en máquina virtual
- [X] Funciones especiales en máquina virtual




