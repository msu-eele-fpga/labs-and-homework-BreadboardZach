library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity debouncer is
  generic (clk_period : time := 20 ns;
           debounce_time : time
           );
  port (clk : in std_ulogic;
        rst : in std_ulogic;
        input : in std_ulogic;
        debounced : out std_ulogic
       );
end entity debouncer;

architecture debouncer_arch of debouncer is

--ignore for 120 ns
constant debounce_limit : integer := debounce_time / clk_period;
signal counter : integer := 0;
signal stable_input : std_ulogic := '0';

begin

process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        counter <= 0;
 	stable_input <= '0';
      elsif input /= stable_input then
	counter <= 0;
	stable_input <= input;

      elsif counter < debounce_limit then
          counter <= counter + 1;
      elsif counter = debounce_limit then
          debounced <= stable_input;
      end if;
    end if;

end process;


end architecture;