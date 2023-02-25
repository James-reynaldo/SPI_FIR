----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2023 11:46:06
-- Design Name: 
-- Module Name: FIR_filter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity FIR_filter is
    Port ( clk      : in  std_logic;
           reset    : in  std_logic;
           input    : in  std_logic_vector(7 downto 0);
           output   : out std_logic_vector(11 downto 0));
end FIR_filter;

architecture Behavioral of FIR_filter is

    -- Filter coefficients
	type coefficient_t is array (0 to 11) of std_logic_vector(7 downto 0);
	constant COEFFICIENTS : coefficient_t := (
    		x"03", x"0f", x"20", x"32",x"40",x"48",
    		x"48", x"40", x"32", x"20",x"0f",x"03"
		);
    -- Delay line for storing input samples
    type delay_line_t is array (0 to 11) of std_logic_vector(7 downto 0);
    signal delay_line : delay_line_t := (others => (others => '0'));
    signal output_intern : std_logic_vector(11 downto 0):=(others => '0');
    -- Output accumulator
    --signal accumulator : signed(15 downto 0) := (others => '0');

begin

    process (clk)
    variable accumulator : signed(15 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset delay line and accumulator
                delay_line <= (others => (others => '0'));
                accumulator := (others => '0');
            else
                
                -- Shift input samples through delay line
                for i in delay_line'range loop
                    if i = delay_line'high then
                        delay_line(i) <= input;
                    else
                        delay_line(i) <= delay_line(i+1);
                    end if;
                end loop;

                -- Compute output sample
                accumulator := to_signed(0, accumulator'length);
                for i in COEFFICIENTS'range loop
                    accumulator := accumulator + (signed(delay_line(i)) * signed(COEFFICIENTS(i)));           
                end loop;
                output_intern <= std_logic_vector(accumulator(accumulator'high downto accumulator'high - output'length + 1)); -- truncation
                --output_intern <= std_logic_vector(accumulator);

            end if;
        end if;
    end process;
    output <= output_intern;
end Behavioral;
