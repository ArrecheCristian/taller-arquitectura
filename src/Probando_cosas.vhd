LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.Utils_STD_LOGIC.all;
use std.textio.all;

entity Probando_cosas is end Probando_cosas;

architecture Test of Probando_cosas is
	
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

	-- Señal a donde hay que mandar la posicion a cargar
		signal bus_pos: natural;
		
	-- Señal a donde se va a manar el dato
	signal bus_ins: std_logic_vector(15 downto 0);
	
	begin
	
	
	leer: process
  		variable linea : line;
  		file entrada : text is in "STD_INPUT";
		file salida : text is out "STD_OUTPUT";
		variable Inst, Op: integer;
		variable aux : integer;
		-- Posicion a donde escribir, inicializada en 0
		variable pos : natural:=0;
		
		-- Operando que forma parte de la instruccion
		variable operando : std_logic_vector(7 downto 0);
		
		-- Codigo de operación a realizar
		variable instr_input : std_logic_vector(15 downto 8); 
		
		variable salir : boolean := true;
		
		begin
		
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
				write(linea, string'("11) EJECUTAR EL PROCESADOR"));
				writeline(salida, linea);
				
				--Se lee la instruccion a realizar
				readline(entrada, linea);
				read(linea, Inst);	
				
				-- Se limpia el buffer, no encontramos otra menera de hacerlo
				write(linea, string'("FLUSH LINE"));
	  			writeline(salida, linea);
				
				write(linea, Inst);	 
				writeline(salida, linea);  
				
				
				if (Inst /= 11) then
					write(linea, string'("Ingrese el operando a utilizar:"));
					writeline(salida, linea);
					--Se lee la instruccion a realizar
					readline(entrada, linea);
					read(linea, Op);	
				
					-- Se limpia el buffer, no encontramos otra menera de hacerlo
					write(linea, string'("FLUSH LINE"));
	  				writeline(salida, linea);
					
					write(linea, Op);	 
					writeline(salida, linea); 
				end if;
				
				
				
				
				CASE Inst IS
				-- dependiendo del estado hacemos una u otra operación, reset_pc me pone los registros a 0
					WHEN 1 =>
						instr_input:="00000011";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 2 =>	 
						instr_input:="00000001";		
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 3 =>
						instr_input:="00000010";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 4 =>
						instr_input:="00000000";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 5 =>
						instr_input:="00000110";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 6 =>
						instr_input:="00000100";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 7 =>
						instr_input:="00001100";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 8 => 
						instr_input:="00001101";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 9 => 
						instr_input:="00000101";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 10 => 
						instr_input:="00000111";
						operando:=convert(Op,8);
						Guardar_instr(bus_pos, bus_ins, pos , operando, instr_input);
					WHEN 11=>	   
						salir:=false;
					WHEN others=>   
				end CASE;  
			end LOOP;
			
			
			
			
			
			wait;	
	end process leer;
end;	