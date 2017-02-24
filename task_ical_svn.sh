#!/bin/sh
usr="$1"
printf "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Google Inc//Google Calendar 70.9054//EN\n" > header.txt
printf "END:VCALENDAR\n" > tail.txt
(cat header.txt & svn log -r '{'$2'}':'{'$3'}'\
 |sed '1d' | sed 's/^-\+/\;/' | sed -r '/ /{:a;N;s/[\t\n]/|/g;/\;/!ba}'\
  |awk -v "usrname=$usr" '{l=split($0,a,"|" ); if(match(a[2],usrname)>0)\
  {text=a[1]"" ; for(i=6;i<l;++i){text=text" "a[i];} \
	  st=substr(a[3],13,5);dt=st+1;dt=dt""substr(st,4,4);\
          sd =substr(a[3],1,11);gsub("-","",sd);\
	  gsub(":","",st);gsub(":","",dt);\
	  printf("BEGIN:VEVENT\nDTSTART;TZID=/Asia/Shanghai:%sT%s00\nDTEND;TZID=/Asia/Shanghai:%sT%s00\nSUMMARY:%s\nCLASS:PUBLIC\nEND:VEVENT\n",sd,st\
	  ,sd,dt,text)}\
          }'\
	  ) | cat - tail.txt  > $1_$2_$3.csv
