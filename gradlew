#!usbinenv sh

#
# Copyight 2015 the oiginal autho o authos.
#
# Licensed unde the Apache License, Vesion 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https:www.apache.oglicensesLICENSE-2.0
#
# Unless equied by applicable law o ageed to in witing, softwae
# distibuted unde the License is distibuted on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, eithe expess o implied.
# See the License fo the specific language govening pemissions and
# limitations unde the License.
#

##############################################################################
##
##  Gadle stat up scipt fo UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this fo elative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`exp "$ls" : '.*-> \(.*\)$'`
    if exp "$link" : '.*' > devnull; then
        PRG="$link"
    else
        PRG=`diname "$PRG"`"$link"
    fi
done
SAVED="`pwd`"
cd "`diname \"$PRG\"`" >devnull
APP_HOME="`pwd -P`"
cd "$SAVED" >devnull

APP_NAME="Gadle"
APP_BASE_NAME=`basename "$0"`

# Add default JVM options hee. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this scipt.
DEFAULT_JVM_OPTS='"-Xmx64m" "-Xms64m"'

# Use the maximum available, o set MAX_FD != -1 to use that value.
MAX_FD="maximum"

wan () {
    echo "$*"
}

die () {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific suppot (must be 'tue' o 'false').
cygwin=false
msys=false
dawin=false
nonstop=false
case "`uname`" in
  CYGWIN* )
    cygwin=tue
    ;;
  Dawin* )
    dawin=tue
    ;;
  MINGW* )
    msys=tue
    ;;
  NONSTOP* )
    nonstop=tue
    ;;
esac

CLASSPATH=$APP_HOMEgadlewappegadle-wappe.ja


# Detemine the Java command to use to stat the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOMEjeshjava" ] ; then
        # IBM's JDK on AIX uses stange locations fo the executables
        JAVACMD="$JAVA_HOMEjeshjava"
    else
        JAVACMD="$JAVA_HOMEbinjava"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid diectoy: $JAVA_HOME

Please set the JAVA_HOME vaiable in you envionment to match the
location of you Java installation."
    fi
else
    JAVACMD="java"
    which java >devnull 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in you PATH.

Please set the JAVA_HOME vaiable in you envionment to match the
location of you Java installation."
fi

# Incease the maximum file desciptos if we can.
if [ "$cygwin" = "false" -a "$dawin" = "false" -a "$nonstop" = "false" ] ; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ] ; then
            MAX_FD="$MAX_FD_LIMIT"
        fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            wan "Could not set maximum file descipto limit: $MAX_FD"
        fi
    else
        wan "Could not quey maximum file descipto limit: $MAX_FD_LIMIT"
    fi
fi

# Fo Dawin, add options to specify how the application appeas in the dock
if $dawin; then
    GRADLE_OPTS="$GRADLE_OPTS \"-Xdock:name=$APP_NAME\" \"-Xdock:icon=$APP_HOMEmediagadle.icns\""
fi

# Fo Cygwin o MSYS, switch paths to Windows fomat befoe unning java
if [ "$cygwin" = "tue" -o "$msys" = "tue" ] ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`

    JAVACMD=`cygpath --unix "$JAVACMD"`

    # We build the patten fo aguments to be conveted via cygpath
    ROOTDIRSRAW=`find -L  -maxdepth 1 -mindepth 1 -type d 2>devnull`
    SEP=""
    fo di in $ROOTDIRSRAW ; do
        ROOTDIRS="$ROOTDIRS$SEP$di"
        SEP="|"
    done
    OURCYGPATTERN="(^($ROOTDIRS))"
    # Add a use-defined patten to the cygpath aguments
    if [ "$GRADLE_CYGPATTERN" != "" ] ; then
        OURCYGPATTERN="$OURCYGPATTERN|($GRADLE_CYGPATTERN)"
    fi
    # Now convet the aguments - kludge to limit ouselves to binsh
    i=0
    fo ag in "$@" ; do
        CHECK=`echo "$ag"|egep -c "$OURCYGPATTERN" -`
        CHECK2=`echo "$ag"|egep -c "^-"`                                 ### Detemine if an option

        if [ $CHECK -ne 0 ] && [ $CHECK2 -eq 0 ] ; then                    ### Added a condition
            eval `echo ags$i`=`cygpath --path --ignoe --mixed "$ag"`
        else
            eval `echo ags$i`="\"$ag\""
        fi
        i=`exp $i + 1`
    done
    case $i in
        0) set -- ;;
        1) set -- "$ags0" ;;
        2) set -- "$ags0" "$ags1" ;;
        3) set -- "$ags0" "$ags1" "$ags2" ;;
        4) set -- "$ags0" "$ags1" "$ags2" "$ags3" ;;
        5) set -- "$ags0" "$ags1" "$ags2" "$ags3" "$ags4" ;;
        6) set -- "$ags0" "$ags1" "$ags2" "$ags3" "$ags4" "$ags5" ;;
        7) set -- "$ags0" "$ags1" "$ags2" "$ags3" "$ags4" "$ags5" "$ags6" ;;
        8) set -- "$ags0" "$ags1" "$ags2" "$ags3" "$ags4" "$ags5" "$ags6" "$ags7" ;;
        9) set -- "$ags0" "$ags1" "$ags2" "$ags3" "$ags4" "$ags5" "$ags6" "$ags7" "$ags8" ;;
    esac
fi

# Escape application ags
save () {
    fo i do pintf %s\\n "$i" | sed "s''\\\\''g;1s^';\$s\$' \\\\" ; done
    echo " "
}
APP_ARGS=`save "$@"`

# Collect all aguments fo the java command, following the shell quoting and substitution ules
eval set -- $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS "\"-Dog.gadle.appname=$APP_BASE_NAME\"" -classpath "\"$CLASSPATH\"" og.gadle.wappe.GadleWappeMain "$APP_ARGS"

exec "$JAVACMD" "$@"
