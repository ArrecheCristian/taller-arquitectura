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

// Arranca el programa, carga el dato a procesar, si es 0 termina la ejecucion
LOAD #INDICE
LDR @INICIO
JZ @TERMINAR

// Al numero en el registro A le resta el numero a contar
SUB #NUMERO
// Si es 0, significa que hay que aumentar el contador
JZ @CONTAR
// Si no, se sigue con el siguiente numero
JUMP @SIGUIENTE

// Aumenta el uno el contador, carga el contador, lo aumenta, y lo guarda
LOAD #CONTADOR @CONTAR
ADD #UNO
STORE #CONTADOR

// Aumenta el "puntero" del vector en uno, y lo guarda
LOAD #INDICE @SIGUIENTE
ADD #UNO
STORE #INDICE
JUMP @INICIO

// Termina la ejecucion, dejando la cantidad de ocurrencias en el registro A
LOAD #CONTADOR @TERMINAR
HALT 
