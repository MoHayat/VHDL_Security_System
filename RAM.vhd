library ieee;

use ieee.std_logic_1164.all;

entity RAM is
  generic(
    ADDR_W : integer :=  8; -- digits to represent memory locations
    DATA_W : integer := 10; -- size of data to store
    BUFF_L : integer := 1; -- temp holder to store bits before acual storage (i think)
  );
  port(
    -- inputs
    clk        : in std_logic;
    n_reset    : in std_logic; -- clears all fifo blocks
    rd_en      : in std_logic; -- enables read for all fifo blocks (CHANGE TO VECTOR)
    wr_en      : in std_logic; -- enables read for all fifo blocks
    data_in_r  : in std_logic_vector(ADDR_W-1 downto 0); -- red data in
    data_in_g  : in std_logic_vector(ADDR_W-1 downto 0); -- green data in
    data_in_b  : in std_logic_vector(ADDR_W-1 downto 0); -- blue data in

    --outputs
    data_out_r : out std_logic_vector(ADDR_W-1 downto 0); -- red data out
    data_out_g : out std_logic_vector(ADDR_W-1 downto 0); -- green data out
    data_out_b : out std_logic_vector(ADDR_W-1 downto 0); -- blue data out
    data_count : out std_logic_vector(ADDR_W   downto 0); -- address of bits
    empty_r    : out std_logic; -- flags for when fifo block is empty
    empty_g    : out std_logic;
    empty_b    : out std_logic;
    full_r     : out std_logic;
    full_g     : out std_logic;
    full_b     : out std_logic
  );
end RAM;

architecture structural of RAM is
-- any signals for connections within the fifo blocks would go here

red_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en,
  wr_en      => wr_en,
  data_in    => data_in_r,
  data_out   => data_out_r,
  data_count => data_count,
  empty      => empty_r,
  full       => full_r
);

green_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en,
  wr_en      => wr_en,
  data_in    => data_in_g,
  data_out   => data_out_g,
  data_count => data_count,
  empty      => empty_g,
  full       => full_g
);

blue_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en,
  wr_en      => wr_en,
  data_in    => data_in_b,
  data_out   => data_out_b,
  data_count => data_count,
  empty      => empty_b,
  full       => full_b
);

end structural;
