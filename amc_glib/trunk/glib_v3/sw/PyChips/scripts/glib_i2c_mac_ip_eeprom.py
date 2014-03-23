from PyChipsUser import *
from time import sleep
glibAddrTable = AddressTable("./glibAddrTable.dat")

########################################
def i2c(slave_addr, wr, reg_addr, wrdata, mem=0, m16b=0, debug=0):
########################################
	strobe 		 = 1
	comm    = strobe*(2**31) + m16b*(2**25) + mem*(2**24) + wr*(2**23) + slave_addr *(2**16) + reg_addr *(2**8) + wrdata
	glib.write("i2c_command", comm)
	#delay possibly needed here
	#sleep(0.01)
	reply = glib.read("i2c_reply") # this is used as delay
	reply = glib.read("i2c_reply") # this is used as delay
	reply = glib.read("i2c_reply") # this is used as delay
	reply = glib.read("i2c_reply") # this is used as delay
	reply = glib.read("i2c_reply") # this is used as delay
	reply = glib.read("i2c_reply")
	#delay possibly needed here
	sleep(0.01)
	rddata = reply & 0xff
	i2c_status = (reply & 0x0c000000)/(2**26) # bit27-> error, bit26-> transaction finished
	if (i2c_status==1): 
		status = "done"
	elif (i2c_status==3): 	
		status = "fail"
	else: 
		status = "busy"
	if debug==1:
		if wr==1: print "-> slave",uInt8HexStr(slave_addr),"wrdata", uInt8HexStr(wrdata),status	
		if wr==0: print "-> slave",uInt8HexStr(slave_addr),"rddata", uInt8HexStr(rddata),status
	return rddata

	
########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

########################################
# i2c_settings        	0000000d    ffffffff     1     1
  # i2c_enable          0000000d    00000800     1     1
  # i2c_bus_select      0000000d    00000400     1     1
  # i2c_prescaler       0000000d    000003ff     1     1

# i2c_command         	0000000e    ffffffff     1     1
  # i2c_strobe 	  		0000000e    80000000     1     1 
  # i2c_mode16 	  		0000000e    02000000     1     1 
  # i2c_write 	  		0000000e    00800000     1     1 
  # i2c_slvaddr_7b  	0000000e    007f0000     1     1 
  # i2c_wrdata  		0000000e    000000ff     1     1 

#  i2c_reply			0000000f    ffffffff     1     0
	# i2c_reply_status  0000000f    0c000000     1     0
	# i2c_reply_8b		0000000f    000000ff     1     0
	# i2c_reply_16b		0000000f    0000ffff     1     0
########################################

load_nothing  = 0
load_mac_ip   = 3
load_mac_only = 1
load_ip_only  = 2
RegBuffer = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
RdxBuffer = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]


mode = load_mac_only
IpMacAddrBuffer =  [0xf5,0x08,0x00,0x30,0xf1,0x00,0x1e,192,168,0,111,mode,0x00,0x00,0x00,0x00]

i2c_en    = 1
i2c_sel   = 0
i2c_presc = 500
i2c_settings_value = i2c_en*(2**11) + i2c_sel*(2**10) + i2c_presc
glib.write("i2c_settings", i2c_settings_value)


i2c_str   = 1
i2c_m16   = 0
i2c_slv   = 0x56
reg_addr  = 0x00


wr     = 1
rd     = 0
unused = 0x00
reg    = 0x00

wren = 0
if wren==1:
	print
	for i in range(0,16):
		#  (slvaddr,r/w, regaddr, wrdata,             m, 16b, debug)
		i2c(i2c_slv, wr, reg+i  , IpMacAddrBuffer[i], 1,   0, 1)

rden = 1
if rden==1:
	print
	for i in range(0,16):
		#                 (slvaddr,r/w, regaddr, wrdata, m,16b, debug)
		RdxBuffer[i] = i2c(i2c_slv, wr, unused , reg+i,  0,  0, 0)
		RegBuffer[i] = i2c(i2c_slv, rd, unused , unused, 0,  0, 1)

print uInt32HexListStr(RegBuffer)

mac_addr = ':'.join([uInt8HexStr(RegBuffer[1]),uInt8HexStr(RegBuffer[2]),uInt8HexStr(RegBuffer[3]),uInt8HexStr(RegBuffer[4]),uInt8HexStr(RegBuffer[5]),uInt8HexStr(RegBuffer[6])])	
ip_addr  = '.'.join([str(RegBuffer[7]), str(RegBuffer[8]), str(RegBuffer[9]), str(RegBuffer[10])])	

if (mode==load_mac_ip): 
	print
	print 
	print "--================================--"
	print 
	print "-> set MAC addr to:", mac_addr
	print 
	print "-> set IP  addr to:", ip_addr
	print 
	print "--================================--"
	print

if (mode==load_mac_only): 
	print
	print 
	print "--================================--"
	print 
	print "-> set MAC addr to:", mac_addr
	print 
	print "--================================--"
	print

if (mode==load_ip_only): 
	print
	print 
	print "--================================--"
	print 
	print "-> set MAC addr to:", mac_addr
	print 
	print "--================================--"
	print

#print
#print "-> disabling i2c controller "
#glib.write("i2c_settings", i2c_ctrl_disable)	

i2c_en    = 0
i2c_sel   = 0
i2c_presc = 500
i2c_settings_value = i2c_en*(2**11) + i2c_sel*(2**10) + i2c_presc
glib.write("i2c_settings", i2c_settings_value)

#print
#print "-> done"
#print
#print "--=======================================--"
#print 
#print
