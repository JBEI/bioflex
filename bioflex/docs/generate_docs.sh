#!/bin/sh
ASDOC_GENERATOR_PATH="/home/zenko/Applications/Adobe Flex SDK/3.5/bin/asdoc"
TARGET_PLAYER="10.0.42"
SOURCE_PATH="/home/zenko/workspace/Projects/Flex/BioFlex/src/"
OUTPUT_PATH="/home/zenko/workspace/Projects/Flex/BioFlex/docs/api/"
TITLE="BioFlex API"

"$ASDOC_GENERATOR_PATH" -target-player=$TARGET_PLAYER -locale en_US -source-path $SOURCE_PATH -doc-sources $SOURCE_PATH -main-title "$TITLE" -window-title "$TITLE" -output $OUTPUT_PATH
