-------------------------------------------------
-- File:		alu_tb.vhd
-- 
-- Entity:		alu_tb
-- Architecture:	behavioral
-- Author: 		
-- Created: 	
-- Modified:			
-- VHDL'93
-- Description:   The following is the entity and
--			architectural description of
--			the ALU test bench
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity alu_tb is
end alu_tb;

architecture behavioral of alu_tb is
    constant WAIT_TIME : time := 100ns;
    constant NUM_TESTS : integer := 5;
    constant NUM_OPERATIONS : integer := 16;
    
    signal a        : std_logic_vector(15 downto 0);
    signal b        : std_logic_vector(15 downto 0);
    signal control  : std_logic_vector(3 downto 0);
    signal actual   : std_logic_vector(15 downto 0);
    
--    signal a_s      : signed(15 downto 0);
--    signal a_u      : unsigned(15 downto 0);
--    signal b_u      : unsigned(15 downto 0);
--    signal b4_int   : natural;  -- First 4 bits of b in integer
    
    --expected signals
--    signal expected_add  : std_logic_vector(15 downto 0);
--    signal expected_sub  : std_logic_vector(15 downto 0);
--    signal expected_mul  : std_logic_vector(15 downto 0);
    
--    signal expected_or   : std_logic_vector(15 downto 0);
--    signal expected_not  : std_logic_vector(15 downto 0);
--    signal expected_and  : std_logic_vector(15 downto 0);
--    signal expected_xor  : std_logic_vector(15 downto 0);
    
--    signal expected_sll  : std_logic_vector(15 downto 0);
--    signal expected_srl  : std_logic_vector(15 downto 0);
--    signal expected_sra  : std_logic_vector(15 downto 0);
    
    signal expected  : std_logic_vector(15 downto 0);
    
begin
--    --expected results
--    a_s <= signed(a);
--    a_u <= unsigned(a);
--    b_u <= unsigned(b);
--    b4_int <= to_integer(b_u(3 downto 0));

--    expected_add <= std_logic_vector(a_u + b_u);
--    expected_sub <= std_logic_vector(a_u - b_u);
--    expected_mul <= std_logic_vector(a_u(7 downto 0) * b_u(7 downto 0));
    
--    expected_or  <= a or b;
--    expected_not <= not a;
--    expected_and <= a and b;
--    expected_xor <= a xor b;
    
--    expected_sll <= std_logic_vector(shift_left(a_u, b4_int));
--    expected_srl <= std_logic_vector(shift_right(a_u, b4_int));
--    expected_sra <= std_logic_vector(shift_right(a_s, b4_int));

    --component instantiation
    alu_inst : entity work.alu (structural)
    port map (
        input1  => a,
        input2  => b,
        control => control,
        output  => actual
    );

    --input process
    inputs_ps: process
    begin
        --5 tests per control signal value
        for i in 0 to NUM_OPERATIONS-1 loop
            control <= std_logic_vector(to_unsigned(i,4));
            a <= x"00FE";
            b <= x"00EF";
            wait for WAIT_TIME;
            a <= x"8F9E";
            b <= x"DCAB";
            wait for WAIT_TIME;
            a <= x"FE3A";
            b <= x"0341";
            wait for WAIT_TIME;
            a <= x"0001";
            b <= x"FFFF";
            wait for WAIT_TIME;
            a <= x"FFFF";
            b <= x"0000";
            wait for WAIT_TIME;
        end loop;
        wait;
    end process;
    
    --set expected result
    expected_ps: process
    begin
        wait for 1ps;
        --control = "0000", "0001", "0010","0011"
        for i in 0 to 4 * NUM_TESTS-1 loop
            expected <= (others => '0');
            wait for WAIT_TIME;
        end loop;
        
        --control = "0100"
        for i in 0 to NUM_TESTS-1 loop
            expected <= std_logic_vector(unsigned(a) + unsigned(b));
            wait for WAIT_TIME;
        end loop;
        
        --control = "0101"
        for i in 0 to NUM_TESTS-1 loop
            expected <= std_logic_vector(unsigned(a) - unsigned(b));
            wait for WAIT_TIME;
        end loop;
        
        --control = "0110"
        for i in 0 to NUM_TESTS-1 loop
            expected <= std_logic_vector(unsigned(a(7 downto 0)) * unsigned(b(7 downto 0)));
            wait for WAIT_TIME;
        end loop;
        
        --control = "0111"
        for i in 0 to NUM_TESTS-1 loop
            expected <= (others => '0');
            wait for WAIT_TIME;
        end loop;
        
        --control = "1000"
        for i in 0 to NUM_TESTS-1 loop
            expected <= a or b;
            wait for WAIT_TIME;
        end loop;
        
        --control = "1001"
        for i in 0 to NUM_TESTS-1 loop
            expected <= not a;
            wait for WAIT_TIME;
        end loop;
        
        --control = "1010"
        for i in 0 to NUM_TESTS-1 loop
            expected <= a and b;
            wait for WAIT_TIME;
        end loop;
        
        --control = "1011"
        for i in 0 to NUM_TESTS-1 loop
            expected <= a xor b;
            wait for WAIT_TIME;
        end loop;
        
        --control = "1100"
        for i in 0 to NUM_TESTS-1 loop
            expected <= std_logic_vector(shift_left(unsigned(a), to_integer(unsigned(b(3 downto 0)))));
            wait for WAIT_TIME;
        end loop;
        
        --control = "1101"
        for i in 0 to NUM_TESTS-1 loop
            expected <= std_logic_vector(shift_right(unsigned(a), to_integer(unsigned(b(3 downto 0)))));
            wait for WAIT_TIME;
        end loop;
        
        --control = "1110"
        for i in 0 to NUM_TESTS-1 loop
            expected <= std_logic_vector(shift_right(signed(a), to_integer(unsigned(b(3 downto 0)))));
            wait for WAIT_TIME;
        end loop;
        
        --control = "1111"
        for i in 0 to NUM_TESTS-1 loop
            expected <= (others => '0');
            wait for WAIT_TIME;
        end loop;
        
        wait;
    end process;
    
    --compare actual to expected
    compare: process
    begin
        wait for 20ns;
        
        for i in 0 to NUM_OPERATIONS * NUM_TESTS-1 loop
            assert actual = expected
                report "Error at test number " & integer'image(i)
                    severity error;
            wait for WAIT_TIME;
        end loop;
        
        report "Simulation finished.";
        wait;
    end process;
    
end behavioral;