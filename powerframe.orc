#start orca session for PB version 10.5
session begin pborc105.dll

#make target directory as current
cd C:\Project\Powerframe_v3.03\source

#set library list from target
target set liblist powerframe.pbt

#set current application from target
target set app powerframe.pbt

#rebuild application full, incremental, or migrate
#build app incremental

#creates executable & pbd
#build exe powerframe.exe, , , pcode | stylexp

# build pbd library
build library %%PBLPATH%%, , pbd

#executes system command
#sys <system command>

#displays current date and time
#timestamp

#ends orca session
session end
