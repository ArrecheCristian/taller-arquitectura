entity NOR8 is
	
	-- 8 entradas, 1 salida
	port (	input: in bit_vector(7 downto 0);
			output: out bit
		);
	
end NOR8;
	
architecture proc of NOR8 is
begin

	-- Compara todas las entradas
	output <= (NOT (input(0) OR input(1) OR input(2) OR input(3) OR input(4) OR input(5) OR input(6) OR input(7))); 
	
end;