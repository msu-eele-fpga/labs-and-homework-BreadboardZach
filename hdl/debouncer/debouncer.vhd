library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.assert_pkg.all;
--use work.print_pkg.all;
--use work.tb_pkg.all;

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

constant debounce_limit : integer := debounce_time / clk_period;
signal counter : integer := 0;
signal prv_input : std_ulogic := '0';
signal enable : boolean;

begin

process(clk)
  begin

  if (rst = '1') then
    counter <= 0;
    debounced <= '0';
    enable <= true;

    elsif rising_edge(clk) then
	prv_input <= input;
      if enable then
        if (input = '1' and prv_input = '0') then
          debounced <= '1';
          enable <= false;
        elsif (input = '0' and prv_input = '1') then
          debounced <= '0';
          enable <= false;
        end if;
      else --(enable = false) then
        if (counter = debounce_limit - 2) then
          counter <= 0;
          enable <= true;
        else
          counter <= counter + 1; 

        end if;
      end if;
    end if;

end process;


end architecture;
