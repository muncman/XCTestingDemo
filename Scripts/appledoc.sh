#!/bin/sh
# Appledoc configuration

# For benefit of log files.
echo $0 $*
# Better to fail early...
set -e
# set -o errexit
# set -o verbose

echo "Run this from the project root."

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

echo "Generating Appledoc HTML and Docset."

APPLEDOC_RESULTS="$TMPDIR/XCTesting/Reports/Appledoc"

/usr/local/bin/appledoc \
	--project-name "XCTest Demo" \
	--project-company "Method Up" \
	--company-id "com.methodup.ci.codemash" \
	--output $APPLEDOC_RESULTS \
	--logformat xcode \
	--keep-undocumented-objects \
	--keep-undocumented-members \
	--keep-intermediate-files \
	--no-repeat-first-par \
	--no-warn-invalid-crossref \
	--ignore "*.m" \
	--exit-threshold 2 \
	--index-desc "$WORKSPACE/README.md" \
	"$WORKSPACE/XCTesting"

echo "Results at: $APPLEDOC_RESULTS"
