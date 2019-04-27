library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- ENTITY ---------------------------------------------------------------------
-------------------------------------------------------------------------------
entity Cam_Receiver_rtl is
  port (
    -- Reset / Clock
    clk_36Mhz_in       : in  std_logic;
    rst_in             : in  std_logic;
	-- Receiver Inputs
    RGB_level_in       : in  std_logic_vector(7 downto 0);
    VSYNC_in           : in  std_logic;
	HREF_in            : in  std_logic;
    -- Receiver Outputs
    RGB_level_out      : out std_logic_vector(7 downto 0);
    --G_level_out        : out std_logic_vector(7 downto 0);
	--B_level_out        : out std_logic_vector(7 downto 0);
	Read_EN_out        : out std_logic_vector(2 downto 0)
  );
end Cam_Receiver_rtl;



-------------------------------------------------------------------------------
-- ARCHITECTURE ---------------------------------------------------------------
-------------------------------------------------------------------------------
architecture rtl of Cam_Receiver_rtl is

  ---------------------------------------------------------------------------
  --constants, types, functions
  ---------------------------------------------------------------------------
constant Column_max  : integer := 800 ;  
constant Row_max     : integer := 600 ;
  
type row_state is (
     odd_row,
     even_row
 );

  ---------------------------------------------------------------------------
  --signals
  --------------------------------------------------------------------------- 
signal Column_count_s        : integer range 0 to 800;
signal Row_count_s           : integer range 0 to 600;
signal state_s               : row_state; 

RGB_sorter : process(rst_in, clk_36Mhz_in)
begin
  if (rst_in = '1') then
    RGB_level_out    <= (others => '0'); 
      --G_level_out    <= (others => '0');
	  --B_level_out    <= (others => '0');
	 Read_EN_out    <= (others => '0');
	 Column_count_s <= 0;
	 Row_count_s    <= 0;	  
     state_s            <= even_row;
  elsif (rising_edge(clk_36mhz_in)) then
	if ((VSYNC_in = '0') and (HREF_in = '1') and (Row_count_s /= Row_max) ) then --valid picture processing 
		case state_s is 
			when even_row =>
				if ((Column_count_s mod 2 = 0) and (Column_count_s /= Column_max) ) then
					RGB_level_out <= RGB_level_in;
					Read_EN_out    <= "100";
					Column_count_s <= Column_count_s + 1;
				elsif ((Column_count_s mod 2 = 1) and (Column_count_s /= Column_max) ) then
					RGB_level_out <= RGB_level_in;
					Read_EN_out    <= "010";
					Column_count_s <= Column_count_s + 1;
				else
					Column_count_s <= 0;
					Row_count_s <= Row_count_s + 1;
					state_s        <= odd_row;
				end if;
			
			when odd_row =>
				if ((Column_count_s mod 2 = 0) and (Column_count_s /= Column_max) ) then
						--RGB_level_out <= RGB_level_in;
					Read_EN_out    <= (others => '0');
					Column_count_s <= Column_count_s + 1;
				elsif ((Column_count_s mod 2 = 1) and (Column_count_s /= Column_max) ) then
					RGB_level_out <= RGB_level_in;
					Read_EN_out    <= "001";
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
