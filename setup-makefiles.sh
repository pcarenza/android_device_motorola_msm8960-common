#!/bin/sh

OUTDIR=vendor/$VENDOR/$VENDORDEVICEDIR
MAKEFILE=../../../$OUTDIR/$VENDORDEVICEDIR-vendor-blobs.mk

(cat << EOF) > $MAKEFILE
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

LOCAL_PATH := vendor/$VENDOR/$VENDORDEVICEDIR

-include device/${VENDOR}/${DEVICE}/prebuilt.mk

EOF

LINEEND=" \\"
COUNT=`cat ../${DEVICE}/proprietary-files.txt | grep -v ^# | cut -f1 -d '#' | grep -ve '^$\|^app' | wc -l | awk {'print $1'}`
if [ $COUNT -gt 0 ]; then
cat <<EOF >> $MAKEFILE
PRODUCT_COPY_FILES += \\
EOF
fi
for FILE in `cat ../${DEVICE}/proprietary-files.txt | grep -v ^# | cut -f1 -d '#' | grep -ve '^$\|^app'`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
done

LINEEND=" \\"
COUNT=`cat ../msm8960-common/common-proprietary-files.txt | grep -v ^# | cut -f1 -d '#' | grep -ve '^$\|^app' | wc -l | awk {'print $1'}`
if [ $COUNT -gt 0 ]; then
cat << EOF >> $MAKEFILE
PRODUCT_COPY_FILES += \\
EOF
fi
for FILE in `cat ../msm8960-common/common-proprietary-files.txt | grep -v ^# | cut -f1 -d '#' | grep -ve '^$\|^app'`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
done

(cat << EOF) > ../../../$OUTDIR/$VENDORDEVICEDIR-vendor.mk
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

# Pick up overlay for features that depend on non-open-source files
DEVICE_PACKAGE_OVERLAYS += vendor/$VENDOR/$VENDORDEVICEDIR/overlay

\$(call inherit-product, vendor/$VENDOR/$DEVICE/$VENDORDEVICEDIR-vendor-blobs.mk)
EOF

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$VENDORDEVICEDIR/setup-makefiles.sh

EOF

if [ -d ../../../${OUTDIR}/packages ]; then
(cat << EOF) > ../../../${OUTDIR}/packages/Android.mk
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$VENDORDEVICEDIR/setup-makefiles.sh

LOCAL_PATH:= \$(call my-dir)

EOF

for APK in `ls ../../../${OUTDIR}/packages/*apk`; do
    apkname=`basename $APK`
    modulename=`echo $apkname|sed -e 's/\.apk$//gi'`
    (cat << EOF) >> ../../../${OUTDIR}/packages/Android.mk
include \$(CLEAR_VARS)
LOCAL_MODULE := $modulename
LOCAL_MODULE_TAGS := optional eng
LOCAL_SRC_FILES := $apkname
LOCAL_CERTIFICATE := platform
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)
include \$(BUILD_PREBUILT)
EOF
    echo "PRODUCT_PACKAGES += $modulename" >> ../../../$OUTDIR/$VENDORDEVICEDIR-vendor.mk
done
fi
