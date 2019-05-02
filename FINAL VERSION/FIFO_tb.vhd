library ieee;
use ieee.std_logic_1164.all;

entity FIFO_tb is
end FIFO_tb;

architecture test of FIFO_tb is
  -- constants
  constant clk_period : time := 40 ns;

  --signals (used to test device)
  signal clk_s        : std_logic;
  signal n_reset_s    : std_logic;
  signal rd_en_s      : std_logic;
  signal wr_en_s      : std_logic;
  signal data_in_s    : std_logic_vector(7 downto 0);
  signal data_out_s   : std_logic_vector(7 downto 0);
  signal data_count_s : std_logic_vector(4 downto 0);
  signal empty_s      : std_logic;
  signal full_s       : std_logic;

begin
    -- instantiate the unit under test
    FIFO_uut: entity work.FIFO(arch)
    port map(
      clk        => clk_s,
      n_reset    => n_reset_s,
      rd_en      => rd_en_s,
      wr_en      => wr_en_s,
      data_in    => data_in_s,
      data_out   => data_out_s,
      data_count => data_count_s,
      empty      => empty_s,
      full       => full_s
    );

    -- process for timing
    clk_process : process
    begin
        clk_s <= '0';
        wait for clk_period/2;
        clk_s <= '1';
        wait for clk_period/2;
    end process;

    -- stimulus process
    stim_process : process
    begin
      n_reset_s <= '0';
      rd_en_s   <= '0';
      wr_en_s   <= '0';
      wait for 50 ns;
      n_reset_s <= '1';
      rd_en_s   <= '0';
      wr_en_s   <= '1';
      data_in_s <= "00111000";
      wait for 40 ns;
      data_in_s <= "10101011";
      wait for 40 ns;
      data_in_s <= "11010111";
      wait for 40 ns;
      data_in_s <= "11110000";
      wait for 40 ns;
      rd_en_s   <= '1';
      wr_en_s   <= '0';
      wait;
    end process;
end test;
