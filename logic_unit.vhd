----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 05:24:40 PM
-- Design Name: 
-- Module Name: logic_unit - dataflow
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic_unit is
generic( n : integer := 8);
    Port ( a : in std_logic_vector(n-1 downto 0);
           b : in std_logic_vector(n-1 downto 0);
     control : in std_logic_vector(1 downto 0);
      output : out std_logic_vector(n-1 downto 0));
end logic_unit;

architecture dataflow of logic_unit is
    signal or_out  : std_logic_vector(n-1 downto 0);
    signal not_out : std_logic_vector(n-1 downto 0);
    signal and_out : std_logic_vector(n-1 downto 0);
    signal xor_out : std_logic_vector(n-1 downto 0);
begin
    or_out <= a or b;
   not_out <= not a;
   and_out <= a and b;
   xor_out <= a xor b;

   with control select
      output <= 
            or_out when "00",
            not_out when "01",
            and_out when "10",
            xor_out when others;

end dataflow;
