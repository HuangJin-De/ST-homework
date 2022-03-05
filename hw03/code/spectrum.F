program spectrum
use netcdf
use, intrinsic :: iso_c_binding
implicit none

include "fftw3.f03"
integer, parameter :: nx=1440,ny=721,nz=37,nt=43
integer :: i,j,k,m,n,o,t
integer :: ierr,ncid1,varid1
real :: dum1,dum2,dum3
real, parameter :: tripi=4.*atan(1.)
real, dimension(nx) :: lon
real, dimension(ny) :: lat, f, fcos
real, dimension(nz) :: pres
real, dimension(nx,ny,nz,nt) :: u
real, dimension(nx,ny,nz) :: um
real(C_DOUBLE) :: drdum2,drdum3
real(C_DOUBLE), dimension(nx) :: drdum1
complex(C_DOUBLE_COMPLEX) :: dcdum2
complex(C_DOUBLE_COMPLEX), dimension(nx/2+1) :: dcdum1
real, dimension(ny,nz,6) :: a_out ! array for output, 1=u mean, 
                                                    ! 2=u sp_1 A, 3=u sp_1 phase
                                                    ! 4=u sp_2 A, 5=u sp_2 phase
character(200) :: path,filename
type(c_ptr) :: plan_forward 

! how to compile
! ifort -free -O3 -mcmodel=large -shared-intel -heap-arrays 10 spectrum.F
! -I$HOME/.local/include -L$HOME/.local/lib -lfftw3 -lnetcdff

path="/data/der0318/work/ST/hw03/"

write(filename,122) trim(path),"/data/hw03_mon.nc"
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
ierr = nf90_inq_varid(ncid1,"u",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,u,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
u=u*dum1+dum2

! temporal mean
um=sum(u,4)/real(nt)

! zonal mean 
a_out(:,:,1)=sum(um,1)/real(nx)

! wave number 1 and 2
plan_forward=fftw_plan_dft_r2c_1d(nx,drdum1,dcdum1,FFTW_ESTIMATE)
do k=1,nz
do j=1,ny
  drdum1=dble(um(:,j,k))
  call fftw_execute_dft_r2c(plan_forward,drdum1,dcdum1)
  dcdum1=dcdum1/dble(nx)
  a_out(j,k,2)=abs(dcdum1(2)) 
  drdum2=dble(dcdum1(2))
  drdum3=aimag(dcdum1(2))
  a_out(j,k,3)=atan2(drdum3,drdum2)/tripi*180.
  if (a_out(j,k,3)<=0.) a_out(j,k,3)=a_out(j,k,3)+360.
  !write(*,*) dcdum1(1:3) !j,k, drdum2, drdum3, a_out(j,k,3)
  a_out(j,k,4)=abs(dcdum1(3))
  drdum2=dble(dcdum1(3))
  drdum3=aimag(dcdum1(3))
  a_out(j,k,5)=atan2(drdum3,drdum2)/tripi*180.
  if (a_out(j,k,5)<=0.) a_out(j,k,5)=a_out(j,k,5)+360.

  !if (k==30 .and. j==360) then
  !  do i=1,nx/2+1
  !  write(*,*) i-1, cdum1(i)
  !  enddo
  !endif
enddo
enddo
call fftw_free(plan_forward)

open(10,file=trim(path)//"/data/u_sp_data.dat",access="direct",recl=1)
n=1
do m=1,5
do k=1,nz
do j=ny,1,-1
  write(10,rec=n) a_out(j,k,m)
  n=n+1
enddo
enddo
enddo
close(10)

end program spectrum
