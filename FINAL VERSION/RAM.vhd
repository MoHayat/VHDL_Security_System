library ieee;

use ieee.std_logic_1164.all;

entity RAM is
  generic(
    ADDR_W : integer := 4;   -- digits to represent memory locations
    DATA_W : integer := 8;   -- size of data to store
    BUFF_L : integer := 10;   -- temp holder to store bits before acual storage (i think)
    R_MAX  : integer := 599; -- maximum number of pixels per row
    C_MAX  : integer := 799  -- maximum number of pixels per column
  );
  port(
    -- inputs
    clk        : in std_logic;
    n_reset    : in std_logic; -- clears all fifo blocks
    rd_en      : in std_logic_vector(2 downto 0); -- enables read for all fifo blocks (CHANGE TO VECTOR) (READING FROM RAM)
    wr_en      : in std_logic_vector(2 downto 0); -- enables read for all fifo blocks (WRITING TO RAM)
    data_in    : in std_logic_vector(DATA_W-1 downto 0); -- red data in
 

    --outputs
    data_out_r : out std_logic_vector(DATA_W-1 downto 0); -- red data out
    data_out_g : out std_logic_vector(DATA_W-1 downto 0); -- green data out
    data_out_b : out std_logic_vector(DATA_W-1 downto 0); -- blue data out
    empty_rgb  : out std_logic_vector(2 downto 0); -- flags for when fifo block is empty
    full_rgb   : out std_logic_vector(2 downto 0);
    column     : out integer;
    row        : out integer
  );
end RAM;

architecture hybrid of RAM is
-- any signals for connections within the fifo blocks would go here
signal  r_count : integer range 0 to R_MAX := 0;
signal  c_count : integer range 0 to C_MAX := 0;
begin 
red_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(2),
  wr_en      => wr_en(2),
  data_in    => data_in,
  data_out   => data_out_r,
  empty      => empty_rgb(2),
  full       => full_rgb(2)
);

green_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(1),
  wr_en      => wr_en(1),
  data_in    => data_in,
  data_out   => data_out_g,
  empty      => empty_rgb(1),
  full       => full_rgb(1)
);

blue_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(0),
  wr_en      => wr_en(0),
  data_in    => data_in,
  data_out   => data_out_b,
  empty      => empty_rgb(0),
  full       => full_rgb(0)
);

count_proc: process (rd_en)
begin
        if(rd_en'event and rd_en = "000") then
            if ( c_count < C_MAX) then
                c_count <= c_count + 1;
                column  <= c_count + 1;
                row     <= r_count;
            else
                c_count <= 0;
                column  <= 0;
                if (r_count < R_MAX) then
                    r_count <= r_count + 1;
                    row     <= r_count + 1;
                else
                    r_count <= 0;
                    row     <= 0;
                end if;
             end if;
         end if;

 end process;

end hybrid;
