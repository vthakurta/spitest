----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:32:40 06/16/2017 
-- Design Name: 
-- Module Name:    spiTest - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spiTest is
    Port ( SCLK : inout  STD_LOGIC;
           SMOSI : inout  STD_LOGIC;
           SMISO : inout  STD_LOGIC;
           nSCS : out  STD_LOGIC;
           CLK : inout  STD_LOGIC;
			  RXBuf : inout STD_LOGIC_VECTOR(8 DOWNTO 1);
			  TXBuf : inout STD_LOGIC_VECTOR(8 DOWNTO 1);
           clock : in  STD_LOGIC);
end spiTest;

architecture Behavioral of spiTest is
shared variable count1: integer;
shared variable initFlag, transmitFlag, receiveFlag ,byteSend,byteReceive,bytesReceived, timer0,CSFlag,timer3,timer1,transition : integer:=0;
shared variable repeatFlag, timer2:integer:=1;
shared variable  sizeofRXBuf, sizeofTXBuf :integer:= 8;
type BYTE is STD_LOGIC_VECTOR(8 downto 1);
variable RXData: BYTE(7 downto 0)
variable TXData: BYTE(3 downto 0); 

begin
	
	process(clock)
				variable masterClockDivider :integer;
				procedure timerInit is
				begin
					if(masterClockDivider<0 or masterClockDivider >50) then
						masterClockDivider:=0;
						CLK<='0';
					end if;
				end timerInit;
				
				procedure timeCritical is
				begin
					if(rising_edge(clock)) then
						masterClockDivider:=masterClockDivider+1;
						if(masterClockDivider >= 2) then
							masterClockDivider:=0;
							CLK<=not CLK;
						end if;
					end if;
				end timeCritical;
					
				--derives an intermediate clock from the base clock
				--governs all spi operations
				procedure CLKtick is
	begin
		timerInit;
		timeCritical;
	end CLKtick;
	
	begin
		CLKtick;
	end process;
		
		
	
	
	process(clk)	
	begin
				if(timer0<0 or timer0>50 or repeatFlag = 1)then
					sclk<='1';
					sizeofTXBuf := 16;
					sizeofRXBuf := 56;
					TXBuf <= "10010101";
					SMOSI<='1';
					SMISO<='1';
					nSCS<='1';
					repeatFlag := 1;
					timer2:=1;

				end if;

				if(rising_edge(CLK)and initFlag = 0 and repeatFlag=1)then
					nSCS<='0';
					initFlag:=1;
					receiveFlag := 0;
					transmitFlag := 0;
					repeatFlag := 0;
				end if;

				if(rising_edge(clk)and initFlag = 1)then
					timer0:=timer0+1;	
					if(timer0=4) then
						if(sclk='1' and transmitFlag/=0)then
								transition := 1;
						end if;
						sclk<=not sclk;
						timer0:=0;
					end if;
					if(timer0=2 and transmitFlag = 0) then
						SMOSI<=TXBuf(sizeofTXBuf);
						if(timer2=2) then
							sizeofTXBuf:=sizeofTXBuf-1;
							if(byteSend=3)then
							if(sizeofTXBuf =0)then
--								transmitFlag := 1;
--								SMOSI<='1';
--								sizeofTXBuf:=16;
								byteSend:=byteSend-1;
								TXBuf<=TXData(byteSend);--elaborate

								if(byteSend=0)then
									transmitFlag:=1;
									SMOSI<='1';
								
								end if;
								sizeofTXBuf:=8;

							end if;
							timer2:=0;
						end if;
						timer2:=timer2+1;
					end if;
					if((transition = 1 or transmitFlag = 1) and byteReceive>0)then
						transmitFlag:=2;
						RXBuf(sizeofRXBuf)<=SMISO;
						sizeofRXBUf:=sizeofRXBuf-1;
						if(sizeofRXBuf = 0) then
							--receiveFlag:=1;
							--sizeofRXBuf:=56;
							RXData(bytesReceived):=RXBuf;
							bytesReceived:=bytesReceived+1;
							if(bytesReceived=(byteReceive+1)) then
								receiveFlag:=1;
								terminateFlag :=1;
							end if;
							sizeofRXBuf:=8;
						transition:=0;				
					end if;	
				end if;
				if((terminateFlag = 1)then--figure out
					if(initFlag = 1) then
						initFlag := 2;
						timer3:=0;
					end if;
					if(rising_edge(clk))then
						timer3:=timer3+1;
						if(timer3=1)then
							nSCS<='1';
							timer1:=0;
							CSFlag:=1;
						end if;
						if(CSFlag=1 and repeatFlag=0)then
							if(rising_edge(clk)) then
								timer1:=timer1+1;
								if(timer1=10)then					
									repeatFlag := 1;
									initFlag := 0;
									timer3:=0;
									CSFlag:=0;
									terminateFlag=0;
								end if;
							end if;
						end if;
					end if;
				end if;
	end process;-- WORKING TX
end behavioral;