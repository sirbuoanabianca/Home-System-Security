 library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_unsigned.ALL ;
--NUMARATOR 15 SECUNDE	:numararea incepe de la 0 pana la 15,dar cand ajunge la 15 carry-ul se activeaza,sugerand ca au trecut 15 secunde
entity counter15 is
		port(cet15,reset15,clk15:in bit;						--clk15:enable numarator,reset15:resetare numarator,clk15:clock numarator
		END15: out bit);									    --END15:carry numarator
end counter15;

architecture counter_15 of counter15 is	
signal count :std_logic_vector(3 downto 0):="0000" ;			--cu ajutorul lui count numar secundele

begin			  												 
	
	
	PROCESS (count)												--am folosit 2 procese pentru ca carry-ul numaratorului sa se activeze exact cand count ajunge la 15
	begin
		if	count = "1111"  then 	  						 	--cand ajunge la 15,carry-ul se activeaza
			END15<='1';
		else
			END15<='0';										 	--in rest,carry-ul este 0
			end if;
	end process;
	
		 	 
		COUNTER1:process (clk15,reset15,cet15)	   				--toate intrarile sunt in lista de sensibilitati pentru a reactiva procesul
	begin			   
	
						if reset15 ='1' then 				  	--reset-ul are prioritate
					 		count <= "0000";    	
	
				 	elsif cet15  ='1'and clk15 ='1' and clk15'event then 	--altfel, daca clock e pe frontul crescator incrementez count
						 
					 		count <= count+'1';	
				 		end if; 
				 
	end process COUNTER1;
				
end counter_15;