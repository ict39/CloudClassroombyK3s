#!/bin/sh
echo "Content-type: text/html; charset=utf-8"
echo ""
parm=$(echo $QUERY_STRING | tr '=' ' ' | tr '&' ' ' )
a1=$(echo $parm | cut -d ' ' -f2 | sed -e "s/%\([0-9A-F][0-9A-F]\)/\\\\\x\1/g" | xargs -0 echo -e)
a2=$(echo $parm | cut -d ' ' -f4)
a3=$(echo $parm | cut -d ' ' -f6)
a4=$(echo $parm | cut -d ' ' -f8)
echo ""
mysql -uroot -proot -h sqldb -e "use datatest; insert into test values ('${a1}',${a2},${a3},${a4});"
echo $(mysql -uroot -proot -h sqldb -e "use datatest; select NAME,(CHINESE+ENGLISH+MATH)/3 as 總平均 FROM test group by NAME order by 總平均 desc limit 10;")
echo ""