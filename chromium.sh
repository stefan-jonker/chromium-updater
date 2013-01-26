#!/bin/bash
latest="$(curl --silent http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/LAST_CHANGE)" ;
svn="$(/usr/libexec/PlistBuddy -c 'print SVNRevision' /Applications/Chromium.app/Contents/Info.plist)" || echo "0" ;
scm="$(/usr/libexec/PlistBuddy -c 'print SCMRevision' /Applications/Chromium.app/Contents/Info.plist)" || echo "0" ;

if [ "$svn" != "0" ]
	then
		current=$svn ;
fi

if [ "$scm" != "0" ]
	then
		current=$scm ;
fi

if [ $latest -gt $current ]
	then 
		mv /Applications/Chromium.app /Applications/Chromium-$current.app ;

		cd ~/Downloads/ ;
		wget http://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac/$latest/chrome-mac.zip ;
		unzip -qq chrome-mac.zip ;
		mv chrome-mac/Chromium.app /Applications/Chromium.app ;

		rmdir chrome-mac ;
		rm chrome-mac.zip ;

		latestversion="$(/usr/libexec/PlistBuddy -c 'print CFBundleShortVersionString' /Applications/Chromium.app/Contents/Info.plist)" ;

		growlnotify -m "Updated Chromium to version $latestversion" ;
fi
