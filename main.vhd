----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2020 08:00:07 PM
-- Design Name: 
-- Module Name: main - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port ( CLK100MHZ : in STD_LOGIC;
           B1 : in STD_LOGIC;
           B2 : in STD_LOGIC;
           B3 : in STD_LOGIC;
           B4 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           RS : out STD_LOGIC;
           RW : out STD_LOGIC;
           EN : out STD_LOGIC;
           SM1 : out STD_LOGIC;
           LCD1 : out STD_LOGIC_VECTOR (7 downto 0);
           D71 : out STD_LOGIC_VECTOR (7 downto 0);
           T1, T2 : out STD_LOGIC_VECTOR (3 downto 0);
           D7A : out STD_LOGIC_VECTOR (1 downto 0));
end main;

architecture Behavioral of main is

component PWM is
    Port ( CLK : in STD_LOGIC;
           SAL : out STD_LOGIC;
           CONT1 : in STD_LOGIC_VECTOR (4 downto 0);
           CONTS : out STD_LOGIC_VECTOR (4 downto 0);
           EN : in STD_LOGIC);
end component;

component LIB_LCD_INTESC_REVD is

GENERIC(
			FPGA_CLK : INTEGER := 100_000_000
);
			

PORT(CLK: IN STD_LOGIC;
	  RS 		  : OUT STD_LOGIC;							--
	  RW		  : OUT STD_LOGIC;							--
	  ENA 	  : OUT STD_LOGIC;							--
	  DATA_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	  Int1, Int2 : IN integer);
end component;

component puntos is
    Port ( Qout : in STD_LOGIC;
           Boton : in integer;
           TOut : in STD_LOGIC;
           IN1: in integer range 0 to 9;
           IN2: in integer range 0 to 9;
           ON1: out integer range 0 to 9;
           ON2: out integer range 0 to 9);
end component;

component segm7 is
Port(
        Clk: in std_logic;
        N1, N2: in std_logic_vector(3 downto 0);
        S81, S82: out std_logic_vector(7 downto 0)
);
end component;

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  CLK100MHZ          : out    std_logic;
  CLK1MHZ          : out    std_logic;
  CLK50MHZ          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component one_shot is
    Port ( B1 : in STD_LOGIC;
           B2 : in STD_LOGIC;
           B3 : in STD_LOGIC;
           clk : in STD_LOGIC;
           Qout : out STD_LOGIC;
           Boton : out integer);
end component;

--SLock: Variable extra nadamas para el port map de reloj
--STO : Bloquear botones para puntos
--SON : Indica si empieza el juego
--SLCDE: Indica si esta prendido el LCD
--SMUX: Varia el valor que despliega el Disp de 7 segmentos
--SP1, SP2: Cuenta los puntos y los pasa al Disp LCD
--STJ1, STJ2: Tiempo para poder pasarlo a los Disp de 7 segms
--STJ71, STJ72: Los valores que se imprimen en el Disp 7 segms
--Int1, Int2, Int3, Int4: Valores de los Puntos
--IntTJ1, IntTJ2: Tiempo
--IntPuls, IntComp: Valores para generar señal PWM
--IntTO: Tiempo que le resta al bloqueo de botones
--IntTime: Contador para que se tenga 100ms y limitar el paso del tiempo
signal STO : std_logic := '1';
signal SCLK100, SCLK1, SCLK50, SON, SLock, SLCDE, Qout: std_logic := '0';
signal SMUX : STD_LOGIC_VECTOR(1 downto 0) := "01";
signal SP1, SP2, STJ1, STJ2 : std_logic_vector(3 downto 0):= "0000";
signal STJ71, STJ72: std_logic_vector(7 downto 0)  := "00000000";
signal Int1, Int2, Int3, Int4, Int5, IntTJ1, IntTJ2, IntPuls, IntComp, IntTime: integer := 0;
signal IntTO, Boton: integer := 0;

begin
--PPuntos: Calcula los puntos al oprimir cada boton
--PSegm7: Convierte los valores de 4 bits a señal de 7 para los Displays
--PClocks: Genera diferentes señales de Clocks
--PLCD: Para utilizar el LCD
PPuntos: puntos port map(Qout, Boton, STO, Int1, Int2, Int3, Int4);
PSegm7: segm7 port map(Clk100MHZ, STJ1, STJ2, STJ71, STJ72);
PClocks: clk_wiz_0 port map(SCLK100, SCLK1, SCLK50, '0', SLock, CLK100MHZ);
PLCD: LIB_LCD_INTESC_REVD port map(Clk100MHZ, RS, RW, EN, LCD1, Int2, Int1);
OneS: One_shot port map(B2, B3, B4, CLK100MHZ, Qout, Boton);


Process(CLK100MHZ)
begin
if CLK100MHZ'event and CLK100MHZ = '1' and SW1 = '1' then

-- Inicializacion de Juego
    if B1 = '1' and SON = '0' then
        SON <= '1';
        Int1 <= 0;
        Int2 <= 0;
        Int3 <= 0;
        Int4 <= 0;
    --elsif B1 = '1' and SON = '1' then
        --SON <= '0';
        --IntTJ1 <= 0;
        --IntTJ2 <= 0;
    end if;
    
    --Inicia Timer Juego
    if SW1 = '1' and SON = '1' then
        
       Int1 <= Int3;
       Int2 <= Int4;
       --Convertir ints a std_logic_vector
       SP1 <= conv_std_logic_vector(Int1, 4);
       SP2 <= conv_std_logic_vector(Int2, 4);
       T1 <= SP1;
       T2 <= SP2;
       
       
       --pasar de nanosegundos a segundos
       if IntTime <= 100000000 then 
            IntTime <= IntTime + 1;
       else
            IntTime <= 0;
       end if;
       
       
        --Iniciar Timer en 60 y Restar
        if IntTJ1 = 0 and IntTJ2 = 0 and IntTime = 0 then
            
            IntTJ1 <= 5;
            IntTJ2 <= 9;
            SLCDE <= '0';
        --Termina Juego
        elsif IntTJ1 = 0 and IntTJ2 = 1 and IntTime = 0 then
            STJ1 <= "0000";
            STJ2 <= "0000";
            IntTJ2 <= IntTJ2 - 1;
            SON <= '0';
            SLCDE <= '1';
        --Disminuir valor del reloj
        elsif (IntTJ1 /= 0 or IntTJ2 /= 0) and IntTime = 0 then
            --En caso de llegar a 0
            if IntTJ2 = 0 then
                IntTJ2 <= 9;
                IntTJ1 <= IntTJ1 - 1;
            --Resto de los casos
            else
                IntTJ2 <= IntTJ2 - 1;
            end if;
        end if;

-- Puntos
    
    --Bloquear botones por 1 segundo
--    if B2 = '1' and IntTO = 0 and IntTime = 0 then
--        IntTO <= 1;
--        STO <= '0';
--    --Bloquear botones por 7 segundos
--    elsif B3 = '1' and IntTO = 0  and IntTime = 0 then
--        IntTO <= 7;
--        STO <= '0';
--    --Bloquear botones por 15 segundos
--    elsif B4 = '1' and IntTO = 0 and IntTime = 0 then
--        IntTO <= 15;
--        STO <= '0';
--    --Disminuir reloj de bloqueo un segundo
--    elsif IntTO /= 0  and IntTime = 0 then
--        IntTO <= IntTO - 1;
--        STO <= '1';
--    --Volver a habilitar los botones
--    elsif B2 = '0' and B3 = '0' and B4 = '0' and IntTO = 0 and IntTime = 0 then
--        IntTO <= 0;
--        STO <= '1';
--    end if;

      if (Boton = 1 and Qout = '1') then
          IntTo <= 1;
          STO <= '0';
      elsif (Boton = 2 and Qout = '1') then
          IntTo <= 7;
          STO <= '0';
      elsif (Boton = 3 and Qout = '1') then
          IntTo <= 15;
          STO <= '0';
      elsif (Boton = 0 and Qout = '0' and intTime = 0 and IntTo /= 0) then
          IntTo <= IntTo - 1;
          STO <= '0';
      elsif (intTime = 0 and IntTo = 0) then
          STO <= '1';
      elsif (intTime = 0 and IntTo /= 0) then
          STO <= '0';    
      end if;
    
-- Displays de 7 segmentos
    
    --Multiplexar entre valores del timer
    if SMUX = "10" then
        D71 <= STJ71;
        SMUX <= "01";
    else
        D71 <= STJ72;
        SMUX <= "10";
    end if;
    
    --Pasar el valor a su salida
        D7A <= SMUX;
    
    end if; 
    
    --Convertir ints a std_logic_vector
    STJ1 <= conv_std_logic_vector(IntTJ1, 4);
    STJ2 <= conv_std_logic_vector(IntTJ2, 4);
    
--PWM
    
    --Intpuls para abrir o cerrar puerta con servo cambia entre -90 y 90 grados
    if (SON = '0' and Int2 <= Int5) then 
        IntPuls <= 250000;
    elsif (SON = '0' and Int2 > Int5 ) then
        IntPuls <= 50000;
    else 
        IntPuls <= 250000;
    end if;
    
    --Prende salida cuando comp es menor a puls
    if (IntComp <= IntPuls) then
        SM1 <= '1';
        IntComp <= IntComp + 1;
    --Resetea valor de comp cuando llega a 2000000
    elsif (IntComp = 2000000) then
        SM1 <= '0';
        IntComp <= 0;
        Int5 <= Int5 + 1;
    --Apaga salida cuando comp es mayor a puls
    else 
        SM1 <= '0';
        IntComp <= IntComp + 1;
    end if;
    
end if;

end process;
end Behavioral;
