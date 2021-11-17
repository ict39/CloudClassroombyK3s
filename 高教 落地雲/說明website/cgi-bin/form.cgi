#!/bin/sh
echo "Content-type: text/html; charset=utf-8"
echo ""
parm=$(echo $QUERY_STRING | tr '=' ' ')
a1=$(echo $parm | cut -d ' ' -f2)
[ ${a1} = "hadoop" ] && cat hadoop.html
[ ${a1} = "html" ] && cat html.html
[ ${a1} = "sql" ] && cat sql.html