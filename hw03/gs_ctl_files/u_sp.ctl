DSET ^../data/u_sp_data.dat
OPTIONS zrev
TITLE thermodynamic variables
UNDEF -999.99
XDEF   1 LINEAR 0 2
YDEF 721 LINEAR -90 0.25
ZDEF 37 LEVELS 1000 975 950 925 900 875 850 825 800 775 750 700 650 600 550 500 450 400 350 300 250 225 200 175 150 125 100 70 50 30 20 10 7 5 3 2 1
TDEF  1 LINEAR 00:00Z01JAN2000 1mn
VARS 5
um 37 99 zonal mean of u
a1 37 99 A for wavenumber 1
p1 37 99 phase for wavenumber 1
a2 37 99 A for wavenumber 2
p2 37 99 phase for wavenumber 2
ENDVARS
