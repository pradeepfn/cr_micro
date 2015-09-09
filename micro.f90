program micro
    use Allocator

    real, pointer :: array_one(:)
    real, pointer :: array_two(:,:)
    real, pointer :: array_thr(:)

    real, pointer :: nstep
    integer, pointer :: istep
    CHARACTER(LEN=10) varname
    integer :: length
    integer :: cmtsize
    integer :: fix_d
    !we should be able to change the compute time and data sizes independently
    ! comp_step - controls the compute budget of the program
    ! data_size - controls the data size the program outputs
    ! irun - flas to identify fresh/restart run

    namelist /control/ comp_step,data_size,irun
    integer :: i


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

    !allocate from phoenix lib 
    nsize = 10 
    varname = "array_one"
    call alloc_1d_real(array_one,nsize,varname,1,nsize) 

    nsize = 10*fix_d
    varname = "array_two"
    call alloc_2d_real(array_two,nsize,,varname,1,nsize) 

    nsize = 10 
    varname = "array_thr"
    call alloc_1d_real(array_thr,nsize,varname,1,nsize) 

    !Do some heavy computations, checkpoint after each iter
    do i = 1, 10
        call compute()
        !coordinated checkpoint 
        call chkpt_all(1)
    end do
    
    write(0,*)'End of benchmark. Bye!!'


   !Compute subroutine
    subroutine compute(iter,elems)
    integer iter,elems
    do i = 1,elems


    end do
    end
    
end program micro
