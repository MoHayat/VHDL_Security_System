library ieee;

use ieee.std_logic_1164.all;

entity RAM is
  generic(
    ADDR_W : integer := 4; -- digits to represent memory locations
    DATA_W : integer := 8; -- size of data to store
    BUFF_L : integer := 10 -- temp holder to store bits before acual storage (i think)
  );
  port(
    -- inputs
    clk        : in std_logic;
    n_reset    : in std_logic; -- clears all fifo blocks
    rd_en      : in std_logic_vector(2 downto 0); -- enables read for all fifo blocks (CHANGE TO VECTOR)
    wr_en      : in std_logic_vector(2 downto 0); -- enables read for all fifo blocks
    data_in    : in std_logic_vector(DATA_W-1 downto 0); -- red data in
 

    --outputs
    data_out_r : out std_logic_vector(DATA_W-1 downto 0); -- red data out
    data_out_g : out std_logic_vector(DATA_W-1 downto 0); -- green data out
    data_out_b : out std_logic_vector(DATA_W-1 downto 0); -- blue data out
    data_count : out std_logic_vector(ADDR_W   downto 0); -- address of bits
    empty_rgb  : out std_logic_vector(2 downto 0); -- flags for when fifo block is empty
    full_rgb   : out std_logic_vector(2 downto 0)
  );
end RAM;

architecture structural of RAM is
-- any signals for connections within the fifo blocks would go here
begin 
red_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(0),
  wr_en      => wr_en(0),
  data_in    => data_in,
  data_out   => data_out_r,
  data_count => data_count,
  empty      => empty_rgb(0),
  full       => full_rgb(0)
);

green_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(1),
  wr_en      => wr_en(1),
  data_in    => data_in,
  data_out   => data_out_g,
  data_count => data_count,
  empty      => empty_rgb(1),
  full       => full_rgb(1)
);

blue_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(2),
  wr_en      => wr_en(2),
  data_in    => data_in,
  data_out   => data_out_b,
  data_count => data_count,
  empty      => empty_rgb(2),
  full       => full_rgb(2)
);

end structural;
