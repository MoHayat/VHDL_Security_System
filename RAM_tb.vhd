library ieee;
use ieee.std_logic_1164.all;

entity RAM_tb is
end RAM_tb;

architecture test of RAM_tb is
  -- constants
  constant clk_period : time := 40 ns;

  -- signals
  signal clk_s : std_logic;
  signal n_reset_s      : std_logic;
  signal rd_en_s        : std_logic_vector(2 downto 0);
  signal wr_en_s        : std_logic_vector(2 downto 0);
  signal data_in_s      : std_logic_vector(7 downto 0);
  signal data_out_r_s   : std_logic_vector(7 downto 0);
  signal data_out_g_s   : std_logic_vector(7 downto 0);
  signal data_out_b_s   : std_logic_vector(7 downto 0);
  signal data_count_s   : std_logic_vector(4 downto 0);
  signal empty_rgb_s    : std_logic_vector(2 downto 0);
  signal full_rgb_s     : std_logic_vector(2 downto 0);

begin

  --instantiate RAM module to begin testing
  RAM_uut : entity work.RAM(structural)
  port map(
    clk => clk_s,
    n_reset    => n_reset_s,
    rd_en      => rd_en_s,
    wr_en      => wr_en_s,
    data_in    => data_in_s,
    data_out_r => data_out_r_s,
    data_out_g => data_out_g_s,
    data_out_b => data_out_b_s,
    empty_rgb  => empty_rgb_s,
    full_rgb   => full_rgb_s
  );

  clk_process : process
  begin
    clk_s <= '0';
    wait for clk_period/2;
    clk_s <= '1';
    wait for clk_period/2;
  end process;

  -- stimulus Process
  stim_process : process
  begin
   n_reset_s <= '0';
   rd_en_s   <= "000";
   wr_en_s   <= "000";
   wait for 50 ns;
   n_reset_s <= '1';
   rd_en_s   <= "000";
   wr_en_s   <= "100";
   data_in_s <= "00111000";
   wait for 40 ns;
   data_in_s <= "10101011";
   wait for 40 ns;
   data_in_s <= "11110000";
   wait for 40 ns;
   rd_en_s   <= "100";
   wr_en_s   <= "000";
   wait for 100 ns;
   n_reset_s <= '0';
   rd_en_s   <= "000";
   wr_en_s   <= "000";
   wait for 50 ns;
   n_reset_s <= '1';
   rd_en_s   <= "000";
   wr_en_s   <= "010";
   data_in_s <= "00111000";
   wait for 40 ns;
   data_in_s <= "10101011";
   wait for 40 ns;
   data_in_s <= "11110000";
   wait for 40 ns;
   rd_en_s   <= "010";
   wr_en_s   <= "000";
   wait for 100 ns;
   n_reset_s <= '0';
   rd_en_s   <= "000";
   wr_en_s   <= "000";
   wait for 50 ns;
   n_reset_s <= '1';
   rd_en_s   <= "000";
   wr_en_s   <= "001";
   data_in_s <= "00111000";
   wait for 40 ns;
   data_in_s <= "10101011";
   wait for 40 ns;
   data_in_s <= "11110000";
   wait for 40 ns;
   rd_en_s   <= "001";
   wr_en_s   <= "000";
   wait for 100 ns;
   end process;
end test;