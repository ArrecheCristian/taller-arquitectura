entity Simple_Multiplier is
   port (A: in Bit_Vector(3 downto 0);B: in Bit_Vector(3 downto 0); CLK: in Bit; STB: in Bit; Done: out Bit; Result: out Bit_Vector(7 downto 0));
end Simple_Multiplier;

architecture Estructural of Simple_Multiplier is
	--Definici�n de componentes a utilizar en la arquitectura
   component ShiftN
    	port (CLK: in  Bit;  CLR: in  Bit; LD: in  Bit; SH: in  Bit;  DIR: in  Bit; D: in Bit_Vector; Q: out  Bit_Vector);
   end component;
   
   component Adder8
		port (A, B: in Bit_Vector(7 downto 0); Cin: in Bit; Cout: out Bit; Sum: out Bit_Vector(7 downto 0));
   end component;
   
   component Controller
		port (STB, CLK, LSB, Stop: in Bit; Init, Shift, Add, Done: out Bit);
   end component;
   
   component NOR8
	   port (input: in bit_vector(7 downto 0); output: out bit);
   end component;
   
   --Se�ales utilizadas internamente por el multiplicador
   
   signal High: Bit:='1';
   signal Low: Bit:='0';
   
   		--Se�ales relacionadas con la maquina de estados
   		signal Shift: Bit; --Conectada con la entrada SHIFT de los registros Alpha y Betta, si est� en 1 produce un desplazamiento
  		signal Init: Bit; --Conectada al CLR del Acumulador, y al LD de los registros Alpha y Betta, sirve para reiniciar el multiplicador
   		signal Add: Bit; --Conectada a la entrada LD del Acumulador, le indica que cargue el siguiente valor
		signal Stop: Bit; --Conectada a la salida de la NOR 
   	
		--Se�ales relacionadas con los registros de desplazamiento
			--Se�ales relacionadas con el registro de desplazamiento A 
			signal ResA: Bit_Vector(7 downto 0); --Resultado del registro A
			
			--Se�ales relacionadas con el registro de desplazamiento B
			signal ResB: Bit_Vector(7 downto 0); --Resultado del registro B
			
		--Se�ales relacionadas con el Adder
			signal Sum: Bit_Vector(7 downto 0); --Resultado del adder
			signal Realimentacion: Bit_Vector(7 downto 0); --Primera entrada del adder, que sale del Acumulador ACC
			
	begin	
		
		--NOR que conecta la salida de el registro B con la se�al Stop de la maquina de estados
		NotOR: NOR8 port map (ResA,Stop); 
		
		--Maquina de estados, toma el bit menos significativo de la salida del registro A
		FSM: Controller port map (STB, CLK, ResA(0), Stop, Init, Shift, Add, Done);
		
		--Registro de desplazamiento A, se le puso ese nombre ya que SRA es una palabra reservada de Active-HDL, CLR y DIR en bajo
		SRAlpha: ShiftN port map (CLK, low, Init, Shift,  Low, A, ResA);
		
		--Registro de desplazamiento B, CLR en bajo y DIR en alto
		SRBetta: ShiftN port map (CLK, low, Init, Shift, High, B, ResB);
		
		--Sumador de 8 bits, el cual va a sumar la salida del registro B con la realimentacion del registro ACC
		Adder: Adder8 port map (Realimentacion, ResB, Low, Open, Sum);
		
		--Acumulador de 8 bits
		ACC: ShiftN port map (CLK, Init, Add, Low,  Low, Sum, Realimentacion);
		Result <= Realimentacion;
	end;