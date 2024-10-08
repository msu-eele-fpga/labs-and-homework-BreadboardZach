library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity show_state is
  port(clock : in std_ulogic;
       reset : in std_ulogic;
       switch_stat : in std_ulogic_vector(3 downto 0);
       LED_show : out std_ulogic_vector(6 downto 0));
end entity;

architecture show_state_arch of show_state is

signal LEDSS : std_ulogic_vector(6 downto 0) := "0000000"; --LED(4) and LED(3) are initially off

begin


    process(clock)
    begin
        if rising_edge(clock) then
            LEDSS(3 downto 0) <= switch_stat(3 downto 0);
        end if;
    end process;

	LED_show <= LEDSS;

end architecture;