library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- ENTITY ---------------------------------------------------------------------
-------------------------------------------------------------------------------
entity SPI_Receiver is
  port (
    -- Reset / Clock
    clk_36Mhz_in       : in  std_logic;
    rst_in             : in  std_logic;
	-- Receiver Inputs
    RGB_level_in       : in std_logic_vector(7 downto 0);
    VSYNC_in           : in  std_logic;
	HREF_in            : in  std_logic;
    -- Receiver Outputs
    R_level_out        : out std_logic_vector(7 downto 0);
    G_level_out        : out std_logic_vector(7 downto 0);
	B_level_out        : out std_logic_vector(7 downto 0)
  );
end SPI_Receiver;



-------------------------------------------------------------------------------
-- ARCHITECTURE ---------------------------------------------------------------
-------------------------------------------------------------------------------
architecture rtl of SPI_Receiver is

  ---------------------------------------------------------------------------
  --constants, types, functions
  ---------------------------------------------------------------------------
  -- constant num_clocks_in_1_sec_c   : integer := 1 sec / (1 ns * 10); 
  -- constant num_clocks_in_2_secs_c  : integer := num_clocks_in_1_sec_c * 2;  
  -- constant num_clocks_in_3_secs_c  : integer := num_clocks_in_1_sec_c * 3;
  constant Column_max  : integer := 800 ;  
  constant Row_max     : integer := 600 ;
  
   type row_state is (
     odd_row,
     even_row
  -- );

  ---------------------------------------------------------------------------
  --signals
  --------------------------------------------------------------------------- 
  signal Column_count_s        : integer range 0 to 799;
  signal Row_count_s           : integer range 0 to 599;
  signal state_s               : row_state;
  -- signal enable_100MHz         : std_logic;
  -- signal clock_count_s         : integer range 0 to num_clocks_in_3_secs_c;
  -- signal state_s               : red_light_state;
  
-- begin
  -- Slowclk: process(rst_in, clk_36mhz_in)
  -- begin
    -- if (rst_in = '1') then
      -- clock100MHZ_count_s <= 0;
      -- enable_100MHz       <= '0';
    -- elsif rising_edge(clk_36mhz_in) then
      -- if (clock100MHZ_count_s = 9) then
        -- clock100MHZ_count_s <= 0;
        -- enable_100MHz       <= '1';
      -- else
        -- clock100MHZ_count_s <= clock100MHZ_count_s + 1;
        -- enable_100MHz       <= '0';
      -- end if;
    -- end if;
  -- end process;  
        
          

  RGB_sorter : process(rst_in, clk_36Mhz_in)
  begin
    if (rst_in = '1') then
      R_level_out    <= (others => '0'); 
      G_level_out    <= (others => '0');
	  B_level_out    <= (others => '0');
	  Column_count_s <= 0;
	  Row_count_s    <= 0;	  
      state_s            <= even_row;
    elsif (rising_edge(clk_36mhz_in)) then
		if ((VSYNC_in = '0') and (HREF_in = '1') and (Row_count_s /= Row_max) ) then --valid picture processing 
			case state_s is 
				when even_row =>
					if ((Column_count_s mod 2 = 0) and (Column_count_s /= Column_max) ) then
						B_level_out <= RGB_level_in;
						Column_count_s <= Column_count_s + 1;
					elsif ((Column_count_s mod 2 = 1) and (Column_count_s /= Column_max) ) then
						G_level_out <= RGB_level_in;
						Column_count_s <= Column_count_s + 1;
					else
						Column_count_s <= 0;
						Row_count_s <= Row_count_s + 1;
						state_s        <= odd_row;
					end if;
			
				when odd_row =>
					if ((Column_count_s mod 2 = 0) and (Column_count_s /= Column_max) ) then
						G_level_out <= RGB_level_in;
						Column_count_s <= Column_count_s + 1;
					elsif ((Column_count_s mod 2 = 1) and (Column_count_s /= Column_max) ) then
						R_level_out <= RGB_level_in;
						Column_count_s <= Column_count_s + 1;
					else
						Column_count_s <= 0;
						Row_count_s <= Row_count_s + 1;
						state_s        <= even_row;
					end if;
			end case;
		else
			Row_count_s <= 0; --reached end of picture processing
		end if;
	end if;
  end process RGB_sorter;    
end rtl;