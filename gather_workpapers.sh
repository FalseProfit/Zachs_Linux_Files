#!/bin/bash
#Author: Zach Johnson

#TODO:
#  - Add all typical automatically generated workpaper locations to be copied or moved into the user provided workpapers folder path

# Colored text support
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color (reset). Use this at the end of every colored text to reset the color back to default


subfolder="Copied_Workpapers"

while getopts ":f:" opt; do
  case "$opt" in
    f)
      folder="$OPTARG"
      ;;
    \?)
      echo -e "${RED}[FAIL]${NC} Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "${RED}[FAIL]${NC} Option -$OPTARG requires an argument. Please use -f to provide the location of your existing workpapers folder. i.e. /root/Workpapers" >&2
      exit 1
      ;;
  esac
done


#Check if the workpapers folder exists
if [ ! -d "$folder" ]; then
  echo "${RED}[FAIL]${NC} The provided workpapers folder does not exist. Please create it and try again."
  exit 1
fi


# Copying workpapers from the default locations to the user provided workpapers folder
if [ ! -d "$folder/$subfolder" ]; then
  # Create the subfolder if it doesn't exist
  echo "[INFO] Creating subfolder $subfolder in $folder"
  mkdir "$folder/$subfolder" || { echo "[FAIL] Failed to create subfolder $subfolder in $folder"; exit 1; }
fi


# Copying workpapers from the default locations to the user provided workpapers folder
echo "[INFO] Copying workpapers from default locations to $folder/$subfolder"
echo "[INFO] Copying workpapers from ~/.nxc/workpapers to $folder/$subfolder"
cp -r ~/.nxc/logs $1 || { echo "${RED}[FAIL]${NC} Failed to copy workpapers from ~/.nxc/workpapers to $folder/$subfolder"; }
