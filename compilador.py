def compilador(path):

	print("Leyendo:", path)

	# Abre el archivo de assembly	
	file = open(path, "r", encoding="ascii")
	salida = open("assembler", "w", encoding="ascii")

	# Define las instrucciones que no tienen operando
	solo_operando = {}

	# Define el diccionario de etiquetas
	etq = {}

	# Define el diccionario de etiquetas de saltos
	salto = {}

	# Define la lista de instrucciones
	ins = []

	# Recorre todo el archivo
	for line in file :

		# Imprime la linea para que quede mas linda
		print(line, end="")

		# Verifica que la linea no este vacia y que no sea un comentario
		if (len(line) > 1) & ~(line.startswith("//")):

			# Separa la instruccion
			p = line.split()

			# Si arranca con hashtag, se sabe que es una etiqueta
			if line.startswith("#"):

				# Agrega el dato al diccionario
				etq[p[0]] = p[1]
			
			# Si no arranca con hashtag asume que es una instruccion
			else:

				# Se fija si la instruccion tiene una etiquetea
				if len(p) == 3:

					# Si tiene una etiqueta, agrega la etiqueta al diccionario,
					# la clave es la direcion de la instruccion
					salto[p[2]] = len(ins)

				# Para las instrucciones que no tienen operando
				elif ( (p[0] == "NOP") | (p[0] == "HALT") | (p[0] == "LDR")) & (len(p) == 2):
					salto[p[1]] = len(ins)

				# Guarda la instruccion en la lista de instrucciones
				ins.append(p)

	# Imprime que comienza el procesamiento
	print()
	print("==========")
	print("  Salida  ")
	print("==========")
	print()

	print(etq)
	print(salto)
	print()

	# Define el diccionario que asocia etiqueta con direccion
	etq_dir = {}

	# Obtiene un array de claves para poder recorrer
	claves = list(etq.keys())


	# Carga de datos >>>>>>>>>>>>>>>>>>>>>>

	# Si el tamaño del array de instrucciones es N, significa que hay N
	# instrucciones, y se pueden agregar los datos al terminar las instrucciones
	for i in range(len(ins), len(ins) + len(etq)):

		# Se fija si el dato a cargar es una direccion de memoria
		if etq[claves[i - len(ins)]].startswith("#"):
			etq[claves[i - len(ins)]] = str(etq_dir[etq[claves[i - len(ins)]]])

		print("En", i, "carga el dato ", etq[claves[i - len(ins)]] )

		# Asocia la etiqueta con su direccion de memoria correspondiente
		etq_dir[claves[i - len(ins)]] = i

		# Imprime la instruccion correspondiente a cargar dato, que seria 11
		salida.write(str(11) + "\n")

		# Imprime la direccion a guardar el dato
		salida.write(str(i) + "\n")

		# Imprime el dato a guardar
		salida.write(etq[claves[i - len(ins)]] + "\n")



	# Carga de instrucciones >>>>>>>>>>>>>>

	# Recorre las instruccioens y reeemplazar las etiquetas
	for i in ins:

		if i[0] == "ADD":
			print("Suma el  valor de ", i[1], " (", etq_dir[i[1]], ")")
			salida.write(str(1) + "\n")
			salida.write(str(etq_dir[i[1]]) + "\n")

		elif i[0] == "STORE":
			print("Guarda A en ", i[1], " (", etq_dir[i[1]], ")")
			salida.write(str(2) + "\n")
			salida.write(str(etq_dir[i[1]]) + "\n")

		elif i[0] == "LOAD":
			print("Carga en A el valor ", i[1], " (", etq_dir[i[1]], ")")
			salida.write(str(3) + "\n")
			salida.write(str(etq_dir[i[1]]) + "\n")

		elif i[0] == "JUMP":
			print("Salta a la posicion ", i[1], " (", salto[i[1]], ")")
			salida.write(str(4) + "\n")
			salida.write(str(salto[i[1]]) + "\n")

		elif i[0] == "SUB":
			print("Resta el  valor de ", i[1], " (", etq_dir[i[1]], ")")
			salida.write(str(5) + "\n")
			salida.write(str(etq_dir[i[1]]) + "\n")

		elif i[0] == "AND":
			print("Operacion logica AND con el dato de ", i[1], " (", etq_dir[i[1]], ")")
			salida.write(str(6) + "\n")
			salida.write(str(etq_dir[i[1]]) + "\n")

		elif i[0] == "OR":
			print("Operacion logica OR con el dato de ", i[1], " (", etq_dir[i[1]], ")")
			salida.write(str(7) + "\n")
			salida.write(str(etq_dir[i[1]]) + "\n")

		elif i[0] == "NOT":
			print("Operacion logica NOT sobre A")
			salida.write(str(8) + "\n")

		elif i[0] == "JZ":
			print("Salta si A es 0, a la posicion ", i[1], " (", salto[i[1]], ")")
			salida.write(str(9) + "\n")
			salida.write(str(salto[i[1]]) + "\n")

		elif i[0] == "NOP":
			print("No hace nada ", i[1], " (", salto[i[1]], ")")
			salida.write(str(10) + "\n")

		elif i[0] == "LDR":
			print("Carga en el registro A, el contenido de la direccion de memoria definida en A ", i[1], " (", salto[i[1]], ")")
			salida.write(str(12) + "\n")

		elif i[0] == "HALT":
			print("Termina la ejecucion ")
			salida.write(str(0) + "\n")


	#Cierra los archivos
	file.close()
	salida.close()

	return None


compilador(input("Ingrese el path del archivo: "))
input("Presione enter para salir")