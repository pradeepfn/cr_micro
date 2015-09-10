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

END MODULE Global

program micro
    use Allocator
    use Global

    real, pointer :: nstep
    integer, pointer :: istep
    CHARACTER(LEN=10) varname
    integer :: length
    integer :: cmtsize
    integer :: fix_d
    logical file_exist
    !we should be able to change the compute time and data sizes independently
    ! comp_step - controls the compute budget of the program
    ! data_size - controls the data size the program outputs
    ! irun - flas to identify fresh/restart run

    namelist /control/ comp_step,data_size,irun
    integer :: i,irun,comp_step,data_size


    inquire(file='micro.input',exist=file_exist)
    if (file_exist) then
       write(0,*)'Reading micro.input, configuring the run'
       open(55,file='micro.input',status='old')
       read(55,nml=control)
       close(55)
    else
       write(0,*)'******************************************'
       write(0,*)'*** NOTE!!! Cannot find file micro.input !!!'
       write(0,*)'*** Using default run parameters...'
       write(0,*)'******************************************'
    endif
    
    write(0,*),'comp_step',comp_step
    write(0,*),'data_size',data_size
    write(0,*),'irun',irun


    fix_d = 100

    print *, "Micro_C/R - Starting computation"
    call init(0,1)
    !allocate from phoenix lib 
    nsize = 10 
    varname = "array_1"
    call alloc_1d_real(array_1,nsize,varname,1,nsize) 

    nsize = 10
    varname = "array_2"
    call alloc_1d_real(array_2,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_3"
    call alloc_1d_real(array_3,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_4"
    call alloc_1d_real(array_4,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_5"
    call alloc_1d_real(array_5,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_6"
    call alloc_1d_real(array_6,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_7"
    call alloc_1d_real(array_7,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_8"
    call alloc_1d_real(array_8,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_9"
    call alloc_1d_real(array_9,nsize,varname,1,nsize) 

    nsize = 10 
    varname = "array_10"
    call alloc_1d_real(array_10,nsize,varname,1,nsize) 

    !variable initialization during the first run
    if(irun == 0)then
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
        call compute(4,4)
        write(0,*) 'Program values', array_1(1),array_2(1),array_3(1),array_4(1)
        !coordinated checkpoint 
        call chkpt_all(1)
    end do
    
    write(0,*)'End of benchmark. Bye!!'
end program micro

!Compute subroutine
subroutine compute(iter,elems)
use Global
integer iter,elems
do i = 1,iter
    do j = 1,elems
     array_1 = array_1 + 1
     array_2 = array_2 + 1
     array_3 = array_3 + 1
     array_4 = array_4 + 1
     array_5 = array_5 + 1
     array_6 = array_6 + 1
     array_7 = array_7 + 1
     array_8 = array_8 + 1
     array_9 = array_9 + 1
     array_10 = array_10 + 1
    end do
end do
end subroutine compute
  
