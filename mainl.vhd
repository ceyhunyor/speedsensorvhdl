----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2019 18:25:18
-- Design Name: 
-- Module Name: mainl - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mainl is
    Port ( clk,conrec : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(9 downto 0);
           led : out STD_LOGIC_VECTOR(12 downto 0); --(12 downto 0)
           vgaRed, vgaBlue, vgaGreen: out std_logic_vector(3 downto 0);
           contrig, Hsync, Vsync , camout  : out STD_LOGIC);
end mainl;

architecture Behavioral of mainl is
signal disp: std_logic_vector(11 downto 0);
signal dism: std_logic_vector(12 downto 0);
signal sync,catr : std_logic;
signal bspd, busr: std_logic_vector(12 downto 0);
signal spedo: std_logic_vector(9 downto 0);
--signal rst ,dclk ,lock : std_logic;
component receiver is
    Port ( rcvd,ckc : in STD_LOGIC;
           trog ,syn : out STD_LOGIC; --syn
           dis : out STD_LOGIC_VECTOR (12 downto 0));
end component;
component spdomtr is
    Port ( ckc,syn : in STD_LOGIC; --syn
           cam : out STD_LOGIC;
           usr : in STD_LOGIC_VECTOR(9 downto 0);
           dis : in STD_LOGIC_VECTOR (12 downto 0);
           sped : out STD_LOGIC_VECTOR(9 downto 0));
end component;
component bcdconv is
    Port (B : out STD_LOGIC_VECTOR(12 downto 0);
          ckc : in std_logic;
          spd : in STD_LOGIC_VECTOR(9 downto 0));
end component;
component vga is
    Port ( ckc ,cam : in STD_LOGIC;
           hsy , vsy : out STD_LOGIC;
           bs ,bu : in std_logic_vector(12 downto 0);
           P : out STD_LOGIC_vector(11 downto 0));
end component;
begin
u1: receiver PORT MAP(rcvd => conrec, ckc => CLK, trog => contrig, dis => dism, syn => sync);
u2: spdomtr  PORT MAP(sped => spedo, ckc => CLK, usr => sw, dis => dism, syn => sync, cam => catr);
u3: bcdconv PORT MAP(spd => spedo, B => bspd, ckc => CLK);
u3b: bcdconv PORT MAP(spd => sw, B => busr, ckc => CLK);
u4: vga PORT MAP(hsy => Hsync, vsy => Vsync, ckc => CLK, P => disp, bs =>bspd ,bu =>busr, cam=>catr);
led <= dism;
camout <= catr;
vgaRed <= disp(11 downto 8);
vgaGreen <= disp(7 downto 4);
vgaBlue <= disp(3 downto 0);
end Behavioral;
