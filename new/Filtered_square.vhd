----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2023 21:44:56
-- Design Name: 
-- Module Name: Main - Behavioral
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

entity Filtered_square is
    Port ( clk_in : in STD_LOGIC;
           reset_in : in std_logic; 
           output : out STD_LOGIC_VECTOR (11 downto 0));
end Filtered_square;

architecture Behavioral of Filtered_square is

signal data : std_logic_vector(7 downto 0);
signal output_intern : std_logic_vector(11 downto 0);

component FIR_filter
    port(
           clk      : in  std_logic;
           reset    : in  std_logic;
           input    : in  std_logic_vector(7 downto 0);
           output   : out std_logic_vector(11 downto 0));
    
end component;

component square_wave
    port(
           clk : in  STD_LOGIC;
           square_out : out  std_logic_vector(7 downto 0));
end component;
           
begin

Square_wave_inst: square_wave port map(clk => clk_in, square_out => data);

FIR_filter_inst: FIR_filter port map(clk => clk_in,reset=>reset_in,input=>data,output=>output_intern);

output<=output_intern;
end Behavioral;
