from PyChipsUser import *
import sys
import os
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
os.system('c:\python27\python glib_vtrx_init.py 2 >> foo.txt')
os.system('c:\python27\python glib_vtrx_bert_ext_conf.py sfp 22 >> foo.txt')
os.system('c:\python27\python glib_vtrx_bert_ext_conf.py fmc 22 >> foo.txt')
os.system('c:\python27\python glib_vtrx_bert_conf.py     sfp 13 >> foo.txt')
os.system('c:\python27\python glib_vtrx_bert_conf.py     fmc 13 >> foo.txt')
os.system('c:\python27\python glib_vtrx_bert_ext_results.py sfp')
os.system('c:\python27\python glib_vtrx_bert_ext_results.py fmc')
os.system('c:\python27\python glib_vtrx_bert_results.py     sfp')
os.system('c:\python27\python glib_vtrx_bert_results.py     fmc')


print 