


	-- Microprocesador sencillo

--Esta linea habilita la libreria IEEE, de la cual usamos los "package" del std_logic_1164, 
--IEEE.STD_LOGIC_ARITH y IEEE.STD_LOGIC_UNSIGNED, que me permiten operar con variables del
--tipo standard_logic

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


--Definición de las entradas y las salidas del microprocesador
ENTITY microsencill IS
PORT(clock, reset : 	IN STD_LOGIC;
    we :	OUT STD_LOGIC;
 	address_out, program_counter_out : 	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
 	register_A_out, memory_data_register_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
 	memory_data_register_input:IN STD_LOGIC_VECTOR(15 DOWNTO 0));
END microsencill;

--Arquitectura interna del mircoprocesador, consta de una unidad de control  
--descrita en modo comportamental 

ARCHITECTURE a OF microsencill IS
	-- Definimos un tipo de variable STATE_TYPE que me indica los posibles estados en los que
	-- puede estar el microprocesador
	TYPE STATE_TYPE IS (reset_pc, fetch, decode, execute_add, execute_load, execute_store,
		execute_store3, execute_store2, execute_jump, execute_sub,  execute_and, execute_or,
		execute_not, execute_jzero, execute_nop, execute_halt);
	
--Definición de señales, la variable state me indica el estado del procesador
SIGNAL state : STATE_TYPE;
SIGNAL instruction_register, memory_data_register, register_A : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL program_counter, memory_address_register : STD_LOGIC_VECTOR(7 DOWNTO 0);		 

-- Si memory_write=1 entonces escribiremos en memoria, si memory_write=0 lo que hacemos es leer
SIGNAL memory_write : STD_LOGIC;

BEGIN

-- Relación entre señales internas y la salida del micro (register_A_out me muestra el contenido
-- del acumulador, memory_data_register_out me muestra la salida a memoria, address_out indica la dirección
-- a acceder y program_counter_out indica el punto del programa en el que me encuentro
 address_out <= memory_address_register;
 program_counter_out <= program_counter;
 register_A_out <= register_A;
 we <= memory_write;

--A continuación detallo el comportamiento de la unidad de control
 PROCESS (CLOCK, RESET)
	BEGIN
	IF reset = '1' THEN
		state <= reset_pc;
	-- La unidad de control me ejecuta una instruccion a partir de cada flanco de subida.
	ELSIF clock'EVENT AND clock = '1' THEN
		CASE state IS
		-- dependiendo del estado hacemos una u otra operación, reset_pc me pone los registros a 0
		WHEN reset_pc =>
			program_counter <= "00000000";
			memory_address_register <= "00000000";
			register_A <= "0000000000000000";
			memory_write <= '0';
			state <= fetch;
		-- El estado "fetch" es el estado de búsqueda de instrucciones, carga de la memoria 
		--al registro de instrucciones  e incrementa el contador de programa en 1
		WHEN fetch =>
			instruction_register <= memory_data_register_input;
			program_counter <= program_counter + 1;
			memory_write <= '0';
			state <= decode;
		-- Segidamente se pasaria al estado de decodificación (en el siguiente
		-- ciclo de reloj).
		WHEN decode =>
			--Cargamos el contenido del registro de instrucciones (últimos 8 bits)
			-- en el registro de direcciones de la memoria (por si se ha de hacer algún acceso
			-- al decodificar luego una instrucción
			memory_address_register <= instruction_register(7 Downto 0);
			CASE instruction_register(15 downto 8) IS
					WHEN "00000011" =>            	
						state <= execute_add;	  	
					WHEN "00000001" =>				
						state <= execute_store;     
					WHEN "00000010" =>				
						state <= execute_load;		
					WHEN "00000000" =>				
						state <= execute_jump;
					WHEN "00000110" =>				
						state <= execute_sub;
 					WHEN "00000100" =>				
						state <= execute_and;
 					WHEN "00001100" =>				
						state <= execute_or;
 					WHEN "00001101" =>				
						state <= execute_not;
					WHEN "00000101" =>				
						state <= execute_jzero;
					WHEN "00000111" =>				
						state <= execute_nop;
					WHEN "10101010" =>
						state <= execute_halt;
					WHEN OTHERS =>					
						state <= fetch;
					END CASE;
		-- Ejecuta la función add
		WHEN execute_add =>
			register_a <= register_a + memory_data_register_input;
			memory_address_register <= program_counter;
			state <= fetch;

		-- Ejecuta la función store (en tres ciclos para escribir en memória)
		WHEN execute_store =>
			-- write register_A to memory
			memory_write <= '1';
			state <= execute_store2;
		-- Este estado se asegura que la dirección de la memoria es válido hasta que acaba el ciclo
		-- de escritura
		WHEN execute_store2 =>
			memory_write <= '0';
			state <= execute_store3;
		WHEN execute_store3 =>
			memory_address_register <= program_counter;
			state <= fetch;

		-- Ejecuta la instrucción load en donde se carga el contenido de la memoria 
		-- en el acumulador.
		WHEN execute_load =>
			register_a <= memory_data_register_input;
			memory_address_register <= program_counter;
			state <= fetch;

		-- Ejecuta la instrucción JUMP incrementando el contador de programa
		-- hasta donde diga el registro de instrucciones
		WHEN execute_jump =>
			memory_address_register <= instruction_register(7 Downto 0);
			program_counter <= instruction_register(7 Downto 0);
			state <= fetch;
		
		-- Ejecuta la función sub (resta del registro el contenido de la memoria
		WHEN execute_sub =>
			register_a <= register_a - memory_data_register_input;
			memory_address_register <= program_counter;
			state <= fetch;
			
		-- Ejecuta la función AND
		WHEN execute_and =>
			register_a <= register_a AND memory_data_register_input;
			memory_address_register <= program_counter;
			state <= fetch;	 

		-- Ejecuta la función OR
		WHEN execute_or =>
			register_a <= register_a OR memory_data_register_input;
			memory_address_register <= program_counter;
			state <= fetch;
			
		-- Ejecuta la función NOT
		WHEN execute_not =>
			register_a <= not register_a;
			memory_address_register <= program_counter;
			state <= fetch;
				
		-- Ejecuta la función NOP
		WHEN execute_nop =>			
			state <= fetch;

		-- Ejecuta la función jzero (salta si el acumulador es cero)
		WHEN execute_jzero =>
			IF register_A = "0000000000000000" THEN
				memory_address_register <= instruction_register(7 Downto 0);
				program_counter <= instruction_register(7 Downto 0);
			ELSE
				memory_address_register <= program_counter;
			END IF;
				state <= fetch;
				
		-- Ejecuta la función NOP
		WHEN execute_halt =>			
			state <= execute_halt;

		END CASE;
	END IF;
 END PROCESS;
END a;



