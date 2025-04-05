----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2019 18:26:45
-- Design Name: 
-- Module Name: receiver - Behavioral
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

entity receiver is
    Port ( rcvd,ckc : in STD_LOGIC;
           trog, syn : out STD_LOGIC;
           dis : out STD_LOGIC_VECTOR (12 downto 0));
end receiver;

architecture Behavioral of receiver is
signal timer: integer := 0;
begin
process(ckc)
    variable counter1,counter2: integer:=0;
    variable wat :std_logic:='1';
  begin
    if rising_edge(ckc) then
        counter1 := counter1 + 1;
        if(counter1=0) then
            trog <= '1';
        elsif(counter1=1100) then
            trog <= '0';
            wat := '1';
        elsif(counter1=29999999) then
            syn <= '1';
        elsif(counter1=30000000) then
            counter1 := 0;
            trog <= '1';
            syn <= '0';
        end if;
        
        if(rcvd = '1') and (counter2 < 3800000) then
            counter2 := counter2 + 1;
        elsif(rcvd = '0' and wat='1' ) then
            timer <= counter2;
--            dis <= std_logic_vector( to_unsigned((counter2 / 5800) , 10));
            counter2 := 0;
            wat := '0';
        end if;
    end if;
dis <= std_logic_vector( to_unsigned((timer / 1740) , 13));
end process ;

end Behavioral;
