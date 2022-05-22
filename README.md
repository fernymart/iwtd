# Avance #1 - Léxico y Sintaxis

Fecha: 1 de mayo de 2022

Equipo: FML

Integrantes:
- Guillermo Andrés García Vázquez A01283254
- Fernando Martínez Ortiz A01138576

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

## Bugs arreglados
- Problemas con id si es que contiene un substring de una palabra reservada
- El main ya no es detectado como otra funcion
- Llamar una funcion como asignacion de variable o dentro de otra funcion ya no causa error

## Bugs conocidos en esta version

