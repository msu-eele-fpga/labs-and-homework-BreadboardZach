library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_down is

	generic(
		MIN : natural := 0;
		MAX : natural := 127); --7 bit counter so 128 diff numbers
		
	port(
		clock : in std_ulogic;
		reset : in std_ulogic;
		fin : out std_ulogic_vector(6 downto 0));
	

end entity;

architecture binary_down_arch of binary_down is

		begin
		
			process(clock)
				variable count : integer range MIN to MAX;
				
				begin
				
					if(reset = '1') then
						count := 127;
					elsif(rising_edge(clock)) then
						count := count - 1;
					end if;
					
					fin <= std_ulogic_vector(to_unsigned(count, fin'length));
					
				end process;

end architecture; 
