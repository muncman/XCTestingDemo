#!/bin/sh

# For benefit of log files.
echo pwd = `pwd`
echo $0 $*
# Make sure bash fails completely if any command fails
set -e

# TODO: Temporary - remove next line
echo XCODE_DEVELOPER_DIR_PATH is $XCODE_DEVELOPER_DIR_PATH

# One way to make sure the simulator isn't already running.
osascript -e 'tell app "iPhone Simulator" to quit'

SCRIPT_NAME=$1
if [ -z $1 ]
then
	echo "USAGE: uiautomation.sh <test-javascript-file-relative-to-workspace-root> [1|2]"
	echo "       1 for iPhone, 2 for iPad. Default: iPhone."
	echo "EXAMPLE: ./UIAutomation/uiautomation.sh <path_to>/test_iPhone.js 2"
	exit 1
fi

DEVICE_TYPE=$2
if [ -z $2 ]
then
	DEVICE_TYPE=1
	echo "No device type passed in (1 for iPhone, 2 for iPad), so defaulting to iPhone"
fi

# $WORKSPACE is already defined if run from within Jenkins. 
if [ -z "$WORKSPACE" ]
then
  # For Xcode scheme pre- and post-action invocation (and so Bots).
  # Try this first. 
  WORKSPACE=${PROJECT_DIR} 
  echo "set WORKSPACE to $WORKSPACE"
fi

if [ -z "$WORKSPACE" ]
then
  # For command line invocation. 
  # This is the final fallback. 
  WORKSPACE=`pwd` 
  echo "set WORKSPACE to $WORKSPACE"
fi

# We need a temporary place to build the app bundle
TMP_BUILD_DIR="/Bots/XCTesting"

# TODO: clean out previous build
# Ensure our temporary directory exists
mkdir -p $TMP_BUILD_DIR

# Build our application and place the final bundle in our temporary directory
cd $WORKSPACE
xcodebuild -sdk iphonesimulator clean build CONFIGURATION_BUILD_DIR=$TMP_BUILD_DIR TARGETED_DEVICE_FAMILY=$DEVICE_TYPE
cd -

# Define UIAutomation results directory
UIAUTOMATION_RESULTS=$TMP_BUILD_DIR/UIAutomation

# Clean out any existing automation results (we don't need to keep them for this demo)
mkdir -p $UIAUTOMATION_RESULTS
rm -rf $UIAUTOMATION_RESULTS
mkdir -p $UIAUTOMATION_RESULTS

# Control which type of simulator mode we want.
/usr/libexec/PlistBuddy $TMP_BUILD_DIR/XCTesting.app/Info.plist \
  -c "Delete :UIDeviceFamily" \
  -c "Add :UIDeviceFamily array" \
  -c "Add :UIDeviceFamily: integer $DEVICE_TYPE"

echo Current directory is: `pwd`
# $WORKSPACE/UIAutomation/unix_instruments \
#   -D $UIAUTOMATION_RESULTS/trace \
#   -t $WORKSPACE/UIAutomation/UIAutomationTemplate.tracetemplate \
#   $TMP_BUILD_DIR/XCTesting.app \
#   -e UIARESULTSPATH $UIAUTOMATION_RESULTS \
#   -e UIASCRIPT "$SCRIPT_NAME"

# Trying to get away from warning about XCODE_DEVELOPER_DIR_PATH
if [ -z "$XCODE_DEVELOPER_DIR_PATH" ]
then
  # For Xcode scheme pre- and post-action invocation (and so Bots).
  # Try this first. 
  XCODE_DEVELOPER_DIR_PATH="/Applications/Xcode.app/Contents/Developer/"  
  export XCODE_DEVELOPER_DIR_PATH  
  echo "set XCODE_DEVELOPER_DIR_PATH to $XCODE_DEVELOPER_DIR_PATH"
fi

instruments \
  -D $UIAUTOMATION_RESULTS/trace \
  -t $WORKSPACE/UIAutomation/UIAutomationTemplate.tracetemplate \
  $TMP_BUILD_DIR/XCTesting.app \
  -e UIASCRIPT "$SCRIPT_NAME" \
  -e UIARESULTSPATH $UIAUTOMATION_RESULTS \
  | grep "Error" \
  > $UIAUTOMATION_RESULTS/uiautomation_errors.txt
# | grep "(Fail:|Error:|None: Script threw an uncaught JavaScript error)" > $UIAUTOMATION_RESULTS/uiautomation_errors.txt 
# -t "/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate" \
# -w device_UDID \
 
filesize=$(stat -f "%z" $UIAUTOMATION_RESULTS/uiautomation_errors.txt)
 
rm -rf $UIAUTOMATION_RESULTS/Run*
 
if [ $filesize = "0" ]; then

  echo
  echo "UIAutomation passed"
  echo

  # APP="$ARCHIVE_PRODUCTS_PATH$INSTALL_PATH/$WRAPPER_NAME"
  # latest=$(ls -1td /Library/Server/Xcode/Data/BotRuns/Bot* | head -n 1)
  # echo ${latest}
  # substringOn=0
  # blankLineCount=0
  # commitsString=$(cat ${latest}/output/commit*.log |
  # awk '{
  # if (match($0, "CommitDate") == 1) {
  #     substringOn=1
  #     blankLineCount=0
  # }
  # if (substringOn==1) {
  #     if ($0 != "") {
  #         if (blankLineCount==1)  {
  #             sub(/^[ \t]+/, "",$0)
  #             print $0
  #         }
  #     } else
  #     blankLineCount++
  # }
  # }')

  # curl \
  # -F "status=2" \
  # -F "notify=1" \
  # -F "notes=${commitsString}" \
  # -F "notes_type=0" \
  # -F "ipa=@$TMP_BUILD_DIR/XCTesting.ipa" \
  # -H "X-HockeyAppToken: company_id_token" \
  # https://rink.hockeyapp.net/api/2/apps/app_id/app_versions/upload

else
  echo
  echo "UIAutomation has errors:"
  cat $UIAUTOMATION_RESULTS/uiautomation_errors.txt
  echo
  kill $PPID
  exit 1
fi

# Another way to make sure the simulator isn't already running.
killall -m -KILL "iPhone Simulator"
