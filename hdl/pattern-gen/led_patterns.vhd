library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity led_patterns is
generic (system_clock_period : time := 20 ns
         );
port (clk : in std_ulogic;
      rst : in std_ulogic;
      push_button : in std_ulogic;
      switches : in std_ulogic_vector(3 downto 0);
      hps_led_control : in boolean;
      base_period : in unsigned(7 downto 0);
      led_reg : in std_ulogic_vector(7 downto 0);
      led : out std_ulogic_vector(7 downto 0)
      );
end entity led_patterns;

architecture led_patterns_arch of led_patterns is

-- constant N_BITS_SYS_CLK_FREQ: natural:=ceil(log2(1 sec/ SYSTEM_CLK_PERIOD)); only use this if you have the math library otherwise 

  constant SYS_CLK_FREQ: unsigned(25 downto 0):= (to_unsigned((1 sec / system_clock_period), 26)); 
  constant N_BITS_CLK_CYCLES_FULL: natural :=34; --26+8 or N_BITS_SYS_CLK_FREQ +8
  constant N_BITS_CLK_CYCLES: natural :=30; --26+4 or N_BITS_SYS_CLK_FREQ +4

  signal period_base_clk_full_prec:  unsigned(N_BITS_CLK_CYCLES_FULL-1 downto 0);
  signal period_base_clk: unsigned(N_BITS_CLK_CYCLES-1 downto 0);

  type State_Type is (S0,S1,S2,S3,S4,show_states); --state type declarations
  signal current_state, next_state, prev_state : State_Type;
	
  signal LEDS0, LEDS1, LEDS2, LEDS3, LEDS4, LEDSH : std_ulogic_vector(6 downto 0); 


  signal clockdiv1_sec : std_ulogic;
  signal clockdiv2 : std_ulogic;
  signal clockdiv4 : std_ulogic;
  signal clockdiv8 : std_ulogic;
  signal clock2 : std_ulogic;
  signal clock4 : std_ulogic;
  

  signal sec_flg : std_ulogic := '0';
  
  signal sec_clk_enable : boolean := false;
  signal sec_clk_done : boolean := false;
	

  component clock_gen is --Component sections
    port (clock   : in  std_ulogic;                      -- Input clock
          reset   : in  std_ulogic;                      -- Reset signal
          cnt   : in  unsigned(29 downto 0);           -- Counter limit for clock division
          eighth_base_rate  : out std_ulogic;          -- Eighth base rate clock
          quarter_base_rate : out std_ulogic;          -- Quarter base rate clock
          half_base_rate    : out std_ulogic;          -- Half base rate clock
          twice_base_rate   : out std_ulogic;          -- Twice base rate clock
          four_base_rate    : out std_ulogic;	       -- Four times base rate clock
          one_sec_rate      : out std_ulogic;           -- One times base rate clock
			 one_sec_flag      : out std_ulogic 
           );
  end component;
	
component timed_counter is
    generic (
      clk_period : time;
      count_time : time
      );

    port (
      clk    : in  std_ulogic;
      enable : in  boolean;
      done   : out boolean
      );
end component;
	
	
  component LED_7 is
	port(clock : in std_ulogic;
	     LED : out std_ulogic);
  end component;
	
  component State0 is
	port(clock : in std_ulogic;
	     reset	: in std_ulogic;
	     LED_S0 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State1 is
	port(clock : in std_ulogic;
	     reset	: in std_ulogic;
	     LED_S1 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State2 is
	port(clock : in std_ulogic;
	     reset	: in std_ulogic;
	     LED_S2 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State3 is
	port(clock : in std_ulogic;
	     reset	: in std_ulogic;
	     LED_S3 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State4 is
	port(clock : in std_ulogic;
	     reset	: in std_ulogic;
	     LED_S4 : out std_ulogic_vector(6 downto 0));
  end component;


  component show_state is
	port(clock : in std_ulogic;
	     reset : in std_ulogic;
	     switch_stat : std_ulogic_vector(3 downto 0);
	     LED_show : out std_ulogic_vector(6 downto 0));
  end component;





begin

period_base_clk_full_prec<= SYS_CLK_FREQ*base_period;

--get rid of the fractional bits of SYS_CLK_FREQ * base_period so we have an int nmber of clock cycles for one second
period_base_clk<= period_base_clk_full_prec(N_BITS_CLK_CYCLES_FULL-1 downto 4);--use for counters


  
  CLK_G : clock_gen port map(clock => clk, --create clocks for baserate, baserate *2, baserate*1/2, baserate*1/4,baserate*1/8
				reset => rst,
				cnt => period_base_clk,
				eighth_base_rate => clockdiv8,
				quarter_base_rate => clockdiv4,
				half_base_rate => clockdiv2,
				twice_base_rate => clock2,
				four_base_rate => clock4,
				one_sec_rate => clockdiv1_sec,
				one_sec_flag => sec_flg);

  Sec_Cnt : timed_counter generic map(
      clk_period => 20 ns,
      count_time => 1 sec
		)
		port map(
      clk        => clk,
      enable     => sec_clk_enable,
      done       => sec_clk_done
      );
		
				
				
  LED7_BLINK : LED_7 port map(clock => clockdiv2,  --changed from period_base_clk
			      led   => led(7)
			      );
					
--create states
  S00 : State0 port map(clock => clockdiv2, --clockdiv2,  --state one is baserate*1/2
			Reset => rst,
			LED_S0 => LEDS0);
						
  S01 : State1 port map(clock => clockdiv4, --clockdiv4,	--state two is baserate*1/4
			Reset => rst,
			LED_S1 => LEDS1);
							
  S02 : State2 port map(clock => clock2, --clock2, --state 2 is baserate*2
			Reset => rst,
			LED_S2 => LEDS2);
							
  S03 : State3 port map(clock => clockdiv8, --clockdiv8, --state 3 is baserate*1/8
			Reset => rst,
			LED_S3 => LEDS3);

  S04 : State4 port map(clock => clockdiv8, --clockdiv1_sec, --state 4 i decided is baserate
			Reset => rst,
			LED_S4 => LEDS4);
 
  Show : show_state port map(clock => clockdiv1_sec,
			          reset => rst,
				       switch_stat => switches,
				       LED_show => LEDSH);
			
											
		
  STATE_MEMORY : process(clk) --state machine for the LED patterns
    begin
        if rising_edge(clk) then
            if(rst='1')then
                
            elsif hps_led_control then
                
            elsif(hps_led_control = false) then 
                
                current_state<=next_state;
					 
            end if;
        end if;
    end process;

  NEXT_STATE_LOGIC : process(current_state, prev_state, push_button, switches)
	begin
			
		if(push_button = '1') then
		  next_state <= show_states;
		  
		  
	   else
		  if (sec_clk_done = true) then
			case(switches) is
				when "0000" => next_state <= S0;
				when "0001" => next_state <= S1;
				when "0010" => next_state <= S2;
				when "0011" => next_state <= S3;
				when "0100" => next_state <= S4;
				when others => next_state <= prev_state;
			end case;
            
	end if;			
		end if;
		
	end process;
	
OUTPUT_LOGIC : process (current_state, switches)
begin

     case current_state is
        when show_states => led(3 downto 0)<=switches;
                            led(6 downto 4)<="000";
									 sec_clk_enable <= true;
									 
        when S0 =>   led(6 downto 0)  <=LEDS0;
                            sec_clk_enable <= false;
									 prev_state <= current_state;
									 
        when S1 =>   led(6 downto 0)  <=LEDS1;
                            sec_clk_enable <= false;
									 prev_state <= current_state;
									 
        when S2 =>   led(6 downto 0)  <=LEDS2;
                            sec_clk_enable <= false;
									 prev_state <= current_state;
									 
        when S3 =>   led(6 downto 0)  <=LEDS3;
                          sec_clk_enable <= false;
								  prev_state <= current_state;
								  
        when S4 =>   led(6 downto 0)  <=LEDS4;
                          sec_clk_enable <= false;
								  prev_state <= current_state;
        when others => null;
    end case;
   
end process;
end architecture; 