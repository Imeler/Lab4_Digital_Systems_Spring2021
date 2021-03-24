----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 03:52:00 PM
-- Design Name: 
-- Module Name: ripple_carry_full_adder - structural
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

entity ripple_carry_full_adder iS
    generic ( n: integer := 8);
    Port ( a : in std_logic_vector(n-1 downto 0);
           b : in std_logic_vector(n-1 downto 0);
           cin : in std_logic;
           sum : out std_logic_vector(n-1 downto 0);
           cout : out STD_LOGIC);
end ripple_carry_full_adder;

architecture structural of ripple_carry_full_adder is
    signal c_exp : std_logic_vector(n downto 0); -- cin and carry for each full adder
    signal op2   : std_logic_vector(n-1 downto 0);
    
   -- component full_adder is
     --   port (a,b,cin : in std_logic;
           --   s, cout : out std_logic);
  --  end component;
     
begin
    c_exp(0) <= cin; -- cin of first full adder. 0 for addition, 1 for substraction
    
    op2      <= b when cin = '0' else not b; -- b for addition, not b for substraction

    full_adder_gen : for i in 0 to n-1 generate
    full_adder_inst: entity work.full_adder(Dataflow)
    port map(
        a => a(i),
        b => op2(i),
      cin => c_exp(i),
        sum => sum(i),
     cout => c_exp(i+1));
     end generate;
     
     cout <= c_exp(n);                                    
end structural;
