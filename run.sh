make clean
make
make rclean
#mpirun -n 2 --mca orte_base_help_aggregate 0 ./addition
mpirun -n 4 ./main
