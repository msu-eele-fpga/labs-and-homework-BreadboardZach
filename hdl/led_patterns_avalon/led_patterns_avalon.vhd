library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
  port (clk : in std_ulogic;
        rst : in std_ulogic;
		  
        -- avalon memory-mapped slave interface
		  avs_read : in std_ulogic;
		  avs_write : in std_ulogic;
		  avs_address : in std_ulogic_vector(1 downto 0);
		  avs_readdata : out std_ulogic_vector(31 downto 0);
		  avs_writedata : in std_ulogic_vector(31 downto 0);
		  
		  -- external I/O; export to top-level
		  push_button : in std_ulogic;
		  switches : in std_ulogic_vector(3 downto 0);
		  led : out std_ulogic_vector(7 downto 0)
		  );
end entity led_patterns_avalon;

architecture led_patterns_avalon_arch of led_patterns_avalon is

signal boolibi            : boolean := false;

--Registers
signal HPS_LED_control_av : std_ulogic_vector(31 downto 0) := "00000000000000000000000000000000"; --First bit '0' to set as off
signal Base_Rate_av       : std_ulogic_vector(31 downto 0) := "00000000000000000000000000010000"; --"00010000"
signal LED_reg_av         : std_ulogic_vector(31 downto 0)  := "00000000000000000000000000000000"; --"00000000"




  component led_patterns is
    port(clk             : in  std_ulogic;                         
         rst             : in  std_ulogic;                         
         push_button     : in  std_ulogic;                         
         switches        : in  std_ulogic_vector(3 downto 0);      
         hps_led_control : in  boolean;                                
         base_period     : in  unsigned(7 downto 0);               
         led_reg         : in  std_ulogic_vector(7 downto 0);      
         led             : out std_ulogic_vector(7 downto 0)       
         );
  end component;

  begin
  
    bool : process(HPS_LED_control_av)
      begin
	     if (HPS_LED_control_av(0) = '0') then
		    boolibi <= false;
		  else
		    boolibi <= true;
    end if;
  end process;
  
  LED_PATTERNS_av : led_patterns port map(clk => clk,   
										        rst => rst,
										        push_button => push_button,
										        switches => switches,
										        hps_led_control => boolibi,
										        base_period => unsigned(Base_Rate_av(7 downto 0)),      --unsigned(Base_Rate_av(7) := "00010000"),
										        led_reg => LED_Reg_av(7 downto 0),                      --(LED_Reg_av(7) := "00000000"),   
										        led => led);
												  

  
  avalon_register_read : process(clk)
    begin
      if rising_edge(clk) and avs_read = '1' then
        case avs_address is
		    when "00" => avs_readdata <= HPS_LED_control_av;
		    when "01" => avs_readdata <= Base_Rate_av;
			 when "10" => avs_readdata <= LED_reg_av;
		    when others => avs_readdata <= (others =>'0'); -- return zeros for unused registers
		  end case;
		end if;
end process;


avalon_register_write : process(clk, rst)
  begin
    if rst = '1' then
      HPS_LED_control_av <= "00000000000000000000000000000000"; --First bit '0' to set as off
      Base_Rate_av       <= "00000000000000000000000000010000"; --"00010000"
      LED_reg_av         <= "00000000000000000000000000000000"; --"00000000"
		
    elsif rising_edge(clk) and avs_write = '1' then
      case avs_address is
        when "00" => HPS_LED_control_av <= avs_writedata(31 downto 0);
        when "01" => Base_Rate_av       <= avs_writedata(31 downto 0);
		  when "10" => LED_reg_av         <= avs_writedata(31 downto 0);
        when others => null;                            -- ignore writes to unused registers
      end case;
    end if;
end process;



end architecture;