#!/bin/sh

# For benefit of log files.
echo pwd = `pwd`
echo $0 $*
# Make sure bash fails completely if any command fails
set -e

# One way to make sure the simulator isn't already running.
osascript -e 'tell app "iPhone Simulator" to quit'

SCRIPT_NAME=$1
if [ -z $1 ]
then
	echo "USAGE: run_uiautomation.sh <test-javascript-file-relative-to-workspace-root> [1|2]"
	echo "       1 for iPhone, 2 for iPad. Default: iPhone."
	echo "EXAMPLE: ./uiautomation.sh <path_to>/test_iPhone.js 2"
	exit 1
fi

DEVICE_TYPE=$2
if [ -z $2 ]
then
	DEVICE_TYPE=1
	echo "No device type passed in (1 for iPhone, 2 for iPad), so defaulting to iPhone"
fi

# We need a temporary place to build the app bundle
TMP_BUILD_DIR="/Bots/XCTesting/"

# TODO: clean out previous build
# Ensure our temporary directory exists
mkdir -p $TMP_BUILD_DIR

# Build our application and place the final bundle in our temporary directory
cd ..
xcodebuild -sdk iphonesimulator clean build CONFIGURATION_BUILD_DIR=$TMP_BUILD_DIR
cd -

# Clean out any existing automation results (we don't need to keep them for this demo)
rm -rf automation_results
mkdir -p automation_results

# Control which type of simulator mode we want.
/usr/libexec/PlistBuddy $TMP_BUILD_DIR/XCTesting.app/Info.plist \
        -c "Delete :UIDeviceFamily" \
        -c "Add :UIDeviceFamily array" \
        -c "Add :UIDeviceFamily: integer $DEVICE_TYPE"

echo `pwd`
./unix_instruments \
  -D automation_results/trace \
  -t UIAutomationTemplate.tracetemplate \
  $TMP_BUILD_DIR/XCTesting.app \
  -e UIARESULTSPATH automation_results \
  -e UIASCRIPT "$SCRIPT_NAME"

# Another way to make sure the simulator isn't already running.
killall -m -KILL "iPhone Simulator"

echo "Tests passed!"
