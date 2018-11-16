LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

package Utils_STD_LOGIC is
	procedure Clock(signal C: out STD_LOGIC; HT,LT: Time);
	
	function Convert(N,L:Natural) return STD_LOGIC_VECTOR;
	function Convert(B:STD_LOGIC_VECTOR) return Natural;

end Utils_STD_LOGIC;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

package body Utils_STD_LOGIC is
      procedure Clock(signal C: out STD_LOGIC; HT,LT: Time) is
      begin
	loop
		C <='1' after LT, '0' after LT + HT;
		wait for LT + HT;
	end loop;	 		
      end;
	
      function Convert(N,L:Natural) return STD_LOGIC_VECTOR is
	variable Temp: STD_LOGIC_VECTOR(L - 1 downto 0);				
	variable Value:Natural:= N;						
      begin
	for i in Temp'Right to Temp'Left loop
		Temp(i):=STD_LOGIC'Val((Value mod 2) + 2);
		Value:=Value / 2;
	end loop;
	return Temp;
      end;

      function Convert(B:STD_LOGIC_VECTOR) return Natural is
	variable Temp: STD_LOGIC_VECTOR(B'Length-1 downto 0):=B;				
	variable Value:Natural:= 0;						
      begin
	for i in Temp'Right to Temp'Left loop
		if Temp(i) = '1' then
			Value:=Value + (2**i);
		 end if;			
	end loop;
	return Value;
      end;

end Utils_STD_LOGIC;
