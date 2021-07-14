library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity actualizare_stari is
	port( clk_stare:IN BIT;						 --clock-ul automatului de stari care e de fapt clock-ul sistemului
	  s,sg1,sg2,sm1,sm2:in bit;					 --semnale pentru senzori
	  end15,end2:in bit;	 					 --carry ale numaratoarelor
	  CET15,CET2:out bit;						 --enable-uri ale numaratoarelor(in sensul case numararea poate sa inceapa)
	  RESET15,RESET2:OUT BIT;					 --reset-urile numaratoarelor
	  corect:in bit;		  					 --daca codul e corect se activeaza
	  SONERIE: out bit	 ;						 --se va activa cand soneria trebuie sa sune
	  plecat,acasa,inactiv: in bit);			 --semnale pentru cele 3 moduri
end actualizare_stari;	


architecture actualizare_stari of actualizare_stari is
  
  TYPE tip_stare IS (A, B, C, D, E, F, G, H); 	 --am definit un tip enumerat pentru stari
  SIGNAL stare_curenta : tip_stare :=A;	 		 --am declarat stare_curenta de acest tip ,starea A este starea initiala

  begin		
	  										   	 --in acest proces restartez numaratoarele,activez enable-urile,pornesc/opresc soneria,pentru ca toate acestea sa se faca in starea corespunzatoare lor,exact ca in organigrama
	  PROCESS(stare_curenta)					 --am pus stare_curenta in lista de sensibilitati pentru a reactiva procesul cand se schimba starea,pentru case automatul sa continue procesul
	  begin
		  	   case stare_curenta is
		  WHEN B =>								 --verific daca sunt in starea B(de selectare mod)
			RESET15 <= '1';						 --in aceasta stare resetez numaratoarele,opresc numararea si soneria
			RESET2 <= '1'; 						 
			CET2<='0';
			CET15<='0';
			SONERIE<='0'; 
		  
		WHEN F => 								 --starea F este cea in care incepe numararea de 2 minute,si suna alarma
			CET15<='0';
			RESET15<='1';
			RESET2<='0';			   					
			CET2 <='1';
			SONERIE <='1'; 	
		
		WHEN C =>  							    --in starea C se intarzie 15 sec dupa selectare mod plecat
			RESET15<='0'; 								
			CET15<='1';	
		
		WHEN G=>  								--in starea G resetez numaratorul si verific daca s-a activat oricare din cei 5 senzori (mod plecat)
			CET15<='0';
			RESET15<='1';
			CET2<='0';	
			RESET2<='1';			
			SONERIE<='0';
			
		WHEN H =>  							    --in starea H se intarzie 15 secunde pentru introducerea codului (mod plecat)
			RESET15<='0'; 								
			CET15<='1';	
	--	DACA SUNT IN STAREA E:MOD INACTIV,SE ASTEAPTA PANA SE INTRODUCE CODUL CORECT	
		WHEN OTHERS => NULL;
		end case;
		  end process;
	  
	  
	  											 --in acest proces fac doar trecerea de la o stare la alta
	PROCESS (clk_stare, corect) 
  BEGIN 		 
	  	IF corect='1' and clk_stare='1' and clk_stare'event and stare_curenta/=A then 		  --cazul pt care introducerea codului se face din orice alta stare
		  stare_curenta <= B;
		  
    	ELSIF clk_stare='1' and clk_stare'event THEN 			--doar pe frontul crescator se face trecerea dintr-o stare in alta
			
	CASE stare_curenta IS
 
																
		WHEN A => 								 				--daca starea curenta e cea initiala si s-a introdus corect codul,poate trece la starea de selectare mod,altfel asteapta pana se introduce corect
		if corect='1' then 						
				stare_curenta <= B; 	 
		end if;
  		------------------------------	
		WHEN B =>											   --fiecarui mod ii corespunde cate o stare:pt plecat-C,pt acasa-D,pt inactiv-E
			
		if plecat='1' then 
				stare_curenta<=C;	 
		elsif acasa='1' then
				 stare_curenta<=D;
		elsif inactiv='1' then 
			stare_curenta <=E;
		
		end if;
		-----------------------------------------
		WHEN D =>
		if  (s ='1' or sg1 ='1'or sg2 ='1')  then	 		  --daca sunt in modul acasa si s-a activat unul din cei 3 senzori,trec in starea urmatoare in care va suna soneria
			stare_curenta <=F;	 
			
		end if;
		-------------------------------------------
		WHEN F =>  											  --daca carry-ul numaratorului indica faptul ca au trecut 2 minute,trec in modul plecat,pentru a mentine securitatea casei 
		if  end2='1' then 
			stare_curenta <=G;
		end if;
		------------------------------------------
		
		WHEN C =>  											 --daca sunt in starea de intarziere 15 sec dupa selectare mod plecat si numaratorul a terminat de numarat,modific starea curenta,trecand la verificarea senzorilor in starea G
		if end15='1' then 	
			stare_curenta <= G;
		end if;
		-------------------------------------------
		
		WHEN G=>
		if (s ='1' or  sg1 ='1' or sg2='1' or sm1='1' or sm2='1')then	--daca se activeaza senzorii,trec in starea de intarziere 15 sec pentru introducerea codului de acces	   
			stare_curenta <=H;	
		end if;
		-------------------------------------------		
		WHEN H => 											--daca nu s-a introdus codul de acces,trec in starea in care pornesc alarma timp de 2 minute
		if end15='1' then
			stare_curenta<=F;
		end if;
		
		--	DACA SUNT IN STAREA E:MOD INACTIV,SE ASTEAPTA PANA SE INTRODUCE CODUL CORECT
			
			WHEN OTHERS => NULL;
		end case;	
		END IF;										
			
	end process;
  end actualizare_stari;