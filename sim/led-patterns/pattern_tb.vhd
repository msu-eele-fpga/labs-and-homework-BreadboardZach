library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity pattern_tb is 
end entity;

architecture testbench of pattern_tb is
component State0 is
    port (
        clock   : in std_ulogic;
        reset : in std_ulogic;
        LED_S0 : out std_ulogic_vector(6 downto 0)
    );
end component;

signal clk_tb: std_ulogic:='0';
signal rst_tb: std_ulogic:='0';
signal led_out: std_ulogic_vector(6 downto 0):="0000000";


begin
    
clk_tb <= not clk_tb after CLK_PERIOD / 2;

dut: State0
    port map (
        clock   => clk_tb,
        reset => rst_tb,
        LED_S0=>led_out
    );


end architecture;