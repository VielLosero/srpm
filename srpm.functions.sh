
# Repository config file
REPO_CONFIG_FILE=/etc/srpm/srpm.repositories

# Get all diferent tags from repositories in repository config file
# A  tag is like the repository name
gettags_from_config_file(){
REPO_TAGS=$(cat $REPO_CONFIG_FILE | grep "^REPO_" | cut -d_ -f2 | sort -u)
}

# Get repository values from repoitory config file
getrepo_vars(){
  REPO_NAME=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_NAME" | cut -d= -f2 | tr -d '"')
  REPO_VERSION=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_VERSION" | cut -d= -f2 | tr -d '"')
  REPO_DB="$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_DBDIR" | cut -d= -f2 | tr -d '"')/${REPO_NAME}"
  # activate pkg db by make repo dir 
  [[ ! -d ${REPO_DB} ]] && mkdir -vp ${REPO_DB}
  REPO_SOURCE=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_SOURCE" | cut -d= -f2 | tr -d '"')
  SOURCE_TYPE="$(echo $REPO_SOURCE | cut -d: -f1 )"
  REPO_UPDATE=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_UPDATE" | cut -d= -f2 | tr -d '"')
  # sanity check if no UPDATE on config take SOURCE
  if [ -z $REPO_UPDATE ] ; then
    REPO_UPDATE=$REPO_SOURCE
  fi
  #echo "Get files from: $REPO_UPDATE"
  UPDATE_TYPE="$(echo $REPO_UPDATE | cut -d: -f1 )"
}

get_Changelog_date_and_packages_number(){
SOURCE_UPDATED="$(cat ${TMPDIR}/${REPO_NAME}/ChangeLog.txt  | head -1)"
SOURCE_PKGS="$(grep slack-desc ${TMPDIR}/${REPO_NAME}/CHECKSUMS.md5 | wc -l )"     
}

## # find file path 
## where(){
##   if [ $# == 1 ] ; then
##     RESULT=$(type $1 | cut -d" " -f3) || RESULT=$(which $1)
##     echo "$RESULT"
##   fi
## }
## 
## get_tool(){
## for tool in curl wget rsync ; do
##   TOOL=$(where $tool)
##   echo $TOOL
##   [[ ! -z $TOOL ]] && break
## done
## }
## 
## if [ "$DOWNLOADER" = "curl" ]; then
##   DOWNLOADER="curl ${CURLFLAGS} -o"
## elif [ "$DOWNLOADER" = "wget" ]; then
##   DOWNLOADER="wget ${WGETFLAGS} -O"
## elif [ "$DOWNLOADER" = "rsync" ]; then
##   DOWNLOADER="rsync ${RSYNCFLAGS} "
## else
##   echo "Downloader tool not found."
## fi
                          




