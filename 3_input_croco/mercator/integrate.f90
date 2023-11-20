!####################################################################
subroutine integrate(nlon,nlat,ndepth,ntime,depth,field_in,field_out)
!####################################################################
  !
  ! to compile this subroutine:
  ! sudo f2py -c routine.f90 -m module_name
  !
  ! use in python 
  ! import module_name
  !
  ! input/output arguments
  !
  integer,                             intent(in)  :: nlon, nlat, ndepth, ntime
  real,    dimension(:),               intent(in)  :: depth
  real,    dimension(:,:,:,:),         intent(in)  :: field_in
  real,    dimension(ntime,nlat,nlon), intent(out) :: field_out
  !
  ! local variables
  !
  integer                          :: ind_lon, ind_lat, ind_dpt, ind_tim
  real, dimension(ntime,nlat,nlon) :: depth_int
  !
  write(*,*) 'nlon, nlat, ndepth, ntime = ', nlon, nlat, ndepth, ntime
  write(*,*) 'field_in(1,1,1,1)         = ', field_in(1,1,1,1)
  write(*,*) 'field_in(1,1,101,101)     = ', field_in(1,1,101,101) 
  !
  do ind_tim=1,ntime
    do ind_lon=1,nlon    
      do ind_lat=1,nlat
        do ind_dpt=1,ndepth-1
          !
          ! qd passage de python a fortran90 : NaN devient soit 0.0 soit -32767.0
          if ( (field_in(ind_tim,ind_dpt+1,ind_lat,ind_lon) .eq. 0.0)      .or. &
               (field_in(ind_tim,ind_dpt+1,ind_lat,ind_lon) .eq. -32767.0) .or. &
               (field_in(ind_tim,ind_dpt,ind_lat,ind_lon)   .eq. 0.0)      .or. &
               (field_in(ind_tim,ind_dpt,ind_lat,ind_lon)   .eq. -32767.0) ) then
            !
            field_out(ind_tim,ind_lat,ind_lon) = field_out(ind_tim,ind_lat,ind_lon)+0.0
            !
          else
            ! 
            field_out(ind_tim,ind_lat,ind_lon) = field_out(ind_tim,ind_lat,ind_lon)+          &
                                                 abs(depth(ind_dpt+1)-depth(ind_dpt))*        &
                                                 (field_in(ind_tim,ind_dpt+1,ind_lat,ind_lon) &
                                                 -field_in(ind_tim,ind_dpt,ind_lat,ind_lon))
            !
            depth_int(ind_tim,ind_lat,ind_lon) = depth(ind_dpt+1)
            !
          end if
        end do     
      end do
    end do
  end do
  !
  field_out(:,:,:) = field_out(:,:,:)/abs(depth_int(:,:,:))
  !
end subroutine integrate
