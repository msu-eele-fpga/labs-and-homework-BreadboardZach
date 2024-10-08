library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.assert_pkg.all;
--use work.print_pkg.all;
--use work.tb_pkg.all;

entity one_pulse is
port (
clk : in std_ulogic;
rst : in std_ulogic;
input : in std_ulogic;
pulse : out std_ulogic
  );
end entity;

architecture one_pulse_arch of one_pulse is
  type state_type is (waitt, highh, loww); 
  signal current_state : state_type;
  signal next_state : state_type;

 
begin

  state_memory : process(clk, rst)
  begin
    if rst = '1' then
      current_state <= waitt;  
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process state_memory;

  next_state_logic : process(current_state, input)
  begin
    case current_state is
      when waitt =>
        if input = '1' then
          next_state <= highh;  
        else
          next_state <= waitt;   
        end if;

      when highh =>
        if input = '1' then
          next_state <= loww; 
        else
          next_state <= highh;   
        end if;

      when loww =>
        if input = '1' then
          next_state <= loww;     
        else
          next_state <= waitt;  
        end if;

      when others =>
        next_state <= waitt;  
    end case;
  end process next_state_logic;

 
  output_logic : process(current_state) --changed from (current_state, pulse)
  begin
    case current_state is
      when waitt =>
        pulse <= '0';   
        
      when highh =>
        pulse <= '1'; 

      when loww =>
        pulse <= '0';  
        
      when others =>
        pulse <= '0'; 
    end case;
  end process output_logic;


end architecture;