use work.Utils.all;

entity testbench is
	
end testbench;

architecture Test of testbench is

	-- Declaracion del Multiplicador
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
	signal CLK, STB, Done : bit;
begin
	
	-- Declaracion del multiplicador
	MUL: Simple_Multiplier port map (A, B, CLK, STB, Done, Result);
	
	Clock(CLK, 10 ns, 10 ns);
	
	-- Prueba por fuerza bruta todas las combinaciones
	Test: process
	
	variable i,j:NATURAL;
	begin
		STB <= '0';
		
		wait for 15ns;
		
		for i in 0 to 15 loop
			for j in 0 to 15 loop
				
				-- Pone los valores a probar en las entradas
				A <= Convert(i, A'length);
				B <= Convert(j, B'Length);
							
				-- Envia el pulso de inicio
				STB <= '1', '0' after 21ns;
				
				-- Espera hasta que termine de multiplicar
				wait until Done'Event and Done = '1';
				
				-- Informa el resultado
				assert ((i * j) = convert(result)) 
				report "ERROR EN LA SUMA"
				severity FAILURE;				
			end loop;
		end loop;
		
		assert false report "Finalizado con exito";
		wait;
	end process;
end;
