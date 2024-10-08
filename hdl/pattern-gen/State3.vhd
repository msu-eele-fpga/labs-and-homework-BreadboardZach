library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity State3 is
	port(clock : in std_ulogic;
			reset : in std_ulogic;
			LED_S3 : out std_ulogic_vector(6 downto 0));

end entity;

architecture State3_arch of State3 is

		component binary_down is --State 3 is output of down counter
			port(clock  : in std_ulogic;
			     reset  : in std_ulogic;
			     fin    : out std_ulogic_vector(6 downto 0));
		end component;
		
		begin
		
			COUNTER : binary_down port map(clock => clock,
					    	       reset => reset,
						       fin(6 downto 0) => LED_S3(6 downto 0));

end architecture; 