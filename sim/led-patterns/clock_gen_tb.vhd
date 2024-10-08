library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity clock_gen_tb is
end entity;

architecture tb of clock_gen_tb is
component clock_gen is
    port (
        clock  : in std_ulogic;
        reset  : in std_ulogic;
        cnt    : in unsigned(29 downto 0);
        eighth_base_rate:out std_ulogic;
        quarter_base_rate: out std_ulogic;
        half_base_rate: out std_ulogic;
        twice_base_rate: out std_ulogic;
        four_base_rate: out std_ulogic
    );
end component;


    signal clk_tb: std_ulogic:='0';
    signal rst_tb: std_ulogic:='0';
    signal cnt_tb: unsigned(29 downto 0):=to_unsigned(16, 30);
    signal eighth_tb: std_ulogic;
    signal quarter_tb: std_ulogic;
    signal half_tb: std_ulogic;
    signal twice_tb: std_ulogic;
    signal four_tb: std_ulogic;
    constant CLK_PERIOD : time := 20 ns;

begin
    dut: clock_gen
        port map (
            clock   => clk_tb,
            reset => rst_tb,
            cnt=>cnt_tb,
            eighth_base_rate=>eighth_tb,
            quarter_base_rate=>quarter_tb,
            half_base_rate=>half_tb,
            twice_base_rate=>twice_tb,
            four_base_rate=>four_tb
        );

process
    begin
        rst_tb <= '1';  -- Assert reset
        wait for 100 ns;
        rst_tb <= '0';  -- Deassert reset
        wait;
    end process;

    clk_tb <= not clk_tb after CLK_PERIOD / 2;
    

end architecture;
