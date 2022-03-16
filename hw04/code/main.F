program main
use netcdf
implicit none

integer, parameter :: nx=1440,ny=721,nz=37,nt=1
integer :: i,j,k,m,n,o,t
integer :: ierr,ncid1,varid1
real :: dum1,dum2,dum3
real, parameter :: tripi=4.*atan(1.)
real, dimension(nx) :: lon
real, dimension(ny) :: lat, f, fcos
real, dimension(nz) :: pres
real, dimension(nx,ny,nz,nt) :: z
real, dimension(ny,nz,nt) :: zm
real, dimension(ny,nz,6) :: a_out ! array for output, 1=u mean, 
                                                    ! 2=u sp_1 A, 3=u sp_1 phase
                                                    ! 4=u sp_2 A, 5=u sp_2 phase
character(200) :: path,filename

! how to compile
! ifort -free -O3 -mcmodel=large -shared-intel -heap-arrays 10 spectrum.F
! -I$HOME/.local/include -L$HOME/.local/lib -lfftw3 -lnetcdff

path="/data/der0318/work/ST/hw04/"

write(filename,122) trim(path),"/data/hw04_daily.nc"
122 format(2A)


ierr = nf90_open(trim(filename),NF90_NOWRITE,ncid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "open fail"

! read dimensions
ierr = nf90_inq_varid(ncid1,"longitude",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,lon,start=(/ 1,1,1,1 /),count=(/ nx,1,1,1 /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_inq_varid(ncid1,"latitude",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,lat,start=(/ 1,1,1,1 /),count=(/ ny,1,1,1 /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_inq_varid(ncid1,"level",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,pres,start=(/ 1,1,1,1 /),count=(/ nz,1,1,1 /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"

! coriolis constants
f=2*2*tripi/86400.*sin(lat/360.*2*tripi)

! change hPa to Pa
pres=pres*100.

! read zonal
ierr = nf90_inq_varid(ncid1,"z",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,z,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
z=z*dum1+dum2

! zonal mean 
zm=sum(z,1)/real(nx)


! call subroutine to calculate WAF
call waf(nx,ny,nz)


!open(10,file=trim(path)//"/data/u_sp_data.dat",access="direct",recl=1)
!n=1
!do m=1,5
!do k=1,nz
!do j=ny,1,-1
!  write(10,rec=n) a_out(j,k,m)
!  n=n+1
!enddo
!enddo
!enddo
!close(10)

end program main

