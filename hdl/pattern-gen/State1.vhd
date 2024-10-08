library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity State1 is
	port(clock : in std_ulogic;
			reset : in std_ulogic;
			LED_S1 : out std_ulogic_vector(6 downto 0));

end entity;

architecture State1_arch of State1 is

		signal LEDS : std_ulogic_vector(6 downto 0) := "0011000"; --LED(4) and LED(3) are initially on
		
		begin
		
		LEFTSFT2 : process(clock, reset) --this process shifts the two on leds to the left
			begin
				if(reset = '1') then
				
					LEDS <= "0011000";
					
				elsif(rising_edge(clock)) then
				
					LEDS(1) <= LEDS(0);
					LEDS(2) <= LEDS(1);
					LEDS(3) <= LEDS(2);
					LEDS(4) <= LEDS(3);
					LEDS(5) <= LEDS(4);
					LEDS(6) <= LEDS(5);
					LEDS(0) <= LEDS(6);
					
				end if;
				
			end process;

			LED_S1 <= LEDS;
			
end architecture; 
