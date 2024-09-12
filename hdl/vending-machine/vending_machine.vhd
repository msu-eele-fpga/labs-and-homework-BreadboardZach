library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine is
  port (
    clk      : in std_ulogic;
    rst      : in std_ulogic;
    nickel   : in std_ulogic;
    dime     : in std_ulogic;
    dispense : out std_ulogic;
    amount   : out natural range 0 to 15  -- Display current collected amount (0-15)
  );
end entity vending_machine;

architecture vending_machine_arch of vending_machine is

  type state_type is (c0, c5, c10, c15);  -- States for 0, 5, 10, and 15 cents
  signal current_state : state_type;
  signal next_state : state_type;
 
begin

  -- synchronous state memory
  state_memory : process(clk, rst)
  begin
    if rst = '1' then
      current_state <= c0;  -- Reset to 0 cents
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process state_memory;

  -- combinational next state logic
  next_state_logic : process(current_state, nickel, dime)
  begin
    case current_state is
      when c0 =>
        if nickel = '1' and dime = '0' then
          next_state <= c5;  
        elsif dime = '1' and nickel = '0' then
          next_state <= c10; 
        elsif dime = '1' and nickel = '1' then
          next_state <= c10;  
        else
          next_state <= c0;   
        end if;

      when c5 =>
        if nickel = '1' and dime = '0' then
          next_state <= c10;  
        elsif dime = '1' and nickel = '0' then
          next_state <= c15;  
        elsif dime = '1' and nickel = '1' then
          next_state <= c15;  
        else
          next_state <= c5;   
        end if;

      when c10 =>
        if nickel = '1' and dime = '0' then
          next_state <= c15;  
        elsif dime = '1' and nickel = '0' then
          next_state <= c15;  
        elsif dime = '1' and nickel = '1' then
          next_state <= c15;  
        else
          next_state <= c10;  
        end if;

      when c15 =>
        next_state <= c0;  

      when others =>
        next_state <= c0;  
    end case;
  end process next_state_logic;

  -- combinational output logic
  output_logic : process(current_state, nickel, dime, amount)
  begin
    case current_state is
      when c0 =>
        dispense <= '0';
        amount <= 0;   
        
      when c5 =>
        dispense <= '0';
        amount <= 5;   
        
      when c10 =>
        dispense <= '0';
        amount <= 10;  

      when c15 =>
        dispense <= '1';   
        amount <= 15;  
        
      when others =>
        dispense <= '0';
        amount <= 0;  
    end case;
  end process output_logic;


end architecture vending_machine_arch;

