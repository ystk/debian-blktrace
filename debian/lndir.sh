#!/bin/sh

# very small shellscript that more or less implements the lndir of xutils-dev
# it recursively links all files from the directory specified in the first
# argument to the directory in the second argument;

# it probably won't work for exotic filenames

set -e

# need 2 arguments
test -n "$1" || exit -1
test -n "$2" || exit -1

FROM=$1
TO=$2

# check that both arguments are directories
test -d $FROM  || exit -1
test -d $TO || exit -1

# convert the dirs to absolute pathnames
FROM=$( cd $FROM && pwd )
TO=$( cd $TO && pwd )

# check that the dirs are not the smae
test "$FROM" = "$TO" && exit -1

# make a directory structure
( cd $FROM && find -type d \! -name '.' \! -name '..' -print0 ) | ( cd $TO && xargs -0 mkdir )

# make links to regular files
( cd $FROM && find -type f -print ) | \
while read file; do
	#echo $file
	ln -sf $FROM/$file  $TO/$file
done;

exit 0
