----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2020 07:32:14 PM
-- Design Name: 
-- Module Name: segm7 - Behavioral
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

entity segm7 is
Port(
        Clk: in std_logic;
        N1, N2: in std_logic_vector(3 downto 0);
        S81, S82: out std_logic_vector(7 downto 0)
);
end segm7;

architecture Behavioral of segm7 is

begin
Process(Clk)
begin
-- pasa valor de 4 bits a su equivalente para display de 7 segmentos
case (n2) is
                    when "0000" => S82 <= "11000000";
                    when "0001" => S82 <= "11111001";
                    when "0010" => S82 <= "10100100";
                    when "0011" => S82 <= "10110000";
                    when "0100" => S82 <= "10011001";
                    when "0101" => S82 <= "10010010";
                    when "0110" => S82 <= "10000010";
                    when "0111" => S82 <= "11111000";
                    when "1000" => S82 <= "10000000";
                    when "1001" => S82 <= "10010000";
                    when others => S82 <= "11111111";
                    end case;

case (n1) is
                    when "0000" => S81 <= "11000000";
                    when "0001" => S81 <= "11111001";
                    when "0010" => S81 <= "10100100";
                    when "0011" => S81 <= "10110000";
                    when "0100" => S81 <= "10011001";
                    when "0101" => S81 <= "10010010";
                    when "0110" => S81 <= "10000010";
                    when "0111" => S81 <= "11111000";
                    when "1000" => S81 <= "10000000";
                    when "1001" => S81 <= "10010000";
                    when others => S81 <= "11111111";
                    end case;

end process;
end Behavioral;
