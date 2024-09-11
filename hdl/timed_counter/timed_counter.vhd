library ieee;
use ieee.std_logic_1164.all;

entity timed_counter is
    generic (
      clk_period : time;
      count_time : time
      );

    port (
      clk    : in  std_ulogic;
      enable : in  boolean;
      done   : out boolean
      );
end entity timed_counter;


architecture timed_counter_arch of timed_counter is

constant timer_limit : integer range 0 to 16 := count_time / clk_period;
signal   n           : integer := 0;

  begin

process(clk)
begin

  if rising_edge(clk) then
    if enable = true then
      if (n = timer_limit) then 
        n <= 0;
        done <= true;
      else
        n <= n + 1;
        done <= false;
      end if;
    else
      done <= false;
    end if;
  end if;
end process;

  
end architecture;