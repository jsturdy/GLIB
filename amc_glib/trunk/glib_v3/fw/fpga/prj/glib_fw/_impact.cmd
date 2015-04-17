loadProjectFile -file "Z:\Documents\PhD\Code\GLIB\amc_glib\trunk\glib_v3\fw\fpga\prj\glib_fw\impact.ipf"
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
setMode -bs
setMode -bs
setMode -pff
setMode -pff
setMode -pff
setMode -pff
setMode -pff
setCurrentDesign -version 0
setMode -pff
setCurrentDeviceChain -index 0
setSubmode -pffspi
setMode -pff
setMode -pff
setMode -bs
setMode -bs
setMode -bs
setMode -pff
setMode -pff
setMode -pff
setMode -bs
setMode -bs
setMode -bs
deletePromDevice -position 1
setCurrentDesign -version 0
deleteDevice -position 1
deleteDesign -version 0
setCurrentDesign -version -1
setMode -pff
setMode -pff
addConfigDevice  -name "GLIB" -path "C:\Users\tlenzi\Desktop"
setSubmode -pffserial
setAttribute -configdevice -attr multibootBpiType -value ""
addDesign -version 0 -name "0"
setMode -pff
addDeviceChain -index 0
setMode -pff
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr autoSize -value "FALSE"
setAttribute -configdevice -attr fileFormat -value "mcs"
setAttribute -configdevice -attr fillValue -value "FF"
setAttribute -configdevice -attr swapBit -value "FALSE"
setAttribute -configdevice -attr dir -value "UP"
setAttribute -configdevice -attr flashDataWidth -value "16"
setAttribute -configdevice -attr flashTopology -value "8"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
addPromDevice -p 1 -size 0 -name xcf128x
setMode -bs
setMode -bs
setMode -bs
setMode -pff
setMode -pff
setMode -pff
setMode -pff
addDeviceChain -index 0
setMode -pff
addDeviceChain -index 0
setMode -pff
setSubmode -pffbpi
setSubmode -pffserial
setMode -pff
setAttribute -design -attr RSPin -value "00"
addDevice -p 1 -file "Z:/Documents/PhD/Code/GLIB/amc_glib/trunk/glib_v3/fw/fpga/prj/glib_fw/glib_top.bit"
setAttribute -design -attr RSPinMsb -value ""
setAttribute -design -attr name -value "0"
setAttribute -design -attr RSPin -value "00"
setAttribute -design -attr endAddress -value "2a20ab"
setAttribute -design -attr endAddress -value "2a20ab"
setMode -pff
setSubmode -pffbpi
setAttribute -configdevice -attr multibootBpiType -value "TYPE_MB_BPI"
setAttribute -configdevice -attr multibootBpichainType -value "PARALLEL"
setSubmode -pffserial
generate
setCurrentDesign -version 0
setMode -bs
setMode -pff
setSubmode -pffbpi
setSubmode -pffbpi
setSubmode -pffserial
setSubmode -pffserial
setMode -pff
setMode -bs
deleteDevice -position 1
setMode -bs
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
