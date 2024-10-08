library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity clock_gen is
    port (
        clock   : in  std_ulogic;                      -- Input clock
        reset   : in  std_ulogic;                      -- Reset signal
        cnt   : in  unsigned(29 downto 0);           -- Counter limit for clock division
        eighth_base_rate  : out std_ulogic;          -- Eighth base rate clock
        quarter_base_rate : out std_ulogic;          -- Quarter base rate clock
        half_base_rate    : out std_ulogic;          -- Half base rate clock
        twice_base_rate   : out std_ulogic;          -- Twice base rate clock
        four_base_rate    : out std_ulogic;           -- Four times base rate clock
	     one_sec_rate      : out std_ulogic;
		  one_sec_flag      : out std_ulogic
        );
end entity;

architecture clock_gen_arch of clock_gen is

    signal one_count       : unsigned(29 downto 0) := (others => '0');
    signal half_count      : unsigned(29 downto 0) := (others => '0');
    signal quarter_count   : unsigned(29 downto 0) := (others => '0');
    signal eighth_count    : unsigned(29 downto 0) := (others => '0');
    signal twice_count     : unsigned(29 downto 0) := (others => '0');
    signal four_count      : unsigned(29 downto 0) := (others => '0');
	 
	 signal second_flg    : std_ulogic := '0';

    signal one_clk       : std_ulogic := '0'; 
    signal half_clk      : std_ulogic := '0';                
    signal quarter_clk   : std_ulogic := '0';                 
    signal eighth_clk    : std_ulogic := '0';                
    signal twice_clk     : std_ulogic := '0';                 
    signal four_clk      : std_ulogic := '0';   
                
begin


    ONE_CLK_PROC : process (clock, reset, one_clk)
    begin
        if reset = '1' then
            one_count <= (others => '0');
            one_clk <= '0';
				second_flg <= '0';
        elsif rising_edge(clock) then
            if one_count = (cnt - 1) then
                one_count <= (others => '0');
                one_clk <= not one_clk;
					 second_flg <= '1';
            else
                one_count <= one_count + 1;
					 second_flg <= '0';
            end if;
        end if;
      one_sec_rate <= one_clk;
		one_sec_flag <= second_flg;
     end process;



   
    HALF_CLK_PROC : process (clock, reset, half_clk)
    begin
        if reset = '1' then
            half_count <= (others => '0');
            half_clk <= '0';
        elsif rising_edge(clock) then
            if half_count = (shift_right(cnt, 1) - 1) then
                half_count <= (others => '0');
                half_clk <= not half_clk;
            else
                half_count <= half_count + 1;
            end if;
        end if;
      half_base_rate <= half_clk;
    end process;

    QUARTER_CLK_PROC : process (clock, reset,quarter_clk)
    begin
        if reset = '1' then
            quarter_count <= (others => '0');
            quarter_clk <= '0';
        elsif rising_edge(clock) then
            if quarter_count = (shift_right(cnt, 2) - 1) then
                quarter_count <= (others => '0');
                quarter_clk <= not quarter_clk;
            else
                quarter_count <= quarter_count + 1;
            end if;
        end if;
      quarter_base_rate <= quarter_clk;
    end process;

    EIGHTH_CLK_PROC : process (clock, reset, eighth_clk)
    begin
        if reset = '1' then
            eighth_count <= (others => '0');
            eighth_clk <= '0';
        elsif rising_edge(clock) then
            if eighth_count = (shift_right(cnt, 3) - 1) then
                eighth_count <= (others => '0');
                eighth_clk <= not eighth_clk;
            else
                eighth_count <= eighth_count + 1;
            end if;
        end if;
	eighth_base_rate <= eighth_clk;
    end process;

    TWICE_CLK_PROC : process (clock, reset, twice_clk)
    begin
        if reset = '1' then
            twice_count <= (others => '0');
            twice_clk <= '0';
        elsif rising_edge(clock) then
            if twice_count = (shift_left(cnt, 1) - 1) then
                twice_count <= (others => '0');
                twice_clk <= not twice_clk;
            else
                twice_count <= twice_count + 1;
            end if;
        end if;
      twice_base_rate <= twice_clk;
    end process;


    FOUR_CLK_PROC : process (clock, reset, four_clk)
    begin
        if reset = '1' then
            four_count <= (others => '0');
            four_clk <= '0';
        elsif rising_edge(clock) then
            if four_count = (shift_left(cnt, 2) - 1) then
                four_count <= (others => '0');
                four_clk <= not four_clk;
            else
                four_count <= four_count + 1;
            end if;
        end if;
	four_base_rate    <= four_clk;
    end process;

  
end architecture;

