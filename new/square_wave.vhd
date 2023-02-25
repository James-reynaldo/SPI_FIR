----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2023 21:35:29
-- Design Name: 
-- Module Name: Square_signal - Behavioral
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
entity square_wave is
    Port ( clk : in  STD_LOGIC;
           square_out : out  STD_LOGIC_VECTOR(7 downto 0));
end square_wave;

architecture Behavioral of square_wave is
    signal counter : integer range 0 to 255 := 0;
    signal square : STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = 127 then
                square <= square xor "01111111";
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
            
        end if;
    end process;
    square_out <= std_logic_vector(to_unsigned(to_integer(unsigned(square)), 8));
end Behavioral;
