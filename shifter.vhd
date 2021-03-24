----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 07:15:32 PM
-- Design Name: 
-- Module Name: shifter - structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shifter is
    generic( n: integer := 8);
     
    Port ( a       : in std_logic_vector(n-1 downto 0);
           b       : in STD_LOGIC_vector(n-1 downto 0);
           control : in STD_LOGIC_VECTOR (1 downto 0);
           output  : out STD_LOGIC_VECTOR (n-1  downto 0));
end shifter;


architecture structural of shifter is
    -- ceil (log2(n)
    constant amt : integer := integer(ceil(log2(real(n))));
    
    -- output at each stage. first input is a
    type arr_amt is array(0 to amt) of std_logic_vector(n-1 downto 0);
    signal a_arr : arr_amt;

begin
    a_arr(0) <= a;
    
    -- generate shift by 1,2,4, ...., amt
    shift_by_m_gen  : for i in 0 to amt-1 generate
    shift_by_m_inst : entity work.shift_by_m(dataflow)
    generic map(
                n => n,
                m => 2**i
                )
    port map(
            a   => a_arr(i),
        shift   => b(i),
        control => control,
        output  => a_arr(i+1));
        
        end generate;
        
        output <= a_arr(amt);        
  
end structural;
