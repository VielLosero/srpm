
# find file path 
where(){
  if [ $# == 1 ] ; then
    RESULT=$(type $1 | cut -d" " -f3) || RESULT=$(which $1)
    echo "$RESULT"
  fi
}

get_tool(){
for tool in curl wget rsync ; do
  TOOL=$(where $tool)
  echo $TOOL
  [[ ! -z $TOOL ]] && break
done
}

if [ "$DOWNLOADER" = "curl" ]; then
  DOWNLOADER="curl ${CURLFLAGS} -o"
elif [ "$DOWNLOADER" = "wget" ]; then
  DOWNLOADER="wget ${WGETFLAGS} -O"
elif
  DOWNLOADER="rsync ${WGETFLAGS} "
else
  echo "Downloader tool not found."
fi
                          




