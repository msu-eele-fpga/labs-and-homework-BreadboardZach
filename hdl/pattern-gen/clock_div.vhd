library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    port (
        clock   : in  std_ulogic;                     -- Input clock
        clk_1x  : out std_ulogic;
        clk_2x   : out std_ulogic;                     -- Twice the frequency
        clk_half : out std_ulogic;                     -- Half the frequency
        clk_quarter : out std_ulogic;                  -- Quarter the frequency
        clk_eighth : out std_ulogic                     -- Eighth the frequency
    );
end entity clock_divider;

architecture behavior of clock_divider is
    signal count : integer := 0;                      -- Counter for clock division
    signal clk_half_int : std_ulogic := '0';           -- Intermediate half clock
    signal clk_quarter_int : std_ulogic := '0';        -- Intermediate quarter clock
    signal clk_eighth_int : std_ulogic := '0';         -- Intermediate eighth clock
begin
    process(clock)
    begin
        if rising_edge(clock) then
            count <= count + 1;
	         clk_1x <= clock;

            -- Generate the half frequency clock
            if count = 1 then
                clk_half_int <= not clk_half_int; -- Toggle every 1 clock cycle
                clk_half <= clk_half_int;
            end if;

            -- Generate the quarter frequency clock
            if count = 2 then
                clk_quarter_int <= not clk_quarter_int; -- Toggle every 2 clock cycles
                clk_quarter <= clk_quarter_int;
            end if;

            -- Generate the eighth frequency clock
            if count = 4 then
                clk_eighth_int <= not clk_eighth_int; -- Toggle every 4 clock cycles
                clk_eighth <= clk_eighth_int;
            end if;

            -- Generate the twice frequency clock
            clk_2x <= not clock; -- Output is simply the inverse of the input clock
        end if;
    end process;
end architecture behavior;

