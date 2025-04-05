----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2019 19:48:48
-- Design Name: 
-- Module Name: vga - Behavioral
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

entity vga is
    Port ( ckc ,cam : in STD_LOGIC;
           hsy , vsy : out STD_LOGIC;
           bs , bu : in std_logic_vector(12 downto 0); --bu
           P : out STD_LOGIC_vector(11 downto 0));
end vga;

architecture Behavioral of vga is
type vram is array (0 to 127) of std_logic_vector(7 downto 0);
signal acc : vram;
signal dclk: std_logic;
signal muxer: unsigned(2 downto 0);
 constant r0: STD_LOGIC_vector(79 downto 0) := "01111100011111001111111000111000111111100000110001111100011111000001100001111100";
 constant r1: STD_LOGIC_vector(79 downto 0) := "11000110110001101100011001100000110000000001110011000110110001100011100011000110";
 constant r2: STD_LOGIC_vector(79 downto 0) := "11000110110001100000011011000000110000000011110000000110000001100111100011000110";
 constant r3: STD_LOGIC_vector(79 downto 0) := "11000110110001100000011011000000110000000110110000000110000011000001100011001110";
 constant r4: STD_LOGIC_vector(79 downto 0) := "01111110011111000000110011111100111111001100110001111100000110000001100011011110";
 constant r5: STD_LOGIC_vector(79 downto 0) := "00000110110001100001100011000110000001101111111000000110001100000001100011110110";
 constant r6: STD_LOGIC_vector(79 downto 0) := "00000110110001100011000011000110000001100000110000000110011000000001100011100110";
 constant r7: STD_LOGIC_vector(79 downto 0) := "00000110110001100011000011000110000001100000110000000110110000000001100011000110";
 constant r8: STD_LOGIC_vector(79 downto 0) := "00001100110001100011000011000110110001100000110011000110110001100001100011000110";
 constant r9: STD_LOGIC_vector(79 downto 0) := "01111000011111000011000001111100011111000001111001111100111111100111111001111100";
begin

clk_divider : process(ckc)
    variable clcoun : unsigned(23 downto 0);
    begin
    if clcoun = "11111111111111111111111" then
        clcoun := "000000000000000000000000";
    elsif rising_edge(ckc) then
        clcoun := clcoun + 1;
    end if;
    muxer <= clcoun(22 downto 20);
    dclk <= clcoun(1);
end process;

maindis : process(dclk)
    variable dcounter : integer range 0 to 416800;
    variable liner: integer range 0 to 17 := 0;
    variable hcou ,columner, vcou , conv ,contcolu: integer;
    variable vsync, hsync, incdis, hdis, vdis: std_logic;
    begin
    if rising_edge(dclk) then
        hcou := (dcounter mod 800);
        vcou := (dcounter / 800);
        if vcou < 2 then
            vsync := '0';
            incdis := '0';
        elsif vcou < 31 then
            vsync := '1';
            incdis := '0';
        elsif (vcou >= 63) then
            vsync := '1';
            liner := 0;
            incdis := '0';
        elsif (vcou >= 31) then
            vsync := '1';
            liner := vcou - 31;
            incdis := '1';
        else
            vsync := '1';
            incdis := '0';
        end if;
        if hcou < 96 then
            hsync := '0';
            hdis := '0';
            columner := 0;
        elsif (hcou >= 144) and (hcou < 176)  then --elsif (hcou >= 144) and (hcou < 177)  then
            hsync := '1';
            hdis := '1';
            columner := 175- hcou;
            contcolu := hcou-144;
        else
            hsync := '1';
            hdis := '0';
            columner := 0;
        end if;
        if hdis = '1' and incdis = '1' then
            conv := (liner*4) + (contcolu / 8);
            vdis := acc(conv)(7-(contcolu mod 8));
--            vdis := '1';
--            if ((liner +columner) mod 2) = 1 then
--                vdis := '1';
--            else
--                vdis:= '0';
--            end if;
            if vdis = '1' then
                P <= "111110110000";
            else
                P <= "000000000000";
            end if;
        else
            P <= "000000000000";
        end if;
        dcounter := dcounter + 1;
        hsy <= hsync;
        vsy <= vsync;
        if dcounter = 416800 then
            dcounter:= 0;
        end if;
    end if;
    end process;

loader: process(muxer, dclk)
variable mux, ind: integer range 0 to 3;
variable num,temp,numu: integer;
begin
if rising_edge(dclk) then
    if muxer = "000" then
        if bs(12) = '1' then
            num:= 1;
        else
            num := 0;
        end if;
    elsif muxer < "100" then
        temp := 12- (4 * to_integer(muxer));
        num := to_integer(unsigned(bs((temp+3) downto temp)));
    elsif muxer = "000" then
        if bu(12) = '1' then
            num:= 1;
        else
            num := 0;
        end if;
    elsif muxer <= "111" then
        temp := 12- (4 * to_integer(muxer));
        num := to_integer(unsigned(bu((temp+3) downto temp)));
    else
        num := 0;
    end if;
    if muxer < 4 then
        ind := 0;
        mux:= to_integer(muxer) ;
    else 
        ind:= 1;
        mux:= to_integer(muxer) -4;
    end if;
    numu := num *8;
    acc((ind *64) + mux + 8)  <= r0((7+numu) downto numu);
    acc((ind *64) + mux + 12) <= r1((7+numu) downto numu);
    acc((ind *64) + mux + 16) <= r2((7+numu) downto numu);
    acc((ind *64) + mux + 20) <= r3((7+numu) downto numu);
    acc((ind *64) + mux + 24) <= r4((7+numu) downto numu);
    acc((ind *64) + mux + 28) <= r5((7+numu) downto numu);
    acc((ind *64) + mux + 32) <= r6((7+numu) downto numu);
    acc((ind *64) + mux + 36) <= r7((7+numu) downto numu);
    acc((ind *64) + mux + 40) <= r8((7+numu) downto numu);
    acc((ind *64) + mux + 48) <= r9((7+numu) downto numu);
    if cam = '1' then
        acc(57) <= "00001111";
        acc(58) <= "11110000";
        acc(61) <= "00001111";
        acc(62) <= "11110000";
    else
        acc(57) <= "00000000";
        acc(58) <= "00000000";
        acc(61) <= "00000000";
        acc(62) <= "00000000";
    end if;
end if;
end process;
--acc(0) <= "10101011";
--acc(5) <= "10101011";
--acc(125) <= "10101011";
--acc(127) <= "10101011";
end Behavioral;
