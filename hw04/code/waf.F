subroutine waf(nx,ny,nz,lon,lat,lev,z,u,v,t,zb,ub,vb,tb,cp)
! This subroutine calculate WAF following the formulation provided
! in Takaya and Nakamura (2001), and the second-order finite difference
! method is used to approximate derivatives except for the boundaries. 
implicit none

! input/output
integer, intent(in) :: nx,ny,nz
real, dimension(nx), intent(in) :: lon ! degree (o)
real, dimension(ny), intent(in) :: lat ! degree (o)
real, dimension(nz), intent(in) :: lev ! pressure (Pa)
real, dimension(nx,ny,nz), intent(in) :: z, u, v, t      ! total fields 
real, dimension(nx,ny,nz), intent(in) :: zb, ub, vb, tb  ! mean fields
real, dimension(nx,ny,nz,4), intent(out) :: cp ! 3D WAF and QG SF

! local variables
integer :: i,j,k,ip,im,jp,jm,kp,km
real, parameter :: undef=-9.999e9, tripi=4.*atan(1.), grav=9.806, &
                   r_earth=6371137., h_ref=7400., t_ref=290., rgas=287.047
real, dimension(nx) :: lambda
real, dimension(ny) :: f, fcos
real, dimension(ny) :: phi
real, dimension(nz) :: npres ! normalized pressure
real :: dlam, dphi
real :: dum1,dum2,dum3
real, dimension(nx,ny,nz) :: za, ua, va, ta  ! anomalies

!write(*,*) nx,ny,nz 

cp=0.

dlam=(lon(2)-lon(1))*tripi/180.
dphi=(lat(2)-lat(1))*tripi/180.

do i=1,nx
  lambda(i)=lon(i)*tripi/180.
  !write(*,*) lon(i), lambda(i)
enddo

do j=1,ny
  phi(j)=lat(j)*tripi/180.
  f(j)=2*2*tripi/86400.*sin(phi(j))
  fcos(j)=cos(phi(j))
  !write(*,*) phi(j), f(j), fcos(j)
enddo

do k=1,nz
  npres(k)=(lev(k)/100000.)
enddo

! QG stramfunction
do j=1,ny
  za(:,j,:)=(z(:,j,:)-zb(:,j,:))/f(j) 
enddo
ua=u-ub
va=v-vb
ta=t-tb

k_loop: do k=1,nz
  kp=k+1
  km=k-1
  if (kp>nz) kp=nz
  if (km<1) km=1

  ! skip the grid point nearth pole 
  j_loop: do j=1,ny
    jp=j+1
    jm=j-1
    if (jp>ny) jp=ny
    if (jm<1) jm=1

    i_loop: do i=1,nx
      ip=i+1
      im=i-1
      ! periodic in zonal direction
      if (ip>nx) ip=ip-nx
      if (im<1) im=im+nx
         
      !dum1=((za(ip,j,k)-za(im,j,k))/(2.*dlam))**2 &
      !    -za(i,j,k)*(za(ip,j,k)-2*za(i,j,k)+za(im,j,k))/dlam**2
      !dum2=(za(ip,j,k)-za(im,j,k))/(2.*dlam)*(za(i,jp,k)-za(i,jm,k))/(2.*dphi) &
      !    -za(i,j,k)*((za(ip,jp,k)-za(im,jp,k))/(2.*dlam)-(za(ip,jm,k)-za(im,jm,k))/(2.*dlam))/(2.*dphi)
      !dum3=((za(i,jp,k)-za(i,jm,k))/(2.*dphi))**2 &
      !    -za(i,j,k)*(za(i,jp,k)-2*za(i,j,k)+za(i,jm,k))/dphi**2
  
      !cp(i,j,k,1)=ub(i,j,k)/((r_earth*fcos(j))**2)*dum1&
      !           +vb(i,j,k)/(r_earth**2*fcos(j))*dum2
      !
      !cp(i,j,k,2)=ub(i,j,k)/(r_earth**2*fcos(j))*dum2&
      !           +vb(i,j,k)/(r_earth**2)*dum3

      cp(i,j,k,1)=ub(i,j,k)*(va(i,j,k)**2) &
                 -ub(i,j,k)*za(i,j,k)/(r_earth*fcos(j))*(va(ip,j,k)-va(im,j,k))/(lambda(ip)-lambda(im)) &
                 -vb(i,j,k)*va(i,j,k)*ua(i,j,k) &
                 +vb(i,j,k)*za(i,j,k)/(r_earth*fcos(j))*(ua(ip,j,k)-ua(im,j,k))/(lambda(ip)-lambda(im))

      cp(i,j,k,2)=-ub(i,j,k)*va(i,j,k)*ua(i,j,k) &
                  +ub(i,j,k)*za(i,j,k)/(r_earth*fcos(j))*(ua(ip,j,k)-ua(im,j,k))/(lambda(ip)-lambda(im)) &
                  +vb(i,j,k)*ua(i,j,k)**2 &
                  +vb(i,j,k)*za(i,j,k)/r_earth*(ua(i,jp,k)-ua(i,jm,k))/(phi(jp)-phi(jm))

      !dum1=-grav/(rgas*tb(i,j,k)) &
      !     *(tb(i,j,kp)*npres(kp)**(-2./7.)-tb(i,j,km)*npres(km)**(-2./7.)) &
      !     /(log(lev(kp))-log(lev(km))) ! dtheta/dz      

      !dum2=rgas*npres(k)**(2./7.)/h_ref*dum1 ! N^2
      !dum3=f(j)/dum2
      !write(*,*) '1: ',dum1,dum2,dum3 

      dum1=(tb(i,j,kp)-tb(i,j,km))/(-h_ref*alog(npres(kp)/npres(km)))
      dum2=t_ref/h_ref*(dum1+2./7./h_ref*tb(i,j,k))
      dum3=f(j)*grav/(dum2*t_ref)
      !write(*,*) '2: ',dum1,dum2,dum3

      cp(i,j,k,3)=dum3*&
                 (ub(i,j,k)*va(i,j,k)*ta(i,j,k) &
                 -ub(i,j,k)*za(i,j,k)/(r_earth*fcos(j))*(ta(ip,j,k)-ta(im,j,k))/(lambda(ip)-lambda(im)) &
                 -vb(i,j,k)*ua(i,j,k)*ta(i,j,k) &
                 -vb(i,j,k)*za(i,j,k)/r_earth*(ta(i,jp,k)-ta(i,jm,k))/(phi(jp)-phi(jm)))
      !write(*,*) ub(i,j,k)*va(i,j,k)*ta(i,j,k), dum3

      dum1=max(sqrt(ub(i,j,k)**2+vb(i,j,k)**2),0.2) ! wind speed
      cp(i,j,k,1:3)=npres(k)*fcos(j)/(2.*dum1)*cp(i,j,k,1:3)
      
      cp(i,j,k,4)=za(i,j,k)*f(j)/grav
    enddo i_loop
    if (abs(lat(j))<=5.) cp(:,j,k,1:3)=undef
  enddo j_loop 
enddo k_loop

end subroutine waf
