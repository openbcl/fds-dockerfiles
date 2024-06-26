#!/bin/bash
cd "$(dirname "$0")"
SUCCESS=1
echo '#######################'
echo '# Build new FDS image #'
echo $'#######################\n'
docker build -t fds -f ../Dockerfile .
echo '&HEAD CHID='test', TITLE='Test' /
&TIME T_BEGIN=0, T_END=5 /
&MESH XB =  0.0, 10.0, 0.0, 10.0, 0.0, 10.0, IJK = 10, 10, 10 /									
&VENT XB =  0.0,  0.0, 0.0, 10.0, 0.0,  1.0, SURF_ID = 'OPEN', COLOR = 'RED', OUTLINE = .FALSE. /
&VENT XB = 10.0, 10.0, 0.0, 10.0, 0.0,  1.0, SURF_ID = 'OPEN', COLOR = 'RED', OUTLINE = .FALSE. /
&REAC ID='POLYURETHANE', FUEL='REAC_FUEL', C=6.3, H=7.1, O=2.1, N=1.0, SOOT_YIELD=0.1, HEAT_OF_COMBUSTION=29000/
&SURF ID='A', COLOR='RED', HRRPUA=500.0 /
&OBST XB =  4.0,  6.0,  4.0,  6.0, 0.0, 0.0, SURF_ID='A' /
&TAIL /' > test.fds
echo $'\n#######################'
echo '# Run test simulation #'
echo $'#######################\n'
docker run --rm --ulimit stack=-1 -v $(pwd):/workdir fds mpiexec -n 1 fds test.fds
if grep -q "STOP: FDS completed successfully" ./test.out; then
    SUCCESS=0
    echo $'\n################################'
    echo '# Test completed successfully! #'
    echo '################################'
else
    echo $'\n################'
    echo '# Test failed! #'
    echo '################'
fi
rm -f test*
exit $SUCCESS