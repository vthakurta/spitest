
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:23:25 06/21/2017
-- Design Name:   spiTest
-- Module Name:   D:/varun2/spiTest/test.vhd
-- Project Name:  spiTest
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spiTest
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY test_vhd IS
END test_vhd;

ARCHITECTURE behavior OF test_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT spiTest
	PORT(
		SMISO : IN std_logic;
		clock : IN std_logic;    
		SCLK : INOUT std_logic;
		CLK : INOUT std_logic;
		RXBuf : INOUT std_logic_vector(56 downto 1);
		TXBuf : INOUT std_logic_vector(16 downto 1);      
		SMOSI : OUT std_logic;
		nSCS : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL SMISO :  std_logic := '0';
	SIGNAL clock :  std_logic := '0';

	--BiDirs
	SIGNAL SCLK :  std_logic:='0';
	SIGNAL CLK :  std_logic:='0';
	SIGNAL RXBuf :  std_logic_vector(56 downto 1);
	SIGNAL TXBuf :  std_logic_vector(16 downto 1);

	--Outputs
	SIGNAL SMOSI :  std_logic;
	SIGNAL nSCS :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: spiTest PORT MAP(
		SCLK => SCLK,
		SMOSI => SMOSI,
		SMISO => SMISO,
		nSCS => nSCS,
		CLK => CLK,
		RXBuf => RXBuf,
		TXBuf => TXBuf,
		clock => clock
	);
	
--	process
--	begin
--	clock<='0';
--	wait for 20ps;
--	clock<='1';
--	wait for 20ps;
--	end process;

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
