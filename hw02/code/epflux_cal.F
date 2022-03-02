program epflux
use netcdf
implicit none

integer, parameter :: nx=1440,ny=721,nz=37,nt=24
!integer, parameter :: nx=144,ny=72,nz=37,nt=24
integer :: i,j,k,m,n,o,t
integer :: ierr,ncid1,varid1
real, parameter :: tripi=4.*atan(1.), a=6371137.
real :: dum1,dum2,dum3,dum4
real, dimension(nx) :: lon
real, dimension(ny) :: lat, f, fcos
real, dimension(nz) :: pres
real, dimension(nx,ny,nz,nt) :: u, v, tp, fj, fk
real, dimension(ny,nz,nt) :: ub, vb, tpb
real, dimension(nx,ny,nz) :: um, vm, tm
real, dimension(ny,nz) :: utb, vtb, tptb
real*4, dimension(ny,nz) :: fjb, fkb, sfjb, sfkb
character(200) :: path, filename

path="/data/der0318/work/ST"

write(filename,112) trim(path), "/data/hw1_210622.nc"
!write(filename,112) trim(path), "/data/hw1.nc"
112 format(2A)

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
fcos=cos(lat/360.*2*tripi)
!do j=1,ny
!  write(*,*) lat(j), f(j), fcos(j)
!enddo

! change hPa to Pa
pres=pres*100.

! read variables
ierr = nf90_inq_varid(ncid1,"u",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,u,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
u=u*dum1+dum2

ierr = nf90_inq_varid(ncid1,"v",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,v,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
v=v*dum1+dum2

ierr = nf90_inq_varid(ncid1,"t",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,tp,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,24 /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
tp=tp*dum1+dum2

ierr = nf90_close(ncid1)

!write(filename,112) trim(path), "/data/hw1_mon.nc"
!
!ierr = nf90_open(trim(filename),NF90_NOWRITE,ncid1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "open fail"
!
!! read variables
!ierr = nf90_inq_varid(ncid1,"u",varid1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
!ierr = nf90_get_var(ncid1,varid1,um,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,1 /))
!IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
!ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
!ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
!IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
!um=um*dum1+dum2
!
!ierr = nf90_inq_varid(ncid1,"v",varid1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
!ierr = nf90_get_var(ncid1,varid1,vm,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,1 /))
!IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
!ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
!ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
!IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
!vm=vm*dum1+dum2
!
!ierr = nf90_inq_varid(ncid1,"t",varid1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
!ierr = nf90_get_var(ncid1,varid1,tm,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,1 /))
!IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
!ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
!IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
!ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
!IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
!tm=tm*dum1+dum2


!write(*,*) lon
!write(*,*) t(720,360,37,:)

! calculation

! zonal mean
!ub=sum(u,1)/real(nx)
utb=sum(sum(u,4),1)/real(nx*nt)
!vb=sum(v,1)/real(nx)
vtb=sum(sum(v,4),1)/real(nx*nt)

do k=1,nz
  dum1=(1.e5/pres(k))**(2./7.)
  tp(:,:,k,:)=tp(:,:,k,:)*dum1
enddo

!tpb=sum(tp,1)/real(nx)
tptb=sum(sum(tp,4),1)/real(nx*nt)

!um=sum(u,4)/real(nt)
!vm=sum(v,4)/real(nt)
!tm=sum(tp,4)/real(nt)

do t=1,nt
do k=1,nz
do j=1,ny
do i=1,nx
  fj(i,j,k,t)=-(u(i,j,k,t)-utb(j,k))*(v(i,j,k,t)-vtb(j,k))*a*fcos(j)
  !fj(i,j,k,1)=-(um(i,j,k)-utb(j,k))*(vm(i,j,k)-vtb(j,k))*a*fcos(j)
  fk(i,j,k,t)=(v(i,j,k,t)-vtb(j,k))*(tp(i,j,k,t)-tptb(j,k))*f(j)*a*fcos(j)
  !fk(i,j,k,1)=(vm(i,j,k)-vtb(j,k))*(tm(i,j,k)-tptb(j,k))*f(j)*a*fcos(j)
enddo
enddo
enddo
enddo

fjb=sum(sum(fj,4),1)/real(nx*nt)!*real(nt)
fkb=sum(sum(fk,4),1)/real(nx*nt)!*real(nt)

do k=1,nz
do j=1,ny
  sfjb(j,k)=fjb(j,k)*fcos(j)/(tripi*a)
  if (k==1) then
    dum4=(tptb(j,k+1)-tptb(j,k))/(log(pres(k+1))-log(pres(k)))/(0.5*(pres(k+1)+pres(k))) 
  elseif (k==nz) then
    dum4=(tptb(j,k)-tptb(j,k-1))/(log(pres(k))-log(pres(k-1)))/(0.5*(pres(k)+pres(k-1)))
  else
    dum4=(tptb(j,k+1)-tptb(j,k-1))/(log(pres(k+1))-log(pres(k-1)))/(0.5*(pres(k+1)+pres(k-1)))
  endif
  fkb(j,k)=-fkb(j,k)/dum4
  sfkb(j,k)=fkb(j,k)*fcos(j)/1.e5
enddo
enddo

open(10,file="../data/epflux_data.dat",access="direct",recl=1)
n=1
do k=1,nz
do j=ny,1,-1
  write(10,rec=n) fjb(j,k)
  n=n+1
enddo
enddo
do k=1,nz
do j=ny,1,-1
  write(10,rec=n) fkb(j,k)
  n=n+1
enddo
enddo
do k=1,nz
do j=ny,1,-1
  write(10,rec=n) sfjb(j,k)
  n=n+1
enddo
enddo
do k=1,nz
do j=ny,1,-1
  write(10,rec=n) sfkb(j,k)
  n=n+1
enddo
enddo

close(10)

end program epflux
