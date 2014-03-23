--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																																  	
-- Company:  					CERN (PH-ESE-BE)																			
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--=================================================================================================--
--=================================================================================================--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cdce_phase_monitoring_package is 

	type regBuffT	 is array (0 to 5) of std_logic_vector(11 downto 0);
	
	type tapValuesT is array (11 downto 0) of natural;
	constant DLY_TAP_VALUES	: tapValuesT := (   0,  	  	
															  1,     	
															 ----
															  4,     																					 
															  5,      	
															 ----
															  9,    																					  
															 10,    																					  
															 ----
															 13,    																					  
															 16,    																					  
															 ----
															 21, --18,    																					  
															 22, --20,    																					  
															 ----
	  													    24, --22,    																					  
															 25);--24);   	
end cdce_phase_monitoring_package;

package body cdce_phase_monitoring_package is
end cdce_phase_monitoring_package;
