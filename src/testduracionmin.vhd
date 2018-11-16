use work.Utils.all;

entity testduracionmin is
	
end testduracionmin;

architecture Test of testduracionmin is

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
	
	
	velocidad: process
	variable i,j: natural;
	begin		   
		
		-- El tiempo minimo sera cuando A es 0
		A <= Convert(0, A'length);
		B <= Convert(0, B'length);
		
		STB <= '1' after 5ns, '0' after 30ns;
		
		
		wait;
	end process;
end;
