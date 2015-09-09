FC=gfortran
CC=gcc
CFLAGS=-g
FFLAGS=-g -I/home/pradeep/checkout/tacc_phoenix/include -L/home/pradeep/checkout/tacc_phoenix/lib

main: micro.o allocate.o
	$(FC) -o $@ $^

micro.o: micro.f90 allocate.o
	$(FC) $(FFLAGS) -c $<

allocate.o: allocate.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -rf micro.o allocate.o allocator.mod
