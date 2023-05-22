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
    Port ( clk : in STD_LOGIC; --
           rst : in STD_LOGIC; --
           sclk : out STD_LOGIC; --
           cs : out STD_LOGIC; --
           Mosi : out std_logic; --
           vaux5_p: in std_logic; --
           vaux5_n: in std_logic; --
           vaux12_p: in std_logic; --
           vaux12_n: in std_logic --
           );
end SPI_Main;

architecture Behavioral of SPI_Main is
   
    signal inclk : std_logic;
    signal squareout : std_logic_vector(11 downto 0);--sine wave out
    signal cs_intern : std_logic := '0';
    signal sclk_intern :STD_LOGIC :='0'; --clk_out
    signal mosi_intern : std_logic :='0';
    signal clk_out :std_logic;
    signal daddr : std_logic_vector(6 downto 0):= "0010101";
    signal channel_sel : std_logic_vector(4 downto 0);
    signal vp: std_logic;
    signal vn: std_logic;
    signal drdy: std_logic;
    signal dout: std_logic_vector(15 downto 0);
    signal di: std_logic_vector (15 downto 0):="0000000000000000";
    signal dwe: std_logic:='0';
    signal busy: std_logic;
    signal eoc: std_logic;
    signal eos: std_logic;
    signal alarm: std_logic;
    signal den: std_logic:='1';

    
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
           ask : out std_logic);  
    end component;   
    
    component xadc_wiz_0
    port
   (
    daddr_in        : in  STD_LOGIC_VECTOR (6 downto 0);     -- Address bus for the dynamic reconfiguration port
    den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
    di_in           : in  STD_LOGIC_VECTOR (15 downto 0);    -- Input data bus for the dynamic reconfiguration port
    dwe_in          : in  STD_LOGIC;                         -- Write Enable for the dynamic reconfiguration port
    do_out          : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
    dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
    reset_in        : in  STD_LOGIC;                         -- Reset signal for the System Monitor control logic
    vauxp5          : in  STD_LOGIC;                         -- Auxiliary Channel 5
    vauxn5          : in  STD_LOGIC;
    vauxp12         : in  STD_LOGIC;                         -- Auxiliary Channel 12
    vauxn12         : in  STD_LOGIC;
    busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
    channel_out     : out  STD_LOGIC_VECTOR (4 downto 0);    -- Channel Selection Outputs
    eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
    eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
    alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
    vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
    vn_in           : in  STD_LOGIC
);
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
    ii : xadc_wiz_0
            port map(
            daddr_in=>daddr,     -- *Address bus for the dynamic reconfiguration port
            den_in => den,       -- Enable Signal for the dynamic reconfiguration port
            di_in =>di,    -- Input data bus for the dynamic reconfiguration port
            dwe_in => dwe,  -- Write Enable for the dynamic reconfiguration port
            do_out=> dout,   -- Output data bus for dynamic reconfiguration port
            drdy_out=>drdy,   -- Data ready signal for the dynamic reconfiguration port
            dclk_in=>clk_out,  -- Clock input for the dynamic reconfiguration port
            reset_in=>rst,     -- Reset signal for the System Monitor control logic
            vauxp5=>vaux5_p,    -- Auxiliary Channel 5
            vauxn5=> vaux5_n,     
            vauxp12=>vaux12_p, -- Auxiliary Channel 12
            vauxn12=>vaux12_n, 
            busy_out=>busy,    -- ADC Busy signal
            channel_out=>channel_sel,     -- Channel Selection Outputs
            eoc_out => eoc,    -- End of Conversion Signal
            eos_out => eos,    -- End of Sequence Signal
            alarm_out => alarm,-- OR'ed output of all the Alarms
            vp_in=> vp,        -- Dedicated Analog Input Pair
            vn_in => vn         
            );
    process (clk)
    begin
    if rising_edge(clk) then
        if rising_edge(den)then
            case daddr is 
            when "0011100"=> daddr<="0010101";
            when "0010101"=> daddr<="0011100";
            when others => 
            end case;
        end if;
    end if;
    end process;
    i1 : Filtered_square
			port map(clk_in=> inclk, reset_in=> rst, output => squareout);
	i0 : spi_int
	        port map(data_in=>dout(11 downto 0),clk=> clk_out, sclk=>sclk_intern, cs=>cs_intern, MOSI=> mosi_intern, ask=>inclk);		
   
        
    cs <= cs_intern;
    sclk <= sclk_intern;
    mosi <= mosi_intern;


end Behavioral;
