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
      SYS_CLKs_sec : in std_logic_vector(31 downto 0);
      base_period : in unsigned(7 downto 0);
      led_reg : in std_ulogic_vector(7 downto 0);
      led : out std_ulogic_vector(7 downto 0)
      );
end entity led_patterns;

architecture led_patters_arch of led_patterns is



  type State_Type is (S0,S1,S2,S3,S4,show_state); --state type declarations
  signal current_state,next_state : State_Type;
	
  signal LEDS0, LEDS1, LEDS2, LEDS3, LEDS4 : std_ulogic_vector(6 downto 0); --signals used in file
  signal push : std_logic;
	
  signal LED_disp : std_logic;
	
  signal clockdiv1 : std_logic;
  signal clockdiv2 : std_logic;
  signal clockdiv4 : std_logic;
  signal clockdiv8 : std_logic;
  signal clock2 : std_logic;
  signal Base1  : unsigned(7 downto 0);
  signal Base2  : unsigned(7 downto 0); 
  signal Base14 : unsigned(7 downto 0); 
  signal Base18 : unsigned(7 downto 0); 
  signal base12 : unsigned(7 downto 0); 
	
  component clock_gen is --Component sections
	port(clk	: in std_logic;
	     SYS_CLKs_sec : in std_logic_vector(31 downto 0);
	     base_period	: in std_logic_vector(7 downto 0);
	     clock_o : out std_logic);
  end component;
	
  component async_conditioner is
	port(clock  :  in std_logic;	
	     aysnc : in std_logic;
	     sync : out std_logic);
  end component;
	
  component LED_7 is
	port(clock : in std_logic;
	     LED : out std_logic);
  end component;
	
  component State0 is
	port(clock : in std_logic;
	     reset	: in std_logic;
	     LED_S0 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State1 is
	port(clock : in std_logic;
	     reset	: in std_logic;
	     LED_S1 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State2 is
	port(clock : in std_logic;
	     reset	: in std_logic;
	     LED_S2 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State3 is
	port(clock : in std_logic;
	     reset	: in std_logic;
	     LED_S3 : out std_ulogic_vector(6 downto 0));
  end component;
	
  component State4 is
	port(clock : in std_logic;
	     reset	: in std_logic;
	     LED_S4 : out std_ulogic_vector(6 downto 0));
  end component;
	

begin

  LED7_BLINK : LED_7 port map(clock => clockdiv1,
			                     LED   => LED(7)
			      );

  --Base2 <= "0" & std_logic_vector(base_period(7 downto 1));   --dividing by 2 is the same as a shift  right
  --Base12 <= std_logic_vector(base_period(6 downto 0)) & "0";  --multiplying by 2 is the same as a shift left
  --Base14 <= std_logic_vector(base_period(5 downto 0)) & "00";
  --Base18 <= std_logic_vector(base_period(4 downto 0)) & "000";
  
  Base2 <= shift_right(base_period, 1);   --dividing by 2 is the same as a shift  right
  Base12 <= shift_left(base_period, 1); 
  Base14 <= shift_left(base_period, 2);
  Base18 <= shift_left(base_period, 3);

	
  CLK_G_12 : clock_gen port map(clk => clk, --create clocks for baserate, baserate *2, baserate*1/2, baserate*1/4,baserate*1/8
				SYS_CLKs_sec => SYS_CLKs_sec,
				base_period => std_logic_vector(Base12),
				clock_o => clockdiv2);
	
  CLK_G_1 : clock_gen port map(clk => clk,
			       SYS_CLKs_sec => SYS_CLKs_sec,
			       base_period => std_logic_vector(Base1),
			       clock_o => clockdiv1);
					
  CLK_G_2 : clock_gen port map(clk => clk,
			       SYS_CLKs_sec => SYS_CLKs_sec,
				base_period => std_logic_vector(Base2),
				clock_o => clock2);

  CLK_G_14 : clock_gen port map(clk => clk,
				SYS_CLKs_sec => SYS_CLKs_sec,
				base_period => std_logic_vector(Base14),
				clock_o => clockdiv4);

  CLK_G_18 : clock_gen port map(clk => clk,
				SYS_CLKs_sec => SYS_CLKs_sec,
				base_period => std_logic_vector(Base18),
				clock_o => clockdiv8);
				
--create states
  state00 : State0 port map(clock => clockdiv2,  --state one is baserate*1/2
			Reset => rst,
			LED_S0 => LEDS0);
						
  state01 : State1 port map(clock => clockdiv4,	--state two is baserate*1/4
			Reset => rst,
			LED_S1 => LEDS1);
							
  state02 : State2 port map(clock => clock2, --state 2 is baserate*2
			Reset => rst,
			LED_S2 => LEDS2);
							
  state03 : State3 port map(clock => clockdiv8, --state 3 is baserate*1/8
			Reset => rst,
			LED_S3 => LEDS3);

  state04 : State4 port map(clock => clockdiv1, --state 4 i decided is baserate
			Reset => rst,
			LED_S4 => LEDS4);
							
  PUSHB : async_conditioner port map (clock => clk, --conditions the input 				   
			              aysnc => push_button, 
				      sync => push);
											
  LED_D : process(clk,push) --sets flag if we display what the switches are set as
	variable counter : integer := 0;
	  begin
		if(push = '0') then
			
			LED_disp <= '1';
			counter := 0;
				
		elsif(rising_edge(clk)) then
			
			if(counter = 50000000) then --counter to 50000000 is equal to 1s
				
				counter := 0;
				LED_disp <= '0';
					
			else
				
				counter := counter + 1;
					
			end if;
		end if;
	end process;

		
  STATE_MEMORY : process(clk,rst) --state machine for the LED patterns
	begin
		if(rst = '0') then
				
			current_state <= current_state;
				
		elsif(rising_edge(clk)) then
			
			current_state <= next_state;
				
		end if;
	end process;

  STATE_LOGIC : process(current_state,push,switches)
	begin
			
		if(push = '0') then
			case(switches) is
				when "0000" => next_state <= S0;
				when "0001" => next_state <= S1;
				when "0010" => next_state <= S2;
				when "0011" => next_state <= S3;
				when "0100" => next_state <= S4;
				when others => next_state <= current_state;
			end case;
		end if;
	end process;
	
  OUTPUT_LOGIC : process (current_state)
	
	begin
		if(hps_led_control = true) then --software mode 
			
			led(6 downto 0) <= led_reg(6 downto 0);
				
		elsif(LED_disp = '0') then --hardware mode (switches control)
				
			case(current_state) is
				when S0 => led(6 downto 0) <= LEDS0;
				when S1 => led(6 downto 0) <= LEDS1;
				when S2 => led(6 downto 0) <= LEDS2;
				when S3 => led(6 downto 0) <= LEDS3;
				when S4 => led(6 downto 0) <= LEDS4;
				when others => LED(6 downto 0) <= LEDS0;
			end case;
		else --display switches
			LED(6 downto 0) <= "000" & switches;
		end if;
	end process;
	
		
end architecture; 