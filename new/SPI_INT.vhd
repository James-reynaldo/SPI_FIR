----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2023 11:00:11
-- Design Name: 
-- Module Name: SPI_INT - Behavioral
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

entity SPI_INT is
    Port ( data_in : in std_logic_vector(11 downto 0);
           clk : in STD_LOGIC;
           sclk : out STD_LOGIC;
           cs : out STD_LOGIC;
           MOSI : out STD_LOGIC;
           ask : out STD_LOGIC);
end SPI_INT;

architecture Behavioral of SPI_INT is

type ram is array (0 to 1) of std_logic_vector(15 downto 0);
type condition is(idle,start,transfer,last);
signal state : condition := idle;

signal reg : std_logic_vector(3 downto 0) := "1011";
signal comp_send : std_logic_vector(15 downto 0);
signal kHz1counter : unsigned(13 downto 0) := to_unsigned(0,14); 
signal bit16counter : unsigned(3 downto 0) := "0000";
constant FULL1KHZ : integer := 2; -- generic possibility, idle time
signal cs_intern : std_logic := '0';
signal sclk_intern :STD_LOGIC :='0'; --clk_out
signal mosi_intern : std_logic :='0';

signal ask_intern : std_logic :='1';

begin
     comp_send <= reg & data_in; -- complete message
     sendword : process(clk)
     begin
     if rising_edge(clk) then
            case state is
                when idle=>
                    cs_intern<='1';
                    sclk_intern<='0';
                    
                    if(kHz1counter=FULL1KHZ) then
                        kHz1counter <= (others => '0');
--                        lut_sig <= to_unsigned(LUT(cnt),12);
                        state <= start;
                    else
                        kHz1counter <= kHz1counter + 1;    --wait 12000 * clk period
                    end if;
                        
                when start =>
                    
                    cs_intern <='0';
                    bit16counter <= "1111";
                    mosi_intern <= comp_send(15);
                    state <= transfer;
                    ask_intern <= '0';
                    
                when transfer =>
                    if(sclk_intern = '0') then
                        sclk_intern<='1';
                        bit16counter <= Bit16counter -1;
                    else
                        sclk_intern <= '0';
                        mosi_intern <= comp_send(to_integer(bit16counter));
                        if(bit16counter =0) then
                            state <= last;
                        end if;        
                    end if;
                when last =>
                    if(sclk_intern = '0') then
                        sclk_intern <= '1';
                    else
                        sclk_intern <= '0';
                        mosi_intern<= '0';
                        state <= idle;
                        ask_intern <= '1';
                    end if;
                                
            end case;
                
        end if;                        
     end process;
    ask <= ask_intern;
    cs <= cs_intern;
    sclk <= sclk_intern;
    mosi <= mosi_intern;     
end Behavioral;

