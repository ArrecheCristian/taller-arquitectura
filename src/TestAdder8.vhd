entity Test_Adder8 is end;  
architecture Driver of Test_Adder8 is           component Adder8
            port (A, B: in Bit_Vector(7 downto 0); Cin: in Bit; Cout: out Bit; Sum: out Bit_Vector(7 downto 0));
          end component;
          signal A, B, Sum: Bit_Vector(7 downto 0);
          signal Cin, Cout: Bit := '0';
begin
         UUT: Adder8 port map (A, B, Cin, Cout, Sum);
    Stimulus: process
		variable Temp: Bit_Vector(7 downto 0);
		
		function bit_integer(v : in bit) return integer is
		begin			
			if v = '1' then
				return 1;
			else
				return 0;
			end if;
		end bit_integer;
		
		function bitv_integer(v: in bit_vector(7 downto 0)) return integer is
		variable aux : integer;
		begin
			aux := 0;
			for i in 0 to 7 loop
				aux := aux + bit_integer(v(i)) * (2 ** i);
			end loop;
			return aux;
		end bitv_integer;
		
            begin
                Temp := "00000000";
                for i in 1 to 32 loop
                  if i mod 2 /= 1 then
                    A <= Temp; B <= "00000001";
                  else
                    B <= Temp; A <= "00000001";
                  end if;
                  wait for 1 ns;   
				  assert (bitv_integer(A) + bitv_integer(B) /= bitv_integer(Sum))
				  report "Resultado = " & integer'image(bitv_integer(A) + bitv_integer(B));
                  Temp := Sum;
                end loop;
                wait; -- to terminate simulation
            end process;
end;
