from PyChipsUser import *
import sys
import os
from PyChipsUser import *
glibAddrTable = AddressTable("./glibAddrTable.dat")
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
#os.system('c:\python27\python glib_vtrx_init.py 0 >> foo.txt')
#os.system('c:\python27\python glib_vtrx_bert_ext_conf.py sfp 27 >> foo.txt')
#os.system('c:\python27\python glib_vtrx_bert_ext_conf.py fmc 26 >> foo.txt')
#os.system('c:\python27\python glib_vtrx_bert_conf.py     sfp 14 >> foo.txt')
#os.system('c:\python27\python glib_vtrx_bert_conf.py     fmc 14 >> foo.txt')
os.system('c:\python27\python glib_vtrx_bert_ext_results.py sfp')
os.system('c:\python27\python glib_vtrx_bert_ext_results.py fmc')
os.system('c:\python27\python glib_vtrx_bert_results.py     sfp')
os.system('c:\python27\python glib_vtrx_bert_results.py     fmc')


print 