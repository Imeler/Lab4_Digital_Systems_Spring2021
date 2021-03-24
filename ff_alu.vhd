
library ieee;
use ieee.std_logic_1164.all;

entity ff_alu is
    port (
        clk       : in std_logic;
        input1    : in std_logic_vector(15 downto 0); 
        input2    : in std_logic_vector(15 downto 0); 
        control   : in std_logic_vector(3 downto 0); 
        output    : out std_logic_vector(15 downto 0)
        ); 
        
    end ff_alu;
    
 architecture mixed of ff_alu is
    signal input1_reg  : std_logic_vector(15 downto 0);
    signal input2_reg  : std_logic_vector(15 downto 0);
    signal control_reg  : std_logic_vector(3 downto 0);
    signal output_reg  : std_logic_vector(15 downto 0);    
    
 begin
 
    -- instantiate alu
    alu_inst : entity work.alu(structural)
    port map (
        input1 => input1_reg,   
        input2 => input2_reg,   
        control => control_reg,   
        output => output_reg
        );   
    
    
    -- flip flops declarations
    
      ff : process(clk)
      begin
            if rising_edge(clk) then
            input1_reg  <= input1;
            input2_reg  <= input2;
            control_reg  <= control;
            output <= output_reg;
 
           end if;
         end process;
   end mixed;
   
            



