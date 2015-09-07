#!/bin/bash
#
#	The MIT License (MIT)
#
#	Copyright (c) 2015 LRZ / Christoph Ostermeier
#
#	Permission is hereby granted, free of charge, to any person obtaining a copy
#	of this software and associated documentation files (the "Software"), to deal
#	in the Software without restriction, including without limitation the rights
#	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#	copies of the Software, and to permit persons to whom the Software is
#	furnished to do so, subject to the following conditions:
#
#	The above copyright notice and this permission notice shall be included in all
#	copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#	SOFTWARE.


#	Run it as $AutoPkgUser or Root (while adjusting the ROOTDIR variable)

ROOTDIR="Library/AutoPkg/Cache"
cd ${ROOTDIR}
for RECIPE_CACHE_DIR in $(ls -d */)
do
	# move inside the CACHE_DIR to avoid excessive variable use.
	cd ${RECIPE_CACHE_DIR}
	# check if there is an pkg inthere, if not ignore the dir.
	if [ "$(ls |grep -E '\.pkg')" == "" ]
	then
		cd ..
		continue
	fi
	# if there is an .pkg.zip the 2 newest files are excluded, else only one is excluded
	if [ "$(ls |grep '\.pkg.zip')" != "" ]
	then
		headsize=2
	else
		headsize=1
	fi
	# find out which "goodfiles" we have, prepare them for Regex-matches
	# this will probably crash on a "Office Something Update.pkg" because of the spaces.
	goodfiles="$(ls -t | grep -E '(.*\.pkg(\.zip)?$)' |head -n ${headsize})"
	goodfiles="$(echo $goodfiles |sed 's| |\||')"
	# find the files to remove by getting a negative list of them
	rmfiles=$(ls |grep "\.pkg" |grep -v -E "($goodfiles)" )
	# loop through them, delete em.
	if [ "${rmfiles}" != "" ]
	then
		for file in ${rmfiles}
		do
			rm -rf "${file}"
		done
	fi
	# move back in the dir structure
	cd ..
done

