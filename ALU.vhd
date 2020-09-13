---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Miguel,José$^{1}$ Pérez, Otoniel$^{2}$Aguirre,Emiliano$^{2}$
-- Create Date:    11:22:33 04/05/2019 
-- Design Name: 
-- Module Name:    ALU_Secuencial - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Create
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

entity ALU_Secuencial is
    Port ( opcode : in  BIT_VECTOR (5 downto 0);
           A : in  BIT_VECTOR (7 downto 0);
           B : in  BIT_VECTOR (7 downto 0);
           CBin : in  bit;
           R : out  Signed (7 downto 0);
           STATUS : out  bit_vector(3 downto 0));
end ALU_Secuencial;

architecture Behavioral of ALU_Secuencial is
signal A_u,B_u: unsigned(7 downto 0):= (others => '0');
signal A_s,B_s: signed(7 downto 0):= (others => '0');
Signal R_s: signed(7 downto 0);
--signal add_s: signed (8 downto 0);
signal carryA: bit;

signal sAux: bit_vector(3 downto 0) := (others => '0');
begin

A_s<=signed(A);
A_u<=unsigned(A);
B_s<=signed(B);
B_u<=unsigned(B);


process(opcode,A_u,A_s,B_u,B_s,CBin,A,B)
	variable add_s: signed(8 downto 0);
	begin
		if opcode="000000" then
			add_s:=signed(('0'& A_u)+('0' & B_u));
			R_s<=add_s(7 downto 0);
			carryA<=add_s(8);
			elsif opcode="000001" then
				
				add_s:= ('0' & A_s ) + ('0' & B_s);
				R_s<= add_s(7 downto 0);
				carryA<=add_s(8);
			elsif opcode="000010" then
				add_s:=signed(('0'& A_u)-('0' & B_u));
				R_s<=add_s(7 downto 0);
				
				carryA<=add_s(8);
			elsif opcode="000011" then
				add_s:= ('0' & A_s ) - ('0' & B_s);
				R_s<= add_s(7 downto 0);
				carryA<=add_s(8);
			elsif opcode="000100" then
				if CBin = '1' then
					add_s:=signed(('0'&A_u) + ('0'&B_u) + 1);
				else 
					add_s:=signed(('0'&A_u) + ('0'&B_u) + 0);
				end if;
				R_s<=add_s(7 downto 0);
				carryA<=add_s(8);
			elsif opcode="000101" then
				if CBin = '1' then
					add_s:=(('0'&A_s) + ('0'&B_s) + 1);
				else 
					add_s:=(('0'&A_s) + ('0'&B_s) + 0);
				end if;
				R_s<=add_s(7 downto 0);
				carryA<=add_s(8);
			elsif opcode="000110" then
				if CBin = '1' then
					add_s:=signed(('0'&A_u) - ('0'&B_u) - 1);
				else 
					add_s:=signed(('0'&A_u) - ('0'&B_u) -0);
				end if;
				R_s<=add_s(7 downto 0);
				carryA<=add_s(8);
			elsif opcode="000111" then
				if CBin = '1' then
					add_s:=(('0'&A_s) - ('0'&B_s) - 0);
				else 
					add_s:=(('0'&A_s) - ('0'&B_s) - 1);
				end if;
				R_s<=add_s(7 downto 0);
				carryA<=add_s(8);
			elsif opcode="001000" then
				R_s<=signed(not A xor "00000001");
			elsif opcode="001001" then
				add_s:=signed(('0'&A_u) + 1);
				carryA<=add_s(8);
				R_s<=add_s(7 downto 0);
			elsif opcode="001010" then
				add_s:=signed(('0'&A_u) - 1);
				carryA<=add_s(8);
				R_s<=add_s(7 downto 0);
			elsif opcode="001011" then
				R_s<=signed(not B xor "00000001");
			elsif opcode="001100" then
				R_s<=B_s;
			elsif opcode="001101" then
				R_s<=A_s and B_s;
			elsif opcode="001110" then
				R_s<=A_s or B_s;
			elsif opcode="001111" then
				R_s<=A_s xor B_s;
			elsif opcode="010000" then
				R_s<= not B_s;
			elsif opcode="010001" or opcode="010010" then
				R_s<= signed(A(6 downto 0)&'0');
			elsif opcode="010011" then
				
				R_s<=signed(A(6 downto 0)& A(7));
			elsif opcode="010100" then

				R_s<=signed(A(6 downto 0) &CBin);
			elsif opcode="010101" or opcode="010110" then --Corrimientos de B a izq
				R_s<= signed(B(6 downto 0)&'0');
			elsif opcode="010111" then
				
				R_s<=signed(B(6 downto 0)& B(7));
			elsif opcode="011000" then

				R_s<=signed(B(6 downto 0) &CBin);
			elsif opcode="100001" then --Opcode aritmeticas restantes
				add_s:=('0'&B_s) + 1;
				carryA<=add_s(8);
				R_s<=add_s(7 downto 0);
			elsif opcode="100010" then
				add_s:=('0'&B_s) - 1;
				carryA<=add_s(8);
				R_s<=add_s(7 downto 0);
			elsif opcode="100011" then
				R_s<=signed(not A);
			elsif opcode="011001" then      --Corrimientos A a la derecha
				R_s<=signed('0'& A(7 downto 1));
			elsif opcode="011010" then
				
				R_s<=signed(A(7) & A(7 downto 1));
			elsif opcode="011011" then 
				
				R_s<=signed(A(0) & A(7 downto 1)); -- rotacion a la dercha de A
			elsif opcode="011100" then
				R_s<=signed(CBin & A(7 downto 1));
			
			elsif opcode="011101" then      --Corrimientos B a la derecha
				R_s<=signed('0'& B(7 downto 1));
			elsif opcode="011110" then
			
				R_s<=signed(B(7) & B(7 downto 1));
			elsif opcode="011111" then 
				
				R_s<=signed(B(0) & B(7 downto 1)); -- rotacion a la dercha de B
			elsif opcode="100000" then
				R_s<=signed(CBin & B(7 downto 1));
				
			--corriiento a la dercha de B
			else 
				R_s<=A_s;
			
		end if;
			
	end process;
	
	process(R_s,opcode,carryA,A,B)	
	begin
		if opcode = "000000" or opcode = "000100" or opcode = "000110" or opcode = "001001" or opcode = "001010" or opcode = "100001" or opcode = "100010"then
			sAux(0)<=carryA;
			sAux(1)<='0';--(not A(7) and(not B(7))and(R_s(7))) or (A(7)and(B(7))and(not R_s(7)));
			sAux(2)<='0';
			elsif opcode = "000001"  or opcode = "000101" or opcode = "000111"then
				sAux(0)<=carryA;
				sAux(1)<=(not A(7) and(not B(7))and(R_s(7))) or (A(7)and(B(7))and(not R_s(7)));
				sAux(2)<=R_s(7);
			elsif opcode = "000010" then
				sAux(0)<=carryA;
				sAux(1)<='0';--(not A(7) and(not B(7))and(R_s(7))) or (A(7)and(B(7))and(not R_s(7)));
				sAux(2)<='0';
			elsif opcode = "000011" then
				sAux(0)<=carryA;
				sAux(1)<=(not A(7) and(not B(7))and(R_s(7))) or (A(7)and(B(7))and(not R_s(7)));
				sAux(2)<=R_s(7);
		else sAux<="0000";
		end if;
		sAux(3)<=R_s(7)xor R_s(6) xor R_s(5) xor R_s(4) xor R_s(3) xor R_s(2) xor R_s(1) xor R_s(0);
	end process;
	
	R<=R_s;
	STATUS<=sAux;
end Behavioral;

