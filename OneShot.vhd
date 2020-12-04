library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity one_shot is
    Port ( B1 : in STD_LOGIC;
           B2 : in STD_LOGIC;
           B3 :IN STD_LOGIC;
           clk : in STD_LOGIC;
           Qout : out STD_LOGIC;
           Boton : out integer);
end one_shot;

architecture Behavioral of one_shot is
    signal Q1, Q2, Q3 : std_logic;
begin
    process(clk)
    begin
        if clk'event and clk = '1' then 
            if (B1 = '1') then
                Boton <= 1;
            elsif (B2 = '1') then
                Boton <= 2;
            elsif (B3 = '1') then
                Boton <= 3;
--            else 
--                Boton <= 0;
            end if;
            Q1 <= B1 or B2 or B3;
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;
 Qout <= Q1 and Q2 and (not Q3);
 end behavioral;
