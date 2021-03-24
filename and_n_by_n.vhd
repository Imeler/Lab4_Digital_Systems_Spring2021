-- File:carry_save_mult.vhd—
 -- Entity:carry_save_mult
-- Architecture:structural
-- Author:
 -- Created:
 -- Modified:
-- VHDL'93-- Description:   The following is the entity and
--architectural description of
--ANDing every possible permutation
--          of n by n bits-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity and_n_by_n is 
   generic ( n : integer := 8);  
  port(        a   : in std_logic_vector(n-1 downto 0);  
      b   : in std_logic_vector(n-1 downto 0);     
   res : out std_logic_vector(n*n-1 downto 0));
end and_n_by_n;
architecture dataflow of and_n_by_n is
begin 
   arr_gen: for i in 0 to n-1 generate   
     arr_gen2: for j in 0 to n-1 generate 
           res(n*i+j) <= a(j) and b(i);  
      end generate;  
  end generate;
end dataflow;
