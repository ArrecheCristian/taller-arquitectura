use work.Utils.all;
use std.textio.all;

entity testbenchIO is 
end testbenchIO;

architecture Test of testbenchIO is
	-- Declaración del Multiplicador
	component Simple_Multiplier
		port (
			A, B: in bit_vector (3 downto 0); -- Entradas a multiplicar
			CLK, STB: in bit;
			Done: out bit;
			Result: out bit_vector (7 downto 0)
		);	
		end component;
	
	signal A, B: bit_vector (3 downto 0);
	signal Result: bit_vector (7 downto 0);
	signal CLK, STB, Done: bit;
	signal texto: string(1 to 25);
	
begin
	-- Declaración del multiplicador
	MUL: Simple_Multiplier port map (A, B, CLK, STB, Done, Result);
	Clock(CLK, 10 ns, 10 ns);

	leer: process
  		variable linea : line;
  		file entrada : text is in "STD_INPUT";
		file salida : text is out "STD_OUTPUT";
		variable datoA, datoB: integer;
		variable aux : integer;
	
	begin
		write(linea, string'("INGRESE LOS VALORES DE A Y B"));
		writeline(salida, linea);
		
		-- Lee las dos variables
		readline(entrada, linea);
		read(linea, datoA);
		readline(entrada, linea);
		read(linea, datoB);
		
		-- Crashea si los números son mayores a 15, que es lo máximo
		--representable con 4 bits sin signo
		ASSERT (datoA <= 15) AND (datoB <= 15) 
			report "NUMEROS MUY GRANDES. MAXIMO 15" 
		severity FAILURE; 
		
		A <= Convert(datoA, A'length);
		B <= Convert(datoB, B'length);
		
		-- Envía el pulso de inicio
		STB <= '1' after 5ns, '0' after 30ns;
		wait for 30ns;
		wait until Done'Event and Done = '1';
		
		-- Se limpia el buffer, no encontramos otra manera de hacerlo
		write(linea, string'("FLUSH LINE"));
  		writeline(salida, linea);
		write(linea, string'("El resultado de la multiplicacion es:"));
  		writeline(salida, linea); 
		
		-- Imprime los resultados
		write(linea, convert(Result));
  		writeline(salida, linea);
  		wait;
	end process leer;
end;
