#!/bin/bash
cd "$(dirname "$0")"
SUCCESS=1
echo '#######################'
echo '# Build new FDS image #'
echo $'#######################\n'
docker build --platform linux/amd64 -t fds -f ../Dockerfile .
echo '&HEAD CHID='test', TITLE='Test' /
&TIME T_BEGIN=0, T_END=5 /
&REAC FUEL='ETHANE', HEAT_OF_COMBUSTION=40000 /
&SURF ID='A', COLOR='RED', HRRPUA=500.0 /
&MESH XB =  0.0, 10.0, 0.0, 10.0, 0.0, 10.0, IJK = 10, 10, 10 /									
&VENT XB =  0.0,  0.0, 0.0, 10.0, 0.0,  1.0, SURF_ID = 'OPEN' /
&VENT XB = 10.0, 10.0, 0.0, 10.0, 0.0,  1.0, SURF_ID = 'OPEN' /
&OBST XB =  4.0,  6.0,  4.0,  6.0, 0.0, 0.0, SURF_ID='A' /
&TAIL /' > test.fds
echo $'\n#######################'
echo '# Run test simulation #'
echo $'#######################\n'
docker run --rm --ulimit stack=-1 --platform linux/amd64 -v $(pwd):/workdir fds mpiexec -n 1 fds test.fds
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