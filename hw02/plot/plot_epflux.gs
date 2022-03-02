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

"open ../gs_ctl_files/epflux.ctl"

"set zlog on"
"set lev 1000 10"

"set grads off"
"set parea 1.2 10 1.2 7.5"
"set ylevs 1000 750 500 250 100 75 50 25 10"
"set xlevs -60 -30 0 30 60"
"set gxout vector"
"color 0 400 25 -kind rainbow"
"set arrscl 0.2 200"
"set arrowhead 0.04"
"set arrlab off"
"set cthick 16"
"d maskout(skip(sfj,12,2)*10,mag(sfj,sfk)-10);sfk;mag(sfj,sfk)"

"set line 1 1 16"
"xcbar 10.1 10.25 2.2 6.5 -edge triangle -line on -fs 4 -ft 15 -fw 0.15 -fw 0.15"


"set line 0 1 16"
"draw recf 9.5 7 10 7.5"
"set line 1 1 16"
"draw rec 9.5 7 10 7.5"
rc=arrow(9.75,7.25,0.2,1)

"set string 1 c 15 90"
"set strsiz 0.2"
"draw string 0.5 4.35 log pressure [mb] "

"set string 1 c 15 0"
"set strsiz 0.2"
"draw string 5.6 0.5 latitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.22"
"draw string 5.6 7.8 EP flux 22 June 2021"

"printim epflux_20210622.png x2048 y1536"
"c"



function arrow(x,y,len,scale)
'set rgb 78 100 100 100'
'set line 78 1 16'
'draw line 'x-len/2.' 'y+0.1' 'x+len/2.' 'y+0.1
'draw line 'x+len/2.-0.07' 'y+0.1+0.05' 'x+len/2.' 'y+0.1
'draw line 'x+len/2.-0.07' 'y+0.1-0.05' 'x+len/2.' 'y+0.1
'set string 78 c'
'set strsiz 0.15'
'draw string 'x' 'y-0.1' 'scale
return
