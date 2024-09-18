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
end entity debouncer

architecture debouncer_arch of debouncer is

begin

constant cycles : integer := debounce_time / clk_period;
constant z : integre := in range of 0 to 22 := 0;


process(clk)
begin

  if rising_edge(clk) then
    if input = 1 then
  



end architecture;