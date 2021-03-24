-------------------------------------------------
-- File:		mult8x8_file.vhd
-- 
-- Entity:		mult8x8_file
-- Architecture:	behavioral
-- Author: 		
-- Created: 	
-- Modified:			
-- VHDL'93
-- Description:   The following is the entity and
--			architectural description of
--			generating all possible 8x8
--          multiplications in a file
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity mult8x8_file is
end mult8x8_file;

architecture behavioral of mult8x8_file is
    file f_MULT : text OPEN WRITE_MODE is "../../../mult8x8.txt";

    constant WAIT_TIME : time := 100ns;
    
    signal a       : std_logic_vector(7 downto 0);
    signal b       : std_logic_vector(7 downto 0);
    signal product : std_logic_vector(15 downto 0);
    
begin
    gen: process
        variable v_line  : line;
        variable v_space : character;
    begin
        v_space := character'(' ');
        
        readline(f_MULT, v_line);
        
        --loop all possible factors
        for i in 0 to (2**8)-1 loop
            for j in 0 to (2**8)-1 loop
                a <= std_logic_vector(to_unsigned(i,8));
                b <= std_logic_vector(to_unsigned(j,8));
                
                wait for WAIT_TIME;
                
                product <= std_logic_vector(unsigned(a) * unsigned(b));
                
                wait for WAIT_TIME;
                
                hwrite(v_line, a); --write first factor to line
                write(v_line, v_space);
                hwrite(v_line, b); --write second factor to line
                write(v_line, v_space);
                hwrite(v_line, product); --write the product to line
                writeline(f_MULT, v_line); --write line to file
            end loop;
        end loop;
        wait;
    end process;
    

end behavioral;