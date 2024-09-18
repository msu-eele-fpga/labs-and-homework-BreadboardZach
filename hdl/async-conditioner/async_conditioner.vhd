library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner is
port (clk : in std_ulogic;
      rst : in std_ulogic;
      aysnc : in std_ulogic;
      sync : out std_ulogic
     );
end entity async_conditioner;

architecture async_conditioner_arch of async_conditioner is

component synchronizer is
  port (
    clk   : in    std_ulogic;
    async : in    std_ulogic;
    sync  : out   std_ulogic
    );
end component synchronizer;

component debouncer is
generic (clk_period : time := 20 ns;
         debounce_time : time
        );
port (clk : in std_ulogic;
      rst : in std_ulogic;
      input : in std_ulogic;
      debounced : out std_ulogic
      );
end component debouncer;

component one_pulse is
port (clk : in std_ulogic;
      rst : in std_ulogic;
      input : in std_ulogic;
      pulse : out std_ulogic
     );
end component;


  signal sync_signal : std_logic;
  signal debounced_signal : std_logic;
  signal pulse_signal : std_logic;

begin

  sync_inst : synchronizer
    port map (clk   => clk,
              async => aysnc,
              sync  => sync_signal
              );

  debounce_inst : debouncer
    generic map (clk_period    => 20 ns,
                 debounce_time => 20 ns
                 )
    port map (clk      => clk,
              rst      => rst,
              input    => sync_signal,
              debounced => debounced_signal
             );


  one_pulse_inst : one_pulse
    port map (clk   => clk,
              rst   => rst,
              input => debounced_signal,
              pulse => sync
             );


end architecture;