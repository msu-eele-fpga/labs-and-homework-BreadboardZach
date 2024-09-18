library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
  port (
    clk   : in    std_ulogic;
    async : in    std_ulogic;
    sync  : out   std_ulogic
    );
end entity synchronizer;

architecture synchronizer_arch of synchronizer is

signal middleman : std_ulogic;

  begin

process(clk)
begin
  if rising_edge(clk) then 
    middleman <= async;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then 
     sync <= middleman;
  end if;
end process;

end architecture;