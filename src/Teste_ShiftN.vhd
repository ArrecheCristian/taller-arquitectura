entity Test_ShiftN is end; 
architecture Driver of Test_ShiftN is
  component ShiftN
    port (CLK: in  Bit;  CLR: in  Bit; LD: in  Bit;
          SH: in  Bit;  DIR: in  Bit;
          D: in Bit_Vector; Q: out  Bit_Vector);
  end component;
  signal CLK, CLR, LD, SH, DIR: Bit;
  signal D: Bit_Vector(1 to 4 );
  signal Q: Bit_Vector(8 downto 1);
begin
  UUT: ShiftN port map (CLK, CLR, LD, SH, DIR, D, Q);
  Stimulus: process
     begin  
        CLR <= '1', '0' after 10ns;                 -- Limpia el registro
            wait for 10ns;

            D <= "0001";                                -- Carga el registro
            LD <= '1', '0' after 10ns;
            CLK <= '0', '1' after 3ns;
            wait for 10ns;

            SH <= '1';     	 -- Desplaza a la izquierda el patrón de bits
            DIR <= '1';
            CLK <= '0';
            wait for 3ns;
            
			for i in 1 to 8 loop
                CLK <= '1' after 3ns, '0' after 6ns;    -- Ciclo de reloj
                wait for 6 ns;
            end loop;
			
            wait;

     end process;
end;

