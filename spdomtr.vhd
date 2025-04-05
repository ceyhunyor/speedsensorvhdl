----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2019 21:40:21
-- Design Name: 
-- Module Name: spdomtr - Behavioral
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

entity spdomtr is
    Port ( ckc , syn : in STD_LOGIC;
           cam : out STD_LOGIC;
           usr : in STD_LOGIC_VECTOR(9 downto 0);
           dis : in STD_LOGIC_VECTOR(12 downto 0);
           sped : out STD_LOGIC_VECTOR(9 downto 0));
end spdomtr;

architecture Behavioral of spdomtr is
signal spur: std_logic_vector(9 downto 0);
begin
process(ckc,usr,dis,syn)
   variable reg1, reg2, reg3, reg4, reg5, reg6, spd : integer; --unsigned(9 downto 0);
--   variable delta: std_logic_vector(9 downto 0);
--    variable B : std_logic;
--    variable spd : unsigned(13 downto 0);
    begin
    if falling_edge(ckc)then
        if syn = '1' then
            reg6 := reg5;
            reg5 := reg4;
            reg4 := reg3;
            reg3 := reg2;
            reg2 := reg1;
            reg1 := to_integer(unsigned(dis));
--            counter := 0;
         end if;
        if reg2 > reg1 then
            spd:= reg2 -reg1;
        else
            spd:= reg1 -reg2;
        end if;
--        if reg3 - (4*reg2) + ( 3*reg1 ) > 0 then
--            spd := (reg3 -(4 * reg2) + (3 * reg1 ));
--        else
--            spd := (-reg3 + (4 * reg2) - (3 * reg1 ));
--        end if;
--        if spd < "1000000000" then
--            delta := std_logic_vector(spd);
--        elsif spd >= "1000000000" then
--            delta := "1111111111";
--        end if;
--        sped <= delta(8 downto 0) & '0';
        spur <= std_logic_vector(to_unsigned(spd,10));
    end if;
    if unsigned(usr) > (spd * 2) then
        cam <= '0';
    else
        cam <= '1';
    end if;
end process;
sped <= spur;
end Behavioral;
