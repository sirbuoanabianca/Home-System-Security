library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL ;
--NUMARATOR 120 SECUNDE	(2 minute):numararea incepe de la 0 pana la 120,dar cand ajunge la 120 carry-ul se activeaza,sugerand ca au trecut 120 secunde
entity counter2 is
		port(cet2,reset2,clk2:in bit;						   --clk2:enable numarator,reset2:resetare numarator,clk2:clock numarator
		END2: out bit);										   --END2:carry numarator
end counter2;



architecture counter_2min of counter2 is	
signal count :std_logic_vector(6 downto 0):="0000000";			--cu ajutorul lui count numar secundele

begin			  
	
	PROCESS (count)												--am folosit 2 procese pentru ca carry-ul numaratorului sa se activeze exact cand count ajunge la 120
	begin
		if	count = "1111000"  then 	   						--cand ajunge la 120,carry-ul se activeaza
			END2<='1';
		else													--in rest,carry-ul este 0
			END2<='0';
			end if;
	end process;
	
	
		 	   	
		COUNTER2:process (clk2,reset2,cet2)	   				   	--toate intrarile sunt in lista de sensibilitati pentru a reactiva procesul
	begin			   
						if reset2 ='1' then 					--reset-ul are prioritate
					 		count <= "0000000";    
	
				 	elsif cet2  ='1'and clk2 ='1' and clk2'event then 
						 
					 		count <= count+'1';				   --altfel, daca clock e pe frontul crescator incrementez count
							
				 		end if; 
	end process COUNTER2;
				
end counter_2min;