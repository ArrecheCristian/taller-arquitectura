LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;				   
USE work.Utils_STD_LOGIC.all;


entity testproc is
end testproc;



architecture testbench of testproc is	

	    component bco_memoria
            port (clock, reset, we : 	IN STD_LOGIC; 
			address_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			asinc_bus_pos : IN natural;
			memory_data_output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
 			memory_data_input:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			asinc_bus_ins : IN std_logic_vector(15 downto 0));
		end component;	 
		
		
		component microsencill
			port(clock, reset : 	IN STD_LOGIC;
    			we :	OUT STD_LOGIC;
	 			address_out, program_counter_out : 	OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 		register_A_out, memory_data_register_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
 				memory_data_register_input:IN STD_LOGIC_VECTOR(15 DOWNTO 0));
		end component;
		
		
	procedure Guardar_instr(
		-- Señal a donde hay que mandar la posicion a cargar
		signal bus_pos: out natural;
		
		-- Señal a donde se va a manar el dato
		signal bus_ins: out std_logic_vector(15 downto 0);
		
		-- Posicion a donde escribir
		variable pos : inout natural;
		
		-- Operando que forma parte de la instruccion
		variable operando : std_logic_vector(7 downto 0);
		
		-- Codigo de operación a realizar
		variable instr_input : std_logic_vector(15 downto 8)
	) is
	
		-- Variable de uso interno, representa la instruccion completa
		variable instruccion : std_logic_vector(15 downto 0) := "0000000000000000";
	begin
		instruccion(15 downto 8) := instr_input;
		instruccion(7 downto 0) := operando(7 downto 0);
		
		bus_pos <= pos;
		bus_ins <= instruccion;
		
		pos := pos + 1;
	end procedure;

	
	procedure guardar_dato(
		-- Señal a donde hay que mandar la posicion a cargar
		signal bus_pos: out natural;
		
		-- Señal a donde se va a manar el dato
		signal bus_ins: out std_logic_vector(15 downto 0);
		
		-- Posicion a donde escribir
		variable pos : inout natural;
		
		-- Operando que forma parte de la instruccion
		variable dato : std_logic_vector(15 downto 0)
	) is																	  
	begin
		
		bus_pos <= pos;
		bus_ins <= dato;
	end procedure;

--Señal que intercomunica el puerto de salida addres_in del micro con addres_out de la memoria.
	signal addres :STD_LOGIC_VECTOR(7 DOWNTO 0);	
-- Señales que intercomunica la testbench con la carga memoria 
	signal asinc_bus_pos:  natural; 	   
	signal asinc_bus_ins: std_logic_vector(15 downto 0);

-- Señal que conecta memory_data_out del micro con el memory_data_in de banco
	signal memory_data_micro_mem: STD_LOGIC_VECTOR(15 DOWNTO 0);	
-- Señal que conecta memory_data_in del micro con el memory_data_out del banco
	signal memory_data_mem_micro: STD_LOGIC_VECTOR(15 DOWNTO 0);
-- Señal de clock
	signal CLK: STD_logic;
-- Señal que conecta We del micro con We de banco de memoria
 	signal We : STd_logic;
--  Signal que conecta el Puerto reset de la memoria
	signal resetMem: Std_logic;
--  Signal que conecta el puerto reset del micro	
	signal resetMicro: Std_logic;

-- Signal para habilitar e inhabilitar el clock   	
	signal enable : std_logic := '0';   
	signal clock_aux : std_logic := '0';   		   
	
	
begin
	
	CLK <= clock_aux AND enable;
	
	MIC: microsencill port map(CLK,resetMicro,We,addres,open,open,
		memory_data_micro_mem,memory_data_mem_micro);
		 
	BC: bco_memoria port map( CLK, resetMem, We, addres,
		asinc_bus_pos,memory_data_mem_micro,memory_data_micro_mem, asinc_bus_ins
		) ;
	Clock(clock_aux , 20 ns, 20 ns);	
	
		
	STIMULUS: process
	
	variable op : std_logic_vector(7 downto 0) := "00001000";  
	variable dato : std_logic_vector(15 downto 0) := "0000001100000010"; 
								   
	
	--Variables para la interfaz gráfica
	variable linea : line;
  	file entrada : text is in "assembler";
	file salida : text is out "STD_OUTPUT";	 
	variable  Inst, parseOp, parseOpExtra: natural; 
	variable aux : natural;
	
	-- Variables usadas para cargar datos en memoria
	variable gpos : natural;   
	variable gdato : std_logic_vector(15 downto 0);
	
	-- Posicion a donde escribir, inicializada en 0
	variable pos : natural:=0;
		
	-- Operando que forma parte de la instruccion
	variable operando : std_logic_vector(7 downto 0);
		
	-- Codigo de operación a realizar
	variable instr_input : std_logic_vector(15 downto 8); 
		
	variable salir : boolean := true;
	
	begin	 
		
		resetMem <= '1';
		enable <= '0';
		asinc_bus_pos <= 2#11111111#;
		
		wait for 5 ns;
		
		while salir LOOP
			-- Lee la Instruccion
				write(linea, string'("Ingrese la operacion a realizar:"));
				writeline(salida, linea);  	
				write(linea, string'("1) ADD"));
				writeline(salida, linea);	
				write(linea, string'("2) STORE"));
				writeline(salida, linea);
				write(linea, string'("3) LOAD"));
				writeline(salida, linea);
				write(linea, string'("4) JUMP"));
				writeline(salida, linea);	
				write(linea, string'("5) SUB"));
				writeline(salida, linea);
				write(linea, string'("6) AND"));
				writeline(salida, linea);
				write(linea, string'("7) OR"));
				writeline(salida, linea);
				write(linea, string'("8) NOT"));
				writeline(salida, linea);
				write(linea, string'("9) JZ"));
				writeline(salida, linea);
				write(linea, string'("10) NOP"));
				writeline(salida, linea);
				write(linea, string'("11) CARGAR DATO"));
				writeline(salida, linea);
				write(linea, string'("12) LDR"));
				writeline(salida, linea);	
				write(linea, string'("0) EJECUTAR EL PROCESADOR"));
				writeline(salida, linea);
				
				--Se lee la instruccion a realizar
				readline(entrada, linea);
				read(linea, Inst);	
				
				-- Se limpia el buffer, no encontramos otra menera de hacerlo
				write(linea, string'("FLUSH LINE"));
	  			writeline(salida, linea);
				
				write(linea, Inst);	 
				writeline(salida, linea);  
				
				-- Se fija si la instruccion a cargar requiere parametro
				if ((Inst /= 0) AND (Inst /= 10)) AND (Inst /= 12) then
					
					if (Inst /= 11) then
						write(linea, string'("Ingrese operando a utilizar:"));
					else
						write(linea, string'("Ingrese la direccion de memoria donde guardar"));
					end	if;
					
					writeline(salida, linea);
					
					--Se lee el operando
					readline(entrada, linea);
					read(linea, parseOp);	
				   	
					-- Si la operacion es cargar dato, requiere dos parametros   
					if (Inst = 11) then
						readline(entrada, linea);
						read(linea, parseOpExtra);
					end if;
				end if;
				
	
				-- Con un case elige el codigo correspondiente segun la instruccion elegida
				CASE Inst IS
					WHEN 1 =>
						instr_input:="00000011";
						operando := convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 2 =>	 
						instr_input:="00000001";		
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 3 =>
						instr_input:="00000010";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 4 =>
						instr_input:="00000000";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 5 =>
						instr_input:="00000110";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 6 =>
						instr_input:="00000100";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 7 =>
						instr_input:="00001100";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 8 => 
						instr_input:="00001101";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 9 => 
						instr_input:="00000101";
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 10 => 
						instr_input:="00000111";
						operando:="00000000";
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 11 =>
						gpos := parseOp;		
						gdato:=convert(parseOpExtra,16);
						guardar_dato(asinc_bus_pos, asinc_bus_ins, gpos, gdato);
					
					WHEN 12 => 
						instr_input:="00001000";
						operando:="00000000";
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
					
					WHEN 0 => 
						instr_input:="10101010";
						parseOp := 0;
						operando:=convert(parseOp,8);
						Guardar_instr(asinc_bus_pos, asinc_bus_ins, pos , operando, instr_input);
						salir:=false;
					
					WHEN others=>   
				
				end CASE;
				
				wait for 1ns;
			end LOOP;							   
		
		wait for 1 ns;
		
		resetMicro <= '1' after 0ns, '0' after 5 ns;
		enable <= '1' after 10ns;
		
		wait;
	end process; 

			

end testbench;
