#!/usr/bin/env bash

# c_library repository update script
# Author: Thomas Gubler <thomasgubler@gmail.com>
#
# This script can be used together with a github webhook to automatically
# generate new c header files and push to the c_library repository whenever
# the message specifications are updated.
# The script assumes that the git repositories in MAVLINK_GIT_PATH and
# CLIBRARY_GIT_PATH are set up prior to invoking the script.
#
# Usage, for example:
# cd ~/src
# git clone git@github.com:mavlink/mavlink.git
# cd mavlink
# git remote rename origin upstream
# mkdir -p include/mavlink/v1.0
# cd include/mavlink/v1.0
# git clone git@github.com:mavlink/c_library_v1.git
# cd ~/src/mavlink
# ./scripts/update_c_library.sh 1
#
# A one-liner for the TMP directory (e.g. for crontab)
# cd /tmp; git clone git@github.com:mavlink/mavlink.git &> /dev/null; \
# cd /tmp/mavlink && git remote rename origin upstream &> /dev/null; \
# mkdir -p include/mavlink/v1.0 && cd include/mavlink/v1.0 && git clone git@github.com:mavlink/c_library_v1.git &> /dev/null; \
# cd /tmp/mavlink && ./scripts/update_c_library.sh &> /dev/null

# settings
MAVLINK_PATH=$PWD
MAVLINK_GIT_REMOTENAME=upstream
MAVLINK_GIT_BRANCHNAME=master
CLIBRARY_PATH=$MAVLINK_PATH/generated/mavlink/v$1.0
CLIBRARY_GIT_REMOTENAME=origin
CLIBRARY_GIT_BRANCHNAME=master


function generate_headers() {
echo -e "gh $1 $2 $3\n"
GENERATED_OUTPUT=$CLIBRARY_PATH/lib/$1/$2
mkdir -p $GENERATED_OUTPUT
python3 pymavlink/tools/mavgen.py \
    --output $GENERATED_OUTPUT \
    --lang $1 \
    --wire-protocol $3.0 \
    message_definitions/v1.0/$2.xml
}

function generate_headers_lang() {
echo -e "ghl $1 $2\n"
echo -e "\0033[34mStarting to generate c headers\0033[0m\n"
generate_headers $1 all $2
generate_headers $1 test $2
generate_headers $1 storm32 $2
generate_headers $1 ardupilotmega $2
generate_headers $1 common $2
generate_headers $1 standard $2
generate_headers $1 minimal $2
generate_headers $1 csAirLink $2
generate_headers $1 uAvionix $2
generate_headers $1 cubepilot $2
generate_headers $1 ualberta $2
generate_headers $1 icarous $2
generate_headers $1 loweheiser $2
generate_headers $1 paparazzi $2
generate_headers $1 ASLUAV $2
generate_headers $1 matrixpilot $2
generate_headers $1 python_array_test $2
echo -e "\0033[34mFinished generating $1 headers\0033[0m\n"
}


# delete old c headers
rm -rf $CLIBRARY_PATH/*

generate_headers_lang C $1
#generate_headers_lang Python $1
generate_headers_lang Python3 $1
generate_headers_lang Ada $1
generate_headers_lang CS $1
#generate_headers_lang JavaScript $1
generate_headers_lang JavaScript_Stable $1
generate_headers_lang JavaScript_NextGen $1
generate_headers_lang TypeScript $1
generate_headers_lang Lua $1
generate_headers_lang WLua $1
generate_headers_lang ObjC $1
generate_headers_lang Swift $1
generate_headers_lang Java $1
generate_headers_lang C++11 $1
