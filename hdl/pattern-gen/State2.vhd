library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity State2 is
	port(clock : in std_ulogic;
			reset : in std_ulogic;
			LED_S2 : out std_ulogic_vector(6 downto 0));

end entity;

architecture State2_arch of State2 is

		component binary_up is  --State2 is just the output of an up counter
			port(clock : in std_logic;
			     reset : in std_logic;
			     fin   : out std_ulogic_vector(6 downto 0));
		end component;
		
		begin
		
			COUNTER : binary_up port map(clock => clock,
						     reset => reset,
						     fin(6 downto 0) => LED_S2(6 downto 0));
												

end architecture; 
