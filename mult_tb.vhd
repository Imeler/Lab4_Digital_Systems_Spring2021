----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2021 01:15:44 AM
-- Design Name: 
-- Module Name: mult_tb - Behavioral
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
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mult_tb is
--  Port ( );
end mult_tb;

architecture Behavioral of mult_tb is

    file f_MULT : text OPEN READ_MODE is "../../../mult8X8.txt";
    
    constant WAIT_TIME : time := 100ns;
    
    signal a         : std_logic_vector(15 downto 0);
    signal b         : std_logic_vector(15 downto 0);
    signal product   : std_logic_vector(15 downto 0);
    
begin
    a(15 downto 8) <= (others => '0');
    b(15 downto 8) <= (others => '0');
    
    mult_inst : entity work.carry_save_mult (structural)
    generic map ( n=> 16)
    port map(
        a    => a,
        b    => b,
  product    => product
    );
    
    tb : process
    
        variable v_line      :   line;
        variable v_space     :  character;
        variable v_a         :  std_logic_vector(7 downto 0);
        variable v_b         :  std_logic_vector(7 downto 0);
        variable v_product   :  std_logic_vector(15 downto 0);
        
        variable cur_line    :  integer := 1;
    
    begin
        while not endfile(f_MULT) loop
            readline(f_MULT, v_line);
            hread(v_line, v_a);
            read(v_line, v_space);
            hread(v_line, v_b);
            read(v_line, v_space);
            hread(v_line, v_product);    
    
            a(7 downto 0) <= v_a;
            b(7 downto 0) <= v_b;
            
            wait for WAIT_TIME;
            
            assert product = v_product
                report "Actual result not matching expected result at line " & integer'image(cur_line)
                    severity error;
                    
             cur_line  := cur_line + 1;
          end loop;
          
       report "Simulation complete";
       
       wait;
    end process;  
 
     
end Behavioral;
