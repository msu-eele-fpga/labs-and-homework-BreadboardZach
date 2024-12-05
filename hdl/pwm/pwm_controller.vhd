library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pwm_controller is
  generic (
           CLK_PERIOD : time := 20 ns
           );
  port (
        clk : in std_logic;
        rst : in std_logic;

        -- PWM repetition period in milliseconds;
        -- datatype (W.F) is individually assigned

        period : in unsigned(W_PERIOD - 1 downto 0);

        -- PWM duty cycle between [0 1]; out-of-range values are hard-limited
        -- datatype (W.F) is individually assigned

       duty_cycle : in unsigned(W_DUTY_CYCLE - 1 downto 0);
       output : out std_ulogic
       );
end entity pwm_controller;

signal LED_out : std_ulogic;
signal dutyc : unsigned;
signal prd   : unsigned;

architecture pwm_controller_arch of pwm_controller is 
begin

  if



end architecrture