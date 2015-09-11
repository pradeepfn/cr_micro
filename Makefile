FC=mpif90
CC=gcc
CFLAGS=-g
FFLAGS=-g -I/home1/03528/pradeepf/phoenix/include -I/home1/03528/pradeepf/armci_install/include 
LDFLAGS=-g -L/home1/03528/pradeepf/phoenix/lib -L/home1/03528/pradeepf/armci_install/lib -lphoenix -larmci
main: micro.o allocate.o
	$(FC) -o $@ $^ $(LDFLAGS)

micro.o: micro.f90 allocate.o
	$(FC) $(FFLAGS) -c $<

allocate.o: allocate.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -rf micro.o allocate.o allocator.mod

rclean:
	rm -rf /dev/shm/mmap.*
	rm -rf stats/*
