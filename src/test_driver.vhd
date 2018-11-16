entity testeandoOo is
	port (
	A : in bit;
	B : in bit_vector(1 downto 0);
	C : out bit_vector(1 downto 0)
	);
	
end;
	
architecture prueba of testeandoOo is
					
	begin
		P1: process (A)
		begin
			if (A'Event And A = '1') then
				Assert FALSE
					report "hola puto";
				C <= B XOR "01" after 5ns;	
			end if;
		end process;		  
	end;
