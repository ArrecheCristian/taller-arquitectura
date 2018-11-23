// Define los arreglos

#ARRAY1 1000_0001_1010_1111b

#ARRAY2 0111_1110_0101_0000b


// Carga el primer array
LOAD #ARRAY1

// Hace un AND con el segundo, que debe dar 0
AND #ARRAY2

// Carga nuevamente el primer array, y hace un OR con el segundo, debe dar 0
LOAD #ARRAY1
OR #ARRAY2

// Hace ARRAY1 AND (NOT ARRAY1), que deberia dar 0
LOAD #ARRAY1
NOT
AND #ARRAY1

// Termina la ejecucion
HALT