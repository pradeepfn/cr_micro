MODULE Global
    !we are going to  have twenty variables to simulate our apps 
    real, pointer :: array_1(:) 
    real, pointer :: array_2(:) 
    real, pointer :: array_3(:)
    real, pointer :: array_4(:)
    real, pointer :: array_5(:)
    real, pointer :: array_6(:)
    real, pointer :: array_7(:)
    real, pointer :: array_8(:)
    real, pointer :: array_9(:)
    real, pointer :: array_10(:)

CONTAINS
    subroutine arrayincmod(array) 
    real,pointer  :: array(:)
    do i = 1,size(array)  
       array(i) = array(i) +1
       array(i)=MOD(array(i),100.0)
    end do
    end subroutine arrayincmod

END MODULE Global

program micro
    use Allocator
    use Global
    implicit none
    include 'mpif.h'

    real, pointer :: nstep
    integer, pointer :: istep
    CHARACTER(LEN=10) varname
    integer(4) :: length
    integer(4) :: cmtsize
    integer(4) :: fix_d
    integer(4):: iter,nsize
    integer(4) :: ierr,mype,nproc
    logical file_exist
    !we should be able to change the compute time and data sizes independently
    ! comp_step - controls the compute budget of the program
    ! data_size - controls the data size the program outputs
    ! irun - flas to identify fresh/restart run

    namelist /control/ comp_step,data_size,irun
    integer :: i,irun,comp_step,data_size


    inquire(file='micro.input',exist=file_exist)
    if (file_exist) then
       open(55,file='micro.input',status='old')
       read(55,nml=control)
       close(55)
    else
       write(0,*)'******************************************'
       write(0,*)'*** NOTE!!! Cannot find file micro.input !!!'
       write(0,*)'*** Using default run parameters...'
       write(0,*)'******************************************'
    endif

    call MPI_INIT(ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, mype, ierr)

    call start_timestamp(mype)

    if(mype == 0) then 
    write(0,*),'comp_step',comp_step
    write(0,*),'data_size',data_size
    write(0,*),'irun',irun
    endif

    if(mype==0) print *, "Micro_C/R - Starting computation"
    call init(mype,nproc)
    !allocate from phoenix lib 
    nsize = data_size 
    iter = comp_step

    varname = "array_1"
    call alloc_1d_real(array_1,nsize,varname,mype,nsize) 

    varname = "array_2"
    call alloc_1d_real(array_2,nsize,varname,mype,nsize) 

    varname = "array_3"
    call alloc_1d_real(array_3,nsize,varname,mype,nsize) 

    varname = "array_4"
    call alloc_1d_real(array_4,nsize,varname,mype,nsize) 

    varname = "array_5"
    call alloc_1d_real(array_5,nsize,varname,mype,nsize) 

    varname = "array_6"
    call alloc_1d_real(array_6,nsize,varname,mype,nsize) 

    varname = "array_7"
    call alloc_1d_real(array_7,nsize,varname,mype,nsize) 

    varname = "array_8"
    call alloc_1d_real(array_8,nsize,varname,mype,nsize) 

    varname = "array_9"
    call alloc_1d_real(array_9,nsize,varname,mype,nsize) 

    varname = "array_10"
    call alloc_1d_real(array_10,nsize,varname,mype,nsize) 

    !variable initialization during the first run
    if(irun == 0)then
      if(mype == 0) write(0,*) 'First run of the program. Initalizing variables.'
      array_1=1
      array_2=2
      array_3=3
      array_4=4
      array_5=5
      array_6=6
      array_7=7
      array_8=8
      array_9=9
      array_10=10
    endif

    !Do some heavy computations, checkpoint after each iter
    do i = 1, 10
        call compute(iter,nsize)
        if(mype == 0) write(0,*) 'Program values', array_1(1),array_4(1),array_7(1),array_10(1)
        !coordinated checkpoint 
        call MPI_BARRIER(MPI_COMM_WORLD,ierr)
        call chkpt_all(mype)
        call MPI_BARRIER(MPI_COMM_WORLD,ierr)
    end do
    call MPI_FINALIZE(ierr) 
    call end_timestamp()
    if(mype == 0) write(0,*)'End of benchmark. Bye!!'
end program micro

!Compute subroutine
subroutine compute(iter,nsize)
use Global
integer iter,nsize
integer i,j,k
do i = 1,iter
    do k = 1,iter
     call arrayincmod(array_1)
     call arrayincmod(array_2)
     call arrayincmod(array_3)
     call arrayincmod(array_4)
     call arrayincmod(array_5)
     call arrayincmod(array_6)
     call arrayincmod(array_8)
     call arrayincmod(array_9)
     call arrayincmod(array_10)
     call arrayincmod(array_7)
    end do
end do
end subroutine compute


