library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED_7 is
	port(clock : in std_ulogic;
	     LED : out std_ulogic);
end entity;

architecture LED_7_arch of LED_7 is

	signal onoff : std_ulogic := '0';
	
	begin
	
	process(clock)
		begin
		  if(rising_edge(clock)) then
				onoff <= not onoff;  --every clock we toggle LED(7)
					
			end if;
			
		end process;
		
		LED <= onoff;
		
end architecture;
