----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 11:26:51 PM
-- Design Name: 
-- Module Name: alu6 - structural
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

entity alu is
    Port ( input1 : in STD_LOGIC_VECTOR (15 downto 0);
           input2 : in STD_LOGIC_VECTOR (15 downto 0);
           control : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (15 downto 0));
end alu;

architecture structural of alu is

    signal adder_res : std_logic_vector(15 downto 0);
    signal mult_res : std_logic_vector(15 downto 0);
    signal logical_res : std_logic_vector(15 downto 0);
    signal shift_res : std_logic_vector(15 downto 0);

begin
    
    adder_inst : entity work.ripple_carry_full_adder (structural)
    generic map(n => 16)
    port map (
        a => input1,
        b => input2,
        cin => control(0),
        sum => adder_res,
        cout => open
        );
        
        
    mult_inst : entity work.carry_save_mult (structural)
    generic map(n => 16)
    port map (
            a     => input1,
            b => input2,
      product => mult_res
      );
        
    logical_inst : entity work.logic_unit (dataflow)
    generic map (n => 16)
    port map (
        a => input1,
        b => input2,
        control => control(1 downto 0),
   output => logical_res
    );
    
        
    shifter_inst : entity work.shifter (structural)
    generic map (n => 16)
    port map (
        a => input1,
        b => input2,
  control => control (1 downto 0),
   output => shift_res
    );
    
    
    
    with control select
        output <=
            adder_res       when "0100" | "0101",
            mult_res        when "0110",
            logical_res     when "1000" | "1001" | "1010" | "1011",
            shift_res       when "1100" | "1101" | "1110",
            (others => '0') when others;
    

end structural;