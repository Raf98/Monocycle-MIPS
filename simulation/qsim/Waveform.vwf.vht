-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "09/16/2020 22:44:23"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          MIPS
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY MIPS_vhd_vec_tst IS
END MIPS_vhd_vec_tst;
ARCHITECTURE MIPS_arch OF MIPS_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL addressRead1Out : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addressRead2Out : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addressWriteRegisterOut : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL dataMemoryOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL dataRead1Out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL dataRead2Out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL dataWriteRegisterOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL instructionOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL loadMemoryOut : STD_LOGIC;
SIGNAL loadOut : STD_LOGIC;
SIGNAL mapControlOuput : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL pcNextOut : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL ULAOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL wordInMemoryOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
COMPONENT MIPS
	PORT (
	addressRead1Out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	addressRead2Out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	addressWriteRegisterOut : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	clk : IN STD_LOGIC;
	dataMemoryOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	dataRead1Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	dataRead2Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	dataWriteRegisterOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	instructionOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	loadMemoryOut : OUT STD_LOGIC;
	loadOut : OUT STD_LOGIC;
	mapControlOuput : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	pcNextOut : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	reset : IN STD_LOGIC;
	ULAOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	wordInMemoryOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : MIPS
	PORT MAP (
-- list connections between master ports and signals
	addressRead1Out => addressRead1Out,
	addressRead2Out => addressRead2Out,
	addressWriteRegisterOut => addressWriteRegisterOut,
	clk => clk,
	dataMemoryOut => dataMemoryOut,
	dataRead1Out => dataRead1Out,
	dataRead2Out => dataRead2Out,
	dataWriteRegisterOut => dataWriteRegisterOut,
	instructionOut => instructionOut,
	loadMemoryOut => loadMemoryOut,
	loadOut => loadOut,
	mapControlOuput => mapControlOuput,
	pcNextOut => pcNextOut,
	reset => reset,
	ULAOut => ULAOut,
	wordInMemoryOut => wordInMemoryOut
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
	clk <= '0';
WAIT;
END PROCESS t_prcs_clk;

-- reset
t_prcs_reset: PROCESS
BEGIN
	reset <= '0';
WAIT;
END PROCESS t_prcs_reset;
END MIPS_arch;
