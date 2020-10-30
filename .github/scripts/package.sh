#!/bin/bash

BUILD_DIR=build/
VERSION_NUMBER=${RELEASE_VERSION}
ZIP_FILE="${RELEASE_VERSION/+/-}.zip"

echo "Building CfFlow: CfFlow"
echo "======================================="
echo "Version number : $VERSION_NUMBER"
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