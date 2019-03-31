#!/bin/bash
#
#
#
#   Make by. chhanz
#   Update date. 20190327
#
# Set Value
#
DATE=`date +%y%m%d_%k%M`

# Banner
echo "=================================================================================="
base64 -d <<<"ICAgIF9fX18gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIF9fICAgICAgICAgICAgCiAgIC8gX18gXF9fX18gX18gICAgICBfXyAgICAgIF9fX18g
X19fXyAgX19fXyAgX19fICBfX19fX19fX18gXy8gL19fX19fICBfX19fXwogIC8gL18vIC8gX18g
YC8gfCAvfCAvIC9fX19fXy8gX18gYC8gXyBcLyBfXyBcLyBfIFwvIF9fXy8gX18gYC8gX18vIF9f
IFwvIF9fXy8KIC8gXywgXy8gL18vIC98IHwvIHwvIC9fX19fXy8gL18vIC8gIF9fLyAvIC8gLyAg
X18vIC8gIC8gL18vIC8gL18vIC9fLyAvIC8gICAgCi9fLyB8X3xcX18sXy8gfF9fL3xfXy8gICAg
ICBcX18sIC9cX19fL18vIC9fL1xfX18vXy8gICBcX18sXy9cX18vXF9fX18vXy8gICAgIAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAvX19fXy8gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAKCgo="
echo "=================================================================================="
echo "                          Multipath UUID Parsing"
echo "=================================================================================="
multipath -ll | grep mpath | sort -u | awk '{print $1"  mpath-"$2}' | cat -n >  /tmp/mpath_uuid_$DATE.txt
sed -i 's/(//g' /tmp/mpath_uuid_$DATE.txt
sed -i 's/)//g' /tmp/mpath_uuid_$DATE.txt
echo "                                   END"
#echo "=================================================================================="

echo " "
echo " "
echo "=================================================================================="
echo "                          Making 60-raw.rules"
echo "=================================================================================="

GENFILE=60-raw.rules.$DATE
FRONTSTD="ACTION==\"add|change\",ENV{DM_UUID}==\""
MIDSTD="\",RUN+=\"/usr/bin/raw /dev/raw/raw"
BACKSTD=" %N\""
ENDSTD="ACTION==\"add\", KERNEL==\"raw*\", OWNER=\"grid\", GROUP=\"dba\", MODE=\"0660\""

echo "# RawGenerator - 60-raw.rules"  > $GENFILE
echo "# Make . chhanz " >> $GENFILE
echo " " >> $GENFILE
cat /tmp/mpath_uuid_$DATE.txt | awk '{print "ACTION==\"add|change\",ENV{DM_UUID}==\""$3"\",RUN+=\"/usr/bin/raw /dev/raw/raw"$1" %N\""}' >> $GENFILE
echo "" >> $GENFILE
echo $ENDSTD >> $GENFILE
echo " "
echo "                                 Complete"
echo " "
echo "Show GenFile"
echo "=================================================================================="
cat $GENFILE
echo "=================================================================================="



