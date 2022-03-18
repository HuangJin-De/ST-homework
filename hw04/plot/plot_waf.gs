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

"sdfopen ../data/WAF_data.nc"

"set lev 200"

"set grads off"
"set parea 1.2 10 1.2 7.5"
"set xlint 60"
"set ylint 30"
"color -400 400 20 -kind darkblue->blue->cyan->white->white->yellow->red->darkred"
"set gxout grfill"
"d za"

"set gxout vector"
"set cthick 16"
"set arrlab off"
"set ccolor 1"
"set arrowhead 0.055"
"set arrscl 0.1 50"
"define a=mag(cpx,cpy)"
"define cx=maskout(cpx,a-50.)"
"define cy=maskout(cpy,a-50.)"
"d skip(cx,36,18);cy"

"set line 0 1 16"
"draw recf 9.5 6.5 10 7"
"set line 1 1 16"
"draw rec 9.5 6.5 10 7"
rc=arrow(9.75,6.75,0.2,100)

"set line 1 1 17"
"xcbar 10.1 10.25 2.2 6.5 -edge triangle -line on -fs 4 -ft 15 -fw 0.15 -fw 0.15"

"set string 1 c 15 90"
"set strsiz 0.2"
"draw string 0.5 4.35 latitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.2"
"draw string 5.6 1 longitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.22"
"draw string 5.6 7.3 Wave activity flux [3 March 2022]"

"printim waf_200hPa.png x2048 y1536"
"c"

"set lon 150"
"set z 1 37"
"set zlog on"

"set grads off"
"set parea 1.2 10 1.2 7.5"
"set xlint 30"
"set ylevs 1000 750 500 250 100 75 50 25 10 7 5 2 1"
"color -400 400 20 -kind darkblue->blue->cyan->white->white->yellow->red->darkred"
"set gxout grfill"
"d za"

"set gxout vector"
"set cthick 16"
"set arrlab off"
"set ccolor 1"
"set arrowhead 0.055"
"set arrscl 0.1 50"
"define a=mag(cpy,cpz*100.)"
"define cy=maskout(cpy,a-50.)"
"define cz=maskout(cpz*100.,a-50.)"
"d skip(cy,18,1);cz"

"set line 0 1 16"
"draw recf 9.5 7 10 7.5"
"set line 1 1 16"
"draw rec 9.5 7 10 7.5"
rc=arrow(9.75,7.25,0.2,100)

"set line 1 1 17"
"xcbar 10.1 10.25 2.2 6.5 -edge triangle -line on -fs 4 -ft 15 -fw 0.15 -fw 0.15"

"set string 1 c 15 90"
"set strsiz 0.2"
"draw string 0.5 4.35 pressure [hPa]"

"set string 1 c 15 0"
"set strsiz 0.2"
"draw string 5.6 0.5 latitude [degree]"

"set string 1 c 15 0"
"set strsiz 0.22"
"draw string 5.6 7.8 Wave activity flux [3 March 2022]"

"printim waf_150e.png x2048 y1536"
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
