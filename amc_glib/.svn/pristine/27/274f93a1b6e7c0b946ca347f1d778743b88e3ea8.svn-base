from PyChipsUser import *
glibAddrTable = AddressTable("./glibAddrTable.dat")
import os

########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening GLIB with IP", ipaddr
print "--=======================================--"
########################################


print
print "-> BOARD INFORMATION"
print "-> -----------------"

brd_char 	= ['w','x','y','z']
brd_char[0] = chr(glib.read("board_id_char1"))
brd_char[1] = chr(glib.read("board_id_char2"))
brd_char[2] = chr(glib.read("board_id_char3"))
brd_char[3] = chr(glib.read("board_id_char4"))
print "-> brd :",brd_char[0],brd_char[1],brd_char[2],brd_char[3]

sys_char 	= ['w','x','y','z']
sys_char[0] = chr(glib.read("sys_id_char1"))
sys_char[1] = chr(glib.read("sys_id_char2"))
sys_char[2] = chr(glib.read("sys_id_char3"))
sys_char[3] = chr(glib.read("sys_id_char4"))
print "-> sys :",sys_char[0],sys_char[1],sys_char[2],sys_char[3]

ver_major = glib.read("ver_major")
ver_minor = glib.read("ver_minor")
ver_build = glib.read("ver_build")
print "-> ver :", ver_major,".",ver_minor,".",ver_build
yy  = 2000+glib.read("firmware_yy")
mm  = glib.read("firmware_mm")
dd  = glib.read("firmware_dd")
print "-> date:", dd,"/",mm,"/", yy

#####################################################################
os.system('c:\python27\python glib_i2c_eeprom_read_eui.py')
#####################################################################
print
print "-> BOARD STATUS     "
print "-> -----------------"
print "-> sfp1 absent       :", glib.read("glib_sfp1_mod_abs")
print "-> sfp1 rxlos        :", glib.read("glib_sfp1_rxlos")
print "-> sfp1 txfault      :", glib.read("glib_sfp1_txfault")
print "-> sfp2 absent       :", glib.read("glib_sfp2_mod_abs")
print "-> sfp2 rxlos        :", glib.read("glib_sfp2_rxlos")
print "-> sfp2 txfault      :", glib.read("glib_sfp2_txfault")
print "-> sfp3 absent       :", glib.read("glib_sfp3_mod_abs")
print "-> sfp3 rxlos        :", glib.read("glib_sfp3_rxlos")
print "-> sfp3 txfault      :", glib.read("glib_sfp3_txfault")
print "-> sfp4 absent       :", glib.read("glib_sfp4_mod_abs")
print "-> sfp4 rxlos        :", glib.read("glib_sfp4_rxlos")
print "-> sfp4 txfault      :", glib.read("glib_sfp4_txfault")
print "-> ethphy interrupt  :", glib.read("gbe_int")
print "-> fmc1 presence     :", glib.read("fmc1_present")
print "-> fmc2 presence     :", glib.read("fmc2_present")
print "-> fpga reset state  :", glib.read("fpga_reset")
print "-> cpld bus state    :", uInt8HexStr(glib.read("v6_cpld"))
print "-> cdce locked       :", glib.read("cdce_lock")
print "-> cdce phase status :", glib.read("cdce_phase_status")

















print
print "-> done"
print
print "--=======================================--"
print 
print
