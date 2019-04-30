library ieee;

use ieee.std_logic_1164.all;

entity RAM is
  generic(
    ADDR_W : integer := 4;   -- digits to represent memory locations
    DATA_W : integer := 8;   -- size of data to store
    BUFF_L : integer := 3;   -- temp holder to store bits before acual storage (i think)
    R_MAX  : integer := 599; -- maximum number of pixels per row
    C_MAX  : integer := 799  -- maximum number of pixels per column
  );
  port(
    -- inputs
    clk        : in std_logic;
    n_reset    : in std_logic; -- clears all fifo blocks
   
    wr_en      : in std_logic_vector(2 downto 0); -- enables read for all fifo blocks (WRITING TO RAM)
    data_in    : in std_logic_vector(DATA_W-1 downto 0); -- red data in
 

    --outputs
    data_out_r : out std_logic_vector(DATA_W-1 downto 0); -- red data out
    data_out_g : out std_logic_vector(DATA_W-1 downto 0); -- green data out
    data_out_b : out std_logic_vector(DATA_W-1 downto 0); -- blue data out
   
    column     : out integer;
    row        : out integer
  );
end RAM;

architecture hybrid of RAM is
type output_state is (
     active,
     passive
    );

-- any signals for connections within the fifo blocks would go here
signal  r_count : integer:= 1;
signal  c_count : integer:= 0;
signal  data_out_r_s : std_logic_vector(DATA_W-1 downto 0);
signal  data_out_g_s : std_logic_vector(DATA_W-1 downto 0);
signal  data_out_b_s : std_logic_vector(DATA_W-1 downto 0);
signal  full_rgb     : std_logic_vector(2 downto 0);
signal  empty_rgb    : std_logic_vector(2 downto 0); -- flags for when fifo block is empty
signal  rd_en        : std_logic_vector(2 downto 0); -- enables read for all fifo blocks (CHANGE TO VECTOR) (READING FROM RAM)
signal  state_s      : output_state;
begin 
red_fifo : entity work.FIFO(arch)
port map(
  clk        => clk,
  n_reset    => n_reset,
  rd_en      => rd_en(2),
  wr_en      => wr_en(2),
  data_in    => data_in,
  data_out   => data_out_r_s,
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
  data_out   => data_out_g_s,
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
  data_out   => data_out_b_s,
  empty      => empty_rgb(0),
  full       => full_rgb(0)
);
    vga_control_proc: process (n_reset,clk)
    begin
    if(n_reset='0') then
    state_s            <= passive;
    rd_en <= "000";
    elsif(rising_edge(clk)) then
        case state_s is 
            When active=> 
            data_out_r <= data_out_r_s;
            data_out_g <= data_out_g_s;
            data_out_b <= data_out_b_s;
            row <= r_count;
            column <= c_count;
            rd_en <= "111";
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
                        state_s <= passive;
                    end if;
                state_s <= active;
                end if;
                 
            When passive =>
            if(full_rgb="111") then
             state_s <= active;
            else
                state_s <= passive;
            end if;
            end case;
        end if;

     end process;

end hybrid;
