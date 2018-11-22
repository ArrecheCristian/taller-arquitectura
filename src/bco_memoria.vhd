LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.Utils_STD_LOGIC.all;

ENTITY bco_memoria IS
	port(clock, reset, we : 	IN STD_LOGIC;
 	address_in : 	IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	 asinc_bus_pos: IN natural;
 	memory_data_output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
 	memory_data_input:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	asinc_bus_ins : IN std_logic_vector(15 downto 0) );	
END	bco_memoria;			  			

ARCHITECTURE principal OF bco_memoria IS
	TYPE celda_memoria IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL vector_celdas :celda_memoria;	   
		
	BEGIN
		
		process
		variable temp :Natural;
		begin
			if reset'EVENT and reset='1' then
				for i in 0 to 255 loop
					vector_celdas(i)<="0000011100000000";
				end loop;
			end if;
			if clock'EVENT and clock='0' then  
				temp:=convert(address_in);
				if we='1' then
					vector_celdas(temp)<= memory_data_input;
				elsif we='0' then
					memory_data_output <= vector_celdas(temp);
				end if;
			elsif asinc_bus_pos'EVENT then 
				vector_celdas(asinc_bus_pos)<= asinc_bus_ins;
			end if;
			wait until (clock'EVENT or asinc_bus_pos'EVENT);
		end process; 
	
END	principal;													  