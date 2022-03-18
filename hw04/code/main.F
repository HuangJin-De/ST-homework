program main
use netcdf
implicit none

integer, parameter :: nx=1440,ny=721,nz=37,nt=1
integer :: i,j,k,m,n,o
real :: dum1,dum2,dum3
real, parameter :: tripi=4.*atan(1.), undef=-9.999e9
real, dimension(nx) :: lon
real, dimension(ny) :: lat, f, fcos
real, dimension(nz) :: lev
real, dimension(nx,ny,nz) :: z,u,v,t
real, dimension(nx,ny,nz) :: zb,ub,vb,tb
real, dimension(nx,ny,nz,4) :: cp
real, dimension(nx,ny,nz,5) :: ocp
real, dimension(nx,ny) :: sp
real, dimension(nt) :: ttt
integer :: ierr, ncid1, varid1, varid2, varid3, varid4, varid5, &
                       varid6, varid7, varid8, varid9
integer, dimension(3) :: id3d
integer, dimension(2) :: id2d, chunk
character(200) :: path,filename

! how to compile
! ifort -free -O3 -mcmodel=large -shared-intel -heap-arrays 10 spectrum.F
! -I$HOME/.local/include -L$HOME/.local/lib -lfftw3 -lnetcdff

path="/data/der0318/work/ST/hw04/"

write(filename,122) trim(path),"/data/hw04_day.nc"
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
ierr = nf90_get_var(ncid1,varid1,lev,start=(/ 1,1,1,1 /),count=(/ nz,1,1,1 /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
lev=lev*100.

! read single-day data
ierr = nf90_inq_varid(ncid1,"z",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,z,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
z=z*dum1+dum2
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
ierr = nf90_get_var(ncid1,varid1,t,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
t=t*dum1+dum2


! monthly averaged data
write(filename,122) trim(path),"/data/hw04_clim.nc"

ierr = nf90_open(trim(filename),NF90_NOWRITE,ncid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "open fail"

! read single-day data
ierr = nf90_inq_varid(ncid1,"z",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,zb,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
zb=zb*dum1+dum2
ierr = nf90_inq_varid(ncid1,"u",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,ub,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
ub=ub*dum1+dum2
ierr = nf90_inq_varid(ncid1,"v",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,vb,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
vb=vb*dum1+dum2
ierr = nf90_inq_varid(ncid1,"t",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,tb,start=(/ 1,1,1,1 /),count=(/ nx,ny,nz,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
tb=tb*dum1+dum2

! call subroutine to calculate WAF
call waf(nx,ny,nz,lon,lat,lev,z,u,v,t,zb,ub,vb,tb,cp)

! filter out the data below the topography
write(filename,122) trim(path),"/data/hw04_sur_day.nc"

ierr = nf90_open(trim(filename),NF90_NOWRITE,ncid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "open fail"

ierr = nf90_inq_varid(ncid1,"sp",varid1)
IF (ierr/=nf90_noerr) WRITE(*,*) "var_inq fail"
ierr = nf90_get_var(ncid1,varid1,sp,start=(/ 1,1,1,1 /),count=(/ nx,ny,1,nt /))
IF (ierr/=nf90_noerr) WRITE(*,*) "read fail"
ierr = nf90_get_att(ncid1, varid1, "scale_factor", dum1)
IF (ierr/=nf90_noerr) WRITE(*,*) "read scale fail"
ierr = nf90_get_att(ncid1, varid1, "add_offset", dum2)
IF (ierr/=nf90_noerr) WRITE(*,*) "read offset fail"
sp=sp*dum1+dum2

do k=1,nz
do j=1,ny
do i=1,nx
  if (lev(k)>=sp(i,j)) cp(i,j,k,:)=undef
enddo
enddo
enddo

! output for VAPOR
WRITE(filename,122) trim(path),"/data/WAF_data.nc"

ierr = nf90_create(trim(filename),&
                  cmode=nf90_netcdf4, ncid=ncid1)
ierr = nf90_def_dim(ncid1, "lon", nx, varid1)
ierr = nf90_def_dim(ncid1, "lat", ny, varid2)
ierr = nf90_def_dim(ncid1, "lev", nz, varid3)
ierr = nf90_def_dim(ncid1, "time", nt, varid4)

ierr = nf90_def_var(ncid1, "lon", NF90_REAL, varid1, varid5)
ierr = nf90_put_att(ncid1, varid5, 'axis', 'X')
ierr = nf90_put_att(ncid1, varid5, 'long_name', 'longitude')
ierr = nf90_put_att(ncid1, varid5, 'units', 'degrees_east')

ierr = nf90_def_var(ncid1, "lat", NF90_REAL, varid2, varid6)
ierr = nf90_put_att(ncid1, varid6, 'axis', 'Y')
ierr = nf90_put_att(ncid1, varid6, 'long_name', 'latitude')
ierr = nf90_put_att(ncid1, varid6, 'units', 'degrees_north')

ierr = nf90_def_var(ncid1, "lev", NF90_REAL, varid3, varid7)
ierr = nf90_put_att(ncid1, varid7, 'axis', 'Z')
ierr = nf90_put_att(ncid1, varid7, 'long_name', 'air_pressure')
ierr = nf90_put_att(ncid1, varid7, 'units', 'hPa')
ierr = nf90_put_att(ncid1, varid7, 'positive', 'down')

ierr = nf90_def_var(ncid1, "time", NF90_REAL, varid4, varid8)
ierr = nf90_put_att(ncid1, varid8, 'axis', 'T')
ierr = nf90_put_att(ncid1, varid8, 'long_name', 'time')
ierr = nf90_put_att(ncid1, varid8, 'standard_name', 'time')
ierr = nf90_put_att(ncid1, varid8, 'units', 'minutes since 1900-01-01 00:00')

id3d=(/ varid1,varid2,varid3 /)
id2d=(/ varid1,varid2 /)

chunk=(/ nx,ny /)

ierr = nf90_def_var(ncid1,"sp",NF90_REAL,id2d,varid9)
ierr = nf90_def_var_chunking(ncid1,varid9,NF90_CHUNKED, chunk)
ierr = nf90_def_var_deflate(ncid1,varid9,shuffle=1, deflate=1,deflate_level=2)
ierr = nf90_put_att(ncid1,varid9,'missing_value',undef)
ierr = nf90_def_var(ncid1,"cpx",NF90_REAL,id3d,varid9)
ierr = nf90_def_var_chunking(ncid1,varid9,NF90_CHUNKED, chunk)
ierr = nf90_def_var_deflate(ncid1,varid9,shuffle=1, deflate=1,deflate_level=2)
ierr = nf90_put_att(ncid1,varid9,'missing_value',undef)
ierr = nf90_def_var(ncid1,"cpy",NF90_REAL,id3d,varid9)
ierr = nf90_def_var_chunking(ncid1,varid9,NF90_CHUNKED, chunk)
ierr = nf90_def_var_deflate(ncid1,varid9,shuffle=1, deflate=1,deflate_level=2)
ierr = nf90_put_att(ncid1,varid9,'missing_value',undef)
ierr = nf90_def_var(ncid1,"cpz",NF90_REAL,id3d,varid9)
ierr = nf90_def_var_chunking(ncid1,varid9,NF90_CHUNKED, chunk)
ierr = nf90_def_var_deflate(ncid1,varid9,shuffle=1, deflate=1,deflate_level=2)
ierr = nf90_put_att(ncid1,varid9,'missing_value',undef)
ierr = nf90_def_var(ncid1,"za",NF90_REAL,id3d,varid9)
ierr = nf90_def_var_chunking(ncid1,varid9,NF90_CHUNKED, chunk)
ierr = nf90_def_var_deflate(ncid1,varid9,shuffle=1, deflate=1,deflate_level=2)
ierr = nf90_put_att(ncid1,varid9,'missing_value',undef)
ierr = nf90_def_var(ncid1,"st",NF90_REAL,id3d,varid9)
ierr = nf90_def_var_chunking(ncid1,varid9,NF90_CHUNKED, chunk)
ierr = nf90_def_var_deflate(ncid1,varid9,shuffle=1, deflate=1,deflate_level=2)
ierr = nf90_put_att(ncid1,varid9,'missing_value',undef)

ierr = nf90_enddef(ncid1)

ttt = 0.

lev=lev/100.
sp=sp/100.

ocp(:,:,1:nz,1:4)=cp
ocp(:,:,1:nz,5)=sqrt(cp(:,:,:,1)**2.+cp(:,:,:,2)**2.+cp(:,:,:,3)**2.)
where(ocp(:,:,:,1)==undef .or. ocp(:,:,:,2)==undef &
      .or. ocp(:,:,:,3)==undef) ocp(:,:,:,5)=undef

ierr = nf90_put_var(ncid1,varid5,lon)
ierr = nf90_put_var(ncid1,varid6,lat)
ierr = nf90_put_var(ncid1,varid7,lev)
ierr = nf90_put_var(ncid1,varid8,ttt)

ierr = nf90_inq_varid(ncid1,'sp',varid9)
ierr = nf90_put_var(ncid1,varid9,sp(:,:))
ierr = nf90_inq_varid(ncid1,'cpx',varid9)
ierr = nf90_put_var(ncid1,varid9,ocp(:,:,:,1))
ierr = nf90_inq_varid(ncid1,'cpy',varid9)
ierr = nf90_put_var(ncid1,varid9,ocp(:,:,:,2))
ierr = nf90_inq_varid(ncid1,'cpz',varid9)
ierr = nf90_put_var(ncid1,varid9,ocp(:,:,:,3))
ierr = nf90_inq_varid(ncid1,'za',varid9)
ierr = nf90_put_var(ncid1,varid9,ocp(:,:,:,4))
ierr = nf90_inq_varid(ncid1,'st',varid9)
ierr = nf90_put_var(ncid1,varid9,ocp(:,:,:,5))

ierr = nf90_close(ncid1)

end program main

