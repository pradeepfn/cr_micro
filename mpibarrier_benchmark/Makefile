FC=mpif90
CC=gcc
CFLAGS=-g
FFLAGS=-g 
LDFLAGS=-g
main: barrier.o
	$(FC) -o $@ $^ $(LDFLAGS)

barrier.o: barrier.c
	$(FC) $(FFLAGS) -c $<

clean:
	rm -rf barrier.o main

rclean:
	rm -rf stats/*
