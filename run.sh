make rclean
#mpirun -n 2 --mca orte_base_help_aggregate 0 ./addition
ibrun -np 8 ./main
