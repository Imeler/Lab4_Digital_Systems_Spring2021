-------------------------------------------------
-- File:		carry_save_mult.vhd
-- 
-- Entity:		carry_save_mult
-- Architecture:	structural
-- Author: 		
-- Created: 	
-- Modified:			
-- VHDL'93
-- Description:   The following is the entity and
--			architectural description of the
--			carry save multiplier
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity carry_save_mult is
    generic ( n : integer := 8);
    port(
        a       : in std_logic_vector(n-1 downto 0);
        b       : in std_logic_vector(n-1 downto 0);
        product : out std_logic_vector(n-1 downto 0));
end carry_save_mult;

architecture structural of carry_save_mult is
    constant m : integer := n/2;
    
    type arr_m is array (0 to m-1) of std_logic_vector(m-1 downto 0);
    type arr_3 is array (0 to 2)   of std_logic_vector(m-1 downto 0);
    type arr_2 is array (0 to 1)   of std_logic_vector(m-1 downto 0);
    
    type arr_inter is array (1 to m-2) of std_logic_vector(m-1 downto 0);
    
    --signals for ANDing every combination of inputs a and b
    signal and_res : std_logic_vector(m*m-1 downto 0);
    signal and_arr : arr_m;
    
    --signals for first stage of Multiplier
    signal first_operands : arr_3;
    
    --signals for intermediate stages of the Multiplier
    signal inter_sum   : arr_inter;
    signal inter_carry : arr_inter;
    
    --signals for the final stage of the multiplier
    signal last_operands : arr_2;
    
begin

    -- Array of ANDing every bit of a by b
    and_n_by_n_inst: entity work.and_n_by_n(dataflow)
    generic map( n => m)
    port map(
        a   => a(m-1 downto 0),
        b   => b(m-1 downto 0),
        res => and_res
    );
    
    and_res_gen : for i in 0 to m-1 generate
        and_arr(i) <= and_res(m*(i+1)-1 downto m*i);
    end generate;
    
    
    -- First stage of Multiplier
    
    first_operands(0)(m-2 downto 0) <= and_arr(0)(m-1 downto 1);
    first_operands(0)(m-1) <= '0';
    
    first_operands(1) <= and_arr(1);
    
    first_operands(2)(m-1 downto 1) <= and_arr(2)(m-2 downto 0);
    first_operands(2)(0) <= '0';
    
    stage_first_gen : for i in 0 to m-1 generate
        full_adder_inst : entity work.full_adder(dataflow)
        port map(
            a    => first_operands(0)(i),
            b    => first_operands(1)(i),
            cin  => first_operands(2)(i),
            sum    => inter_sum(1)(i),
            cout => inter_carry(1)(i)
        );
    end generate;
    
    
    -- Intermediate stages of the Multiplier
    
    stage_inter_gen : for i in 2 to m-2 generate
        signal operands : arr_3;
    begin
        operands(0)(m-2 downto 0) <= inter_sum(i-1)(m-1 downto 1);
        operands(0)(m-1) <= and_arr(i)(m-1);
        
        operands(1)(m-1 downto 1) <= and_arr(i+1)(m-2 downto 0);
        operands(1)(0) <= '0';
        
        operands(2) <= inter_carry(i-1);
        
        inter_row_gen : for j in 0 to m-1 generate
            full_adder_inst : entity work.full_adder(dataflow)
            port map(
                a    => operands(0)(j),
                b    => operands(1)(j),
                cin  => operands(2)(j),
                sum    => inter_sum(i)(j),
                cout => inter_carry(i)(j)
            );
        end generate;
    
    end generate;
    
    -- Last stage of the Multiplier and results
    
    last_operands(0)(m-2 downto 0) <= inter_sum(m-2)(m-1 downto 1);
    last_operands(0)(m-1) <= and_arr(m-1)(m-1);
    
    last_operands(1) <= inter_carry(m-2);
    
    --Results from m-1 to n-1
    rcfa_inst: entity work.ripple_carry_full_adder(structural)
    generic map( n => m)
    port map(
        a    => last_operands(0),
        b    => last_operands(1),
        cin  => '0',
        sum  => product(n-2 downto m-1),
        cout => product(n-1)
    );
    
    -- Results for 0
    product(0) <= and_arr(0)(0);
    
    -- Results from 1 to m-2
    res_gen: for i in 1 to m-2 generate
        product(i) <= inter_sum(i)(0);
    end generate;

end structural;