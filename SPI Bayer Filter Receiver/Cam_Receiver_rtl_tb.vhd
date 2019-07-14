-- ELEC562: Spring 2019
-- Testbench for Receiver Module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cam_Receiver_rtl_tb is
end Cam_Receiver_rtl_tb;
 
architecture test of Cam_Receiver_rtl_tb is 
  -- define clock period
constant clock_period  : time := 27.77778 ns;
signal clk_in_s        : std_logic;
signal rst_in_s   	   : std_logic; 
signal VSYNC_in_s      : std_logic;
signal HREF_in_s   	   : std_logic;
signal Sensor_in_s     : std_logic;   
signal RGB_level_in_s  : std_logic_vector(7 downto 0);
signal RGB_level_out_s : std_logic_vector(7 downto 0);
signal Read_EN_out_s   : std_logic_vector(2 downto 0);
  
begin
 
  -- instantiate the unit under test (uut)
   uut: entity work.Cam_Receiver_rtl(rtl) 
   port map (
    clk_36Mhz_in        => clk_in_s,
    rst_in              => rst_in_s,
    VSYNC_in            => VSYNC_in_s,
    HREF_in             => HREF_in_s,
    Sensor_in           => Sensor_in_s,
    RGB_level_in        => RGB_level_in_s,
    RGB_level_out       => RGB_level_out_s,
	Read_EN_out         => Read_EN_out_s
   );
   
  -- clock process
  clock_process : process
  begin
    clk_in_s <= '0';
    wait for clock_period / 2;
    clk_in_s <= '1';
    wait for clock_period / 2;
  end process;

  

   -- stimulus process
  stim_proc : process
  begin 
	rst_in_s       <= '1';
	VSYNC_in_s     <= '1';
	HREF_in_s      <= '1';
	Sensor_in_s    <= '0';
	RGB_level_in_s <= x"FF";
	wait for clock_period;
	rst_in_s       <= '0';
	VSYNC_in_s     <= '0';
	wait for clock_period;
	RGB_level_in_s <= x"FE";
	wait for clock_period;
	RGB_level_in_s <= x"FD";
	wait for clock_period;
	RGB_level_in_s <= x"FC";
	wait for clock_period;
	RGB_level_in_s <= x"FB";
	wait for clock_period;
	RGB_level_in_s <= x"FA";
	wait;
	end process;

end test;
