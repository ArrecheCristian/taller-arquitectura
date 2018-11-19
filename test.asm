// Define el numero uno para poder incrementar
#UNO 1

// Define el array, no hay otra manera
#ARRAY 1
#A 2
#B 3
#C 2
#D 2
#E 2
#F 7
#G 0

// Define la posicion de inicio del array
#INDICE #ARRAY

// Define el numero a buscar
#NUMERO 2

// Define el contador 
#CONTADOR 0

// Arranca el programa
LOAD #INDICE
LDR @INICIO
JZ @TERMINAR

SUB #NUMERO
JZ @CONTAR
JUMP @SIGUIENTE

LOAD #CONTADOR @CONTAR
ADD #UNO
STORE #CONTADOR

LOAD #INDICE @SIGUIENTE
ADD #UNO
STORE #INDICE
JUMP @INICIO

LOAD #CONTADOR @TERMINAR
HALT 
