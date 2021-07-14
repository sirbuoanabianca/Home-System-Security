library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL ;

entity introducere_cod is
	port(
	keypad:in bit_vector (0 to 6);		   --keypad: tastatura matriciala,are 7 biti, deoarece are 4 linii si 3 coloane
	clk_cod:in bit;						   --clk_cod:clock-ul componentei
	BEC_VERDE,BEC_ROSU: out bit;		   --becurile sunt semnale care se activeaza daca codul e corect(verde) sau gresit(rosu)
	CORECT:out bit);					   --semnal care indica daca codul introdus e corect sau gresit
end introducere_cod; 



architecture introducere_cod of introducere_cod is  
  
  signal button : bit_vector(0 to 6) := (others=>'0'); 	-- are rolul de a diferentia daca a fost apasata alta tasta sau e apasata în continuare tasta anterioara.
  signal i : integer  range 0 to 5 :=0;				    -- index care indica pozitia pe care trebuie plasata cifra
  
  begin	  
	  
	 	 password: process (button,keypad,i,clk_cod)
	  
	  type integer_vector is array (0 to 3) of integer;	 --am definit un vector de intregi
	  variable passcode :integer_vector :=(0,0,0,0);	
	  constant passoriginal :integer_vector :=(2,5,3,6); --passoriginal este codul original si de aceea este constanta
	 
	  
	  begin  
		  if clk_cod'event and clk_cod='1' then
		  	 if i< 4 then   							 --verific daca mai am cifre de introdus.Daca deja s-au introdus 4 cifre,procesul s-a incheiat
				   CORECT<='0';	 
				   BEC_VERDE<='0';						 --semnalele bec iau valoarea 0 pentru a se activa doar dupa introducerea celor 4 cifre si ca sa ramana active doar pentru un impuls de tact
				   BEC_ROSU<='0';
				   if button /= keypad	then 			 --verific daca s-a apasat o noua tasta
					   case button is
						   when "1000100" =>			 --daca s-a apasat tasta 1 careia ii corespunde codificarea respectiva,se plaseaza cifra in registru si indic ca pot trece la pozitia urmatoare
						   passcode(i):=1;
						   i<=i+1;
						   
						   when "1000010" =>
						   passcode(i):=2;
						   i<=i+1;
						   
						   when "1000001" =>
						   passcode(i):=3;
						   i<=i+1;
						   
						   when "0100100" =>
						   passcode(i):=4;
						   i<=i+1;
						   
						   when "0100010" =>
						   passcode(i):=5;
						   i<=i+1;
						   
						   when "0100001" =>
						   passcode(i):=6;
						   i<=i+1;
						   
						   when "0010100" =>
						   passcode(i):=7;
						   i<=i+1; 
						   
						   when "0010010" =>
						   passcode(i):=8;
						   i<=i+1;	  
						   
						   when "0010001" =>
						   passcode(i):=9;
						   i<=i+1;
						   
						   when "0001010" => 
						   passcode(i):=0;
						   i<=i+1;
						   
						   when others => null;		   --codificarea corespunzatoare pentru faptul ca inca nu s-a apasat nicio cifra este "0000000"
					   end case;
					   button <= keypad;			   --ii atribui valoarea cifrei introduse pentru ca la verificarea urmatoare sa se tina cont de faptul ca s-a apasat o noua tasta(chiar daca e aceeasi ca anterioara)
				   	  end if;
			   else
				   if passcode = passoriginal then 	   --compar daca codul introdus este codul de acces
					   CORECT <= '1'; 				   
					   BEC_VERDE<='1';
				   else 
					   CORECT <= '0';  
					   BEC_ROSU<='1';
				   
				   	   end if;
				   
				   	  	 i <= 0;					   --reinitializez indexul,pregatesc registrul pentru urmatoarea data in care se va introduce codul
						 passcode :=(0,0,0,0);
				   end if;
		  
		  	 end if;
		  end process password;
		  end introducere_cod;