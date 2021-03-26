----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 06:33:15 PM
-- Design Name: 
-- Module Name: shift_by_m - dataflow
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

entity shift_by_m is
    generic (
              n : integer := 8;
              m : integer := 2); -- # of bits to shift
              
    Port ( a : in std_logic_vector(n-1 downto 0);
           shift : in STD_LOGIC; -- shift or don't shift
           control : in STD_LOGIC_VECTOR (1 downto 0);
           output : out std_logic_vector(n-1 downto 0));
end shift_by_m;

architecture dataflow of shift_by_m is
    signal shift_control : std_logic_vector(2 downto 0);
    signal out_sll : std_logic_vector(n-1 downto 0);
    signal out_srl : std_logic_vector(n-1 downto 0);
    signal out_sra : std_logic_vector(n-1 downto 0);
    
begin
    shift_control <= shift & control;
    
    out_sll(n-1 downto m) <= a(n-m-1 downto 0);
    out_sll(m-1 downto 0) <= (others => '0');
    
    out_srl(n-1-m downto 0) <= a(n-1 downto m);
    out_srl(n-1 downto n-m) <= (others => '0');
    
    out_sra(n-m-1 downto 0) <= a(n-1 downto m);
    out_sra(n-1 downto n-m) <= (others => a(n-1)); 


    with shift_control select
    output <=
    out_sll when "100",
    
    out_srl when "101",
    
    out_sra when "110",
    a  when     others;
    
end dataflow;
