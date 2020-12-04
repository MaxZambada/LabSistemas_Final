----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2020 07:02:17 PM
-- Design Name: 
-- Module Name: puntos - Behavioral
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

entity puntos is
    Port ( Qout : in STD_LOGIC;
           Boton : in integer;
           TOut : in STD_LOGIC;
           IN1: in integer range 0 to 9;
           IN2: in integer range 0 to 9;
           ON1: out integer range 0 to 9;
           ON2: out integer range 0 to 9);
end puntos;

architecture Behavioral of puntos is


begin
Process(TOut)
begin
-- Tout habilita la suma de puntos
if TOut = '0' then
    -- Suma 1 punto
    if (Boton = 1 and Qout = '1') then
        if IN1 = 9 then
            ON1 <= 0;
            ON2 <= IN2 + 1;
        else
            ON1 <= IN1 + 1;
            ON2 <= IN2;
        end if;
    end if;
    -- Suma 5 puntos
    if (Boton = 2 and Qout = '1') then
            if IN1 >= 5 then
                ON1 <= IN1 - 5;
                ON2 <= IN2 + 1;
            else
                ON1 <= IN1 + 5;
                ON2 <= IN2;
            end if;
    end if;
    -- Suma 10 puntos
    if (Boton = 3 and Qout = '1') then
                ON1 <= In1;
                ON2 <= IN2 + 1;
            
    end if;
end if;
end process;
end Behavioral;
