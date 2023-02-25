----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2022 23:51:29
-- Design Name: 
-- Module Name: SPI_Example - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_Main is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC; 
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           Mosi : out std_logic
           );
end SPI_Main;

architecture Behavioral of SPI_Main is
   
    signal inclk : std_logic;
    signal squareout : std_logic_vector(11 downto 0);--sine wave out
    signal cs_intern : std_logic := '0';
    signal sclk_intern :STD_LOGIC :='0'; --clk_out
    signal mosi_intern : std_logic :='0';
    signal clk_out :std_logic;
--    component sine_lut
--            port( clk : in STD_LOGIC;
--                  rst : in STD_LOGIC;
--                  o_sine : out STD_LOGIC_VECTOR (11 downto 0));  
--    end component;
    component spi_int
           Port ( data_in : in std_logic_vector(11 downto 0);
           clk : in STD_LOGIC;
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           MOSI : out STD_LOGIC;
           ask : out STD_LOGIC);  
    end component;   
    
    component Filtered_square
            Port(clk_in : in STD_LOGIC;
                 reset_in : in std_logic; 
                 output : out STD_LOGIC_VECTOR (11 downto 0));
    end component;
           
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;                  
begin
   your_instance_name : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_out,
   -- Clock in ports
   clk_in1 => clk
 );
    i1 : Filtered_square
			port map(clk_in=> inclk, reset_in=> rst, output => squareout);
	i0 : spi_int
	        port map(data_in=>squareout,clk=> clk_out, sclk=>sclk_intern, cs=>cs_intern, MOSI=> mosi_intern, ask=>inclk);		
   
        
    cs <= cs_intern;
    sclk <= sclk_intern;
    mosi <= mosi_intern;


end Behavioral;
