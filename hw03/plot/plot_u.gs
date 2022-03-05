"reinit"
"set display color white"
"c"

"set lwid 13 16"
"set lwid 14 26"
"set lwid 15 10"
"set lwid 16 6"
"set lwid 17 3"
"set lwid 18 8"
"set annot 1 16"
"set strsiz 0.19"
"set xlopts 1 16 0.15"
"set ylopts 1 16 0.15"
"set clopts 1 16 0.15"
"set rgb 201 100 100 100 150"
"set grid on 3 201 12"
*"set grid off"

"set font 11 file /home/der0318/.grads/Helvetica.ttf"

"open ../gs_ctl_files/u_sp.ctl"

"set zlog on"
"set lev 1000 1"

"set grads off"
"set parea 1.2 10 1.2 7.5"
"set ylevs 1000 750 500 250 100 75 50 25 10 7 5 2 1"
"set xlevs -60 -30 0 30 60"
"color -60 60 5 -kind darkblue->blue->cyan->white->white->yellow->red->darkred"
"set gxout grfill"
"d um"

"set line 1 1 16"
"xcbar 10.1 10.25 2.2 6.5 -edge triangle -line on -fs 4 -ft 15 -fw 0.15 -fw 0.15"

"set string 1 c 15 90"
"set strsiz 0.2"
"draw string 0.5 4.35 log pressure [mb] "

"set string 1 c 15 0"
"set strsiz 0.2"
"draw string 5.6 0.5 latitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.22"
"draw string 5.6 7.8 Zonal-mean U [Jan]"

"printim um_jan.png x2048 y1536"
"c"


"set grads off"
"set parea 1.2 10 1.2 7.5"
"set ylevs 1000 750 500 250 100 75 50 25 10 7 5 2 1"
"set xlevs -60 -30 0 30 60"
"color 0 16 1 -kind white->p31->p32->p33->p34->p35->p36->p38->p39->p310->p311"
"set gxout grfill"
"d a1"

"set line 1 1 16"
"xcbar 10.1 10.25 2.2 6.5 -edge triangle -line on -fs 4 -ft 15 -fw 0.15 -fw 0.15"

"set string 1 c 15 90"
"set strsiz 0.2"
"draw string 0.5 4.35 log pressure [mb] "

"set string 1 c 15 0"
"set strsiz 0.2"
"draw string 5.6 0.5 latitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.22"
"draw string 5.6 7.8 Wave amplitude of wavenumber 1 [Jan]"

"printim u_a1_jan.png x2048 y1536"
"c"


"set grads off"
"set parea 1.2 10 1.2 7.5"
"set ylevs 1000 750 500 250 100 75 50 25 10 7 5 2 1"
"set xlevs -60 -30 0 30 60"
"color 0 16 1 -kind white->p31->p32->p33->p34->p35->p36->p38->p39->p310->p311"
"set gxout grfill"
"d a2"

"set line 1 1 16"
"xcbar 10.1 10.25 2.2 6.5 -edge triangle -line on -fs 4 -ft 15 -fw 0.15 -fw 0.15"

"set string 1 c 15 90"
"set strsiz 0.2"
"draw string 0.5 4.35 log pressure [mb] "

"set string 1 c 15 0"
"set strsiz 0.2"
"draw string 5.6 0.5 latitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.22"
"draw string 5.6 7.8 Wave amplitude of wavenumber 2 [Jan]"

"printim u_a2_jan.png x2048 y1536"
"c"

