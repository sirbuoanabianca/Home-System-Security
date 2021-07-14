library IEEE;	
library proiect_final_cu_librarii;
use proiect_final_cu_librarii.all;
use IEEE.STD_LOGIC_1164.ALL;	
 --chiar daca vhdl este case insensitive,am folosit denumiri cu majuscule si minuscule doar pentru a evidentia care semnale trebuie mapate :cele cu minuscule
entity safehouse is
	port( 
	KEYPAD:in bit_vector (0 to 6);			 --keypad: tastatura matriciala,are 7 biti, deoarece are 4 linii si 3 coloane
	S,SG1,SG2,SM1,SM2:in bit;				 --semnale pentru senzori
	PLECAT,INACTIV,ACASA:in bit;			 --semnale pentru cele 3 moduri
	SONERIE:out bit;						 --se va activa cand sonerie trebuie sa sune
	BEC_VERDE,BEC_ROSU:out bit);		 	 --becurile sunt semnale care se activeaza daca codul e corect(verde) sau gresit(rosu)
end safehouse;	 


architecture security_system of safehouse is  
	--COMPONENTE:
  component actualizare_stari 				 
	port(clk_stare :IN BIT;					 --clock-ul automatului de stari care e de fapt clock-ul sistemului
	  s,sg1,sg2,sm1,sm2:in bit;				 --semnale pentru senzori
	  end15,end2:in bit;	 				 --carry ale numaratoarelor
	  CET15,CET2:out bit;					 --enable-uri numaratoare
	  RESET15,RESET2:OUT BIT;				 --reset-uri numaratoare
	  corect:in bit;		   				 --semnal pentru validitatea codului introdus
	  SONERIE : out bit;					 --se va activa cand soneria trebuie sa sune
	  plecat,acasa,inactiv: in bit);		 --semnale pentru cele 3 moduri
 end component;
 
 
 component counter15 
		port(cet15,reset15,clk15:in bit;	--enable,reset,clock pentru numarator 15 secunde
		END15: out bit);
end component ;
		
		
component  counter2 
		port(cet2,reset2,clk2:in bit;		--enable,reset,clock pentru numarator 120 secunde
		END2: out bit);
end component ;
		

component  introducere_cod 
	port(
	keypad:in bit_vector (0 to 6);		   --keypad: tastatura matriciala,are 7 biti, deoarece are 4 linii si 3 coloane
	clk_cod:in bit;						   --clock-ul sistemului
	BEC_VERDE,BEC_ROSU:out bit;			   --becurile sunt semnale care se activeaza daca codul e corect(verde) sau gresit(rosu)
	CORECT:out bit);					   --semnal care indica daca codul introdus e corect sau gresit																												
end component ;
------------------------------------------ 
--SEMNALE INTERNE:						   
signal CLK,CLK_1HZ:bit;					   								 --CLK:clock pentru intregul sistem de 10 Mhz,CLK_1HZ:clock pentru numaratoare de 1 Hz
signal send15,send2,sclk_stare,scorect,scet2,scet15,sreset15,sreset2:bit;--send15:semnal care leaga iesirea lui counter15 de intrarea in componenta actualizare stari
																		 --send2:semnal care leaga iesirea lui counter2 de intrarea in componenta actualizare stari
 	   begin														  	 --sclk_stare:semnal care leaga clock-ul sistemului de intrarea clk_stare in actualizare_stari
																		 --scorect:semnal care leaga iesirea componentei de introducere_cod de intrarea in actualizare_stari
																		 --scet15,scet2,sreset15,sreset2:semnale care leaga iesirile din actualizare stari de intrarile numaratoarelor(componenta de stari decide functionarea/resetarea nuamaratorului)													
C1:	actualizare_stari port map (SONERIE=>SONERIE,clk_stare=>CLK,s=>S,sg1=>SG1,sg2=>SG2,sm1=>SM1,sm2=>SM2,end15=>send15,end2=>send2,plecat=>PLECAT,acasa=>ACASA,inactiv=>INACTIV,CET2=>scet2,CET15=>scet15,RESET15=>sreset15,RESET2=>sreset2,corect=>scorect);
C2:	counter15 port map (cet15=>scet15,reset15=>sreset15,clk15 =>CLK_1HZ,END15=>send15);
C3:	counter2 port map (cet2=>scet2,reset2=>sreset2,clk2=> CLK_1HZ,END2=>send2);
C4:	introducere_cod port map (keypad=>KEYPAD,clk_cod=>CLK,CORECT=>scorect,BEC_VERDE=>BEC_VERDE,BEC_ROSU=>BEC_ROSU);

end security_system;
