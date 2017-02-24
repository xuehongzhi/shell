#!/bin/sh
usr="$1"
daterange="$2 to $3"
printf "$daterange"
printf "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//Google Inc//Google Calendar 70.9054//EN\n" > header.txt
printf "END:VCALENDAR\n" > tail.txt
(cat header.txt & hg log --encoding utf-8 -u $usr -d "$daterange" --template '{date|isodate}\t{splitlines(desc) % "{line};"}\n'\
  |awk -F'\t' '{text=$2;\
	  st=substr($1,12,5);dt=st+1;dt=dt""substr(st,4,4);\
          sd =substr($1,1,10);gsub("-","",sd);\
	  gsub(":","",st);gsub(":","",dt);\
	  printf("BEGIN:VEVENT\nDTSTART;TZID=/Asia/Shanghai:%sT%s00\nDTEND;TZID=/Asia/Shanghai:%sT%s00\nSUMMARY:%s\nCLASS:PUBLIC\nEND:VEVENT\n",sd,st\
	  ,sd,dt,text)\
          }'\
	  ) | cat - tail.txt  > $1_$2_$3.csv
