entity test_driver_test is begin end;
	
architecture prueba of test_driver_test is
component testeandoOo 
	port (A: in bit; B: in bit_vector(1 downto 0); C: out bit_vector(1 downto 0)); 
end component;
	
	signal Aa : bit;
	signal Bb, Cc : bit_vector(1 downto 0);
	
	begin
		UUT: testeandoOo port map (Aa, Bb, Cc);
		Aa <= '0', '1' after 10ns, '0' after 12ns, '1' after 14 ns, '0' after 16ns, '1' after 18ns;
	end;
	