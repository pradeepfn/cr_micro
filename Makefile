FC=mpif90
CC=gcc
CFLAGS=-g
FFLAGS=-g -I/home/pradeep/checkout/tacc_phoenix/include 
LDFLAGS=-g -L/home/pradeep/checkout/tacc_phoenix/lib -lphoenix -larmci -lpthread
main: micro.o allocate.o
	$(FC) -o $@ $^ $(LDFLAGS)

micro.o: micro.f90 allocate.o
	$(FC) $(FFLAGS) -c $<

allocate.o: allocate.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -rf micro.o allocate.o allocator.mod

rclean:
	rm -rf /home/pradeep/testmmap/*
	rm -rf stats/*
