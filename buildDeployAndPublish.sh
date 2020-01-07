#!/bin/bash

if  [[ $TRAVIS_PULL_REQUEST != 'false' ]] ; then
	echo "Finished (not packaging up source due to running in a pull request)."
	exit 0;
fi

BUILD_DIR=build/
PADDED_BUILD_NUMBER=`printf %05d $TRAVIS_BUILD_NUMBER`
GIT_BRANCH=$TRAVIS_TAG
VERSION_NUMBER="${GIT_BRANCH//v}.$PADDED_BUILD_NUMBER"
ZIP_FILE=$VERSION_NUMBER.zip

echo "Building CfFlow: CfFlow"
echo "======================================="
echo "GIT Branch      : $GIT_BRANCH"
echo "Version number  : $VERSION_NUMBER"
echo

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

echo "Copying files to $BUILD_DIR..."
rsync -a ./ --exclude=".*" --exclude="$BUILD_DIR" --exclude="*.sh" --exclude="*.log" --exclude="tests" --exclude="docs" "$BUILD_DIR" || exit 1
echo "Done."

cd $BUILD_DIR
echo "Inserting version number..."
sed -i "s/VERSION_NUMBER/$VERSION_NUMBER/" box.json
sed -i "s/DOWNLOAD_LOCATION/$ZIP_FILE/" box.json
echo "Done."

echo "Zipping up..."
zip -rq $ZIP_FILE * -x jmimemagic.log || exit 1
mv $ZIP_FILE ../
cd ../
find ./*.zip -exec aws s3 cp {} s3://pixl8-public-packages/cfflow/ --acl public-read \;

cd $BUILD_DIR;
CWD="`pwd`";

box forgebox login username="$FORGEBOXUSER" password="$FORGEBOXPASS";
box publish directory="$CWD";

echo "Build complete :)"
