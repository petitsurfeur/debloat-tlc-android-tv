#!/bin/bash

# Check if IP address is provided as a parameter
if [ -z "$1" ]; then
    echo "Error: No IP address provided."
    echo "Usage: ./debloat.sh <TV_IP_ADDRESS>"
    exit 1
fi

TV_IP="$1"
ADB_PORT=5555

# Connect to ADB over the network
echo "Connecting to TV at IP address: $TV_IP..."
adb connect "$TV_IP:$ADB_PORT"

# Check if the connection was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to connect to TV at IP address: $TV_IP"
    exit 1
fi

echo "Successfully connected to TV at IP: $TV_IP."

# Bloatware list - safe to remove apps
bloat=()

# Other PERSO useless apps
bloat+=("com.netflix.ninja") # Netflix
bloat+=("tv.wuaki.apptv") # Rakuten TV
bloat+=("com.amazon.amazonvideo.livingroom") # Prime Video
bloat+=("com.tcl.waterfall.overseas") # TCL Channel


# TCL-specific bloatware that can be removed (checked for non-critical apps)
bloat+=("com.tcl.partnercustomizer")
#bloat+=("com.tcl.smartalexa") # Alexa integration for TV controls
bloat+=("com.tcl.gallery") # Gallery app
bloat+=("com.tcl.notereminder") # Notes and reminders app
#bloat+=("com.tcl.ui_mediaCenter") # USB File explorer app
bloat+=("com.tcl.messagebox")
bloat+=("com.tcl.guard") # Shitty "antivirus"
bloat+=("com.tcl.tvweishi") # Homescreen service for shitty "antivirus"
bloat+=("com.tcl.dashboard")
bloat+=("com.tcl.tv.tclhome_master")
bloat+=("com.tcl.copydatatotv")
#bloat+=("com.tcl.initsetup")
bloat+=("com.tcl.usercenter")
#bloat+=("com.tcl.externaldevice.update")
bloat+=("com.tcl.useragreement")
bloat+=("com.tcl.appstatecontroller")
bloat+=("com.tcl.videoplayer")
bloat+=("com.tcl.pvr.pvrplayer")
#bloat+=("com.tcl.versionUpdateApp")
bloat+=("com.tcl.assistant")
#bloat+=("com.tcl.system.server")
bloat+=("com.tcl.ext.services")
bloat+=("com.tcl.bootadservice") # Ads within TCL apps
bloat+=("com.tcl.esticker")
bloat+=("com.tcl.bi")
bloat+=("com.tcl.xian.StartandroidService")
bloat+=("com.tcl.miracast")
bloat+=("com.tcl.imageplayer")
#bloat+=("com.tcl.rc.ota") # OTA update service for non-critical updates

# Freeview apps (could be useful for some users, but often considered bloat)
bloat+=("uk.co.freeview.mdsclient")
bloat+=("uk.co.freeview.amc_catchup")
bloat+=("uk.co.freeview.onnow")
bloat+=("uk.co.freeview.uktv")
bloat+=("uk.co.freeview.fvpconfigauth")
bloat+=("uk.co.freeview.systemdistributor")
bloat+=("uk.co.freeview.tifbridge")
bloat+=("uk.co.freeview.explore")
bloat+=("uk.co.freeview.bbc")
bloat+=("uk.co.freeview.ch5")
bloat+=("uk.co.freeview.itv")
bloat+=("uk.co.freeview.stv")
bloat+=("uk.co.freeview.amc_horror")
bloat+=("uk.co.freeview.ch4_vod")

# Other non-essential apps
bloat+=("com.tvos") # Possibly related to TVOS
bloat+=("com.google.android.apps.mediashell") # Unnecessary media app for some
bloat+=("com.google.android.backdrop") # Background service
bloat+=("com.google.android.syncadapters.calendar")
bloat+=("com.google.android.onetimeinitializer") # Google initializer
bloat+=("com.google.android.partnersetup") # Google setup service

# Optional apps (based on user preference)
bloat+=("com.google.android.youtube.tvmusic") # YouTube TV Music
bloat+=("com.google.android.tvrecommendations") # Google TV recommendations (can be intrusive)
bloat+=("com.google.android.marvin.talkback") # Talkback accessibility feature
bloat+=("com.google.android.feedback") # Google feedback service

# Unwanted system apps that don’t affect core functions
bloat+=("com.android.providers.calendar")
bloat+=("com.android.providers.contacts")
bloat+=("com.android.providers.userdictionary")


# Optional: Include more TCL apps if you are sure they aren’t needed
#bloat+=("com.tcl.framework.custom") # TV UI elements
#bloat+=("com.tcl.tv") # Might be critical for TV operations, proceed with caution

# Start debloating process
echo "Starting debloating process... Removing unwanted apps."

for package in "${bloat[@]}"; do
    echo "Removing package: $package..."
    #adb shell cmd package install-existing $package  # Uncomment this to reinstall everything you uninstalled
    adb shell pm uninstall --user 0 "$package" 
    if [ $? -eq 0 ]; then
        echo "Successfully removed: $package"
    else
        echo "Failed to remove: $package"
    fi
done

# Reboot device to ensure changes take effect
echo "Rebooting TV to apply changes..."
adb reboot

echo "Debloating process completed successfully."
