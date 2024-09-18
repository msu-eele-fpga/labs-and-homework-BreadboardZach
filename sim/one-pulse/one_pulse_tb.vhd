library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity one_pulse_tb is
end entity one_pulse_tb;

architecture sim of one_pulse_tb is

  -- Component declaration for the one_pulse entity
  component one_pulse
    port (
      clk   : in std_ulogic;
      rst   : in std_ulogic;
      input : in std_ulogic;
      pulse : out std_ulogic
    );
  end component;

  -- Signal declarations for testbench
  signal clk   : std_ulogic := '0';
  signal rst   : std_ulogic := '0';
  signal input : std_ulogic := '0';
  signal pulse : std_ulogic;

  -- Clock period
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: one_pulse
    port map (
      clk   => clk,
      rst   => rst,
      input => input,
      pulse => pulse
    );

  -- Clock generation process
  clk_process : process
  begin
    while True loop
      clk <= not clk;
      wait for clk_period / 2;
    end loop;
  end process clk_process;

  -- Stimulus process
  stimulus_process : process
  begin
    -- Apply reset
    rst <= '1';
    wait for clk_period * 2;
    rst <= '0';
    wait for clk_period;

    -- Apply test vectors
    input <= '0';
    wait for clk_period * 2;

    -- Test 1: input goes high
    input <= '1';
    wait for clk_period * 4;
    input <= '0';
    wait for clk_period * 2;

    -- Test 2: input goes high again
    input <= '1';
    wait for clk_period * 4;
    input <= '0';
    wait for clk_period * 2;

    -- Test 3: input remains low
    input <= '0';
    wait for clk_period * 4;

    -- Test 4: input goes high and stays high
    input <= '1';
    wait for clk_period * 4;
    input <= '0';
    wait for clk_period * 2;

    -- Finish simulation
    wait;
  end process stimulus_process;

end architecture;
