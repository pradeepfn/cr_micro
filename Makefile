FC=gfortran
CC=gcc
CFLAGS=-g
FFLAGS=-g -I/home/pradeep/checkout/tacc_phoenix/include 
LDFLAGS=-g -L/home/pradeep/checkout/tacc_phoenix/lib -lphoenix -larmci
main: micro.o allocate.o
	mpif90 -o $@ $^ $(LDFLAGS)

micro.o: micro.f90 allocate.o
	$(FC) $(FFLAGS) -c $<

allocate.o: allocate.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -rf micro.o allocate.o allocator.mod
