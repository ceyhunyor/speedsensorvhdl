----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2019 19:22:37
-- Design Name: 
-- Module Name: bcdconv - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcdconv is
    Port (B : out STD_LOGIC_VECTOR(12 downto 0);
          ckc : in std_logic;
          spd : in STD_LOGIC_VECTOR(9 downto 0));
end bcdconv;

architecture Behavioral of bcdconv is
-- Tamamlanmýþ bir modül
begin
process(spd,ckc)
variable bir ,ons , yuz, bin : integer;
variable birk ,onsk , yuzk : std_logic_vector(3 downto 0);
variable bink : std_logic_vector(0 downto 0);
variable stp: integer;
variable car: std_logic_vector(12 downto 0);
begin
if rising_edge(ckc) then
    stp := to_integer(unsigned(spd));
    bir := stp mod 10;
    birk := std_logic_vector(to_unsigned(bir,4));
    ons := (stp mod 100) / 10;
    onsk := std_logic_vector(to_unsigned(ons,4));
    yuz := (stp mod 1000) / 100;
    yuzk := std_logic_vector(to_unsigned(yuz,4));
    bin := stp / 1000;
    bink := std_logic_vector(to_unsigned(bin,1));
    car := bink & yuzk & onsk & birk;
    B <= car;
end if;
end process;
end Behavioral;
