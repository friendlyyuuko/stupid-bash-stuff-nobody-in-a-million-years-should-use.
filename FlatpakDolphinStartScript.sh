#!/bin/bash
#
# only exist to start the wii menu with only the emulator window
# and some other things. (only exist to really set a custom rtc that's semi time synced, minus the year...)
#
# There is zero reason to use this, it's just best to start the Wii Menu normally using dolphin rather
# than a hacky script made by a random.

# Stuff you can change.
    StartFullScreen="True"
    DiscordIntergration="False"
    EnableCheats="False"
    UseRVLOSTimeManager="True"
    UseDolphinsCheats="False"
    ConfirmExit="False"
    UseRetroAchievements="False"

# cd to stop it from being janky without breaking stuff?
#
# doesnt matter since we'll leave this directory instantly
# after setting the clock.
#
# Is there a better way? (the anwser is likely yes.)
cd "$HOME/.var/app/org.DolphinEmu.dolphin-emu/data/rtc"

# write a human readable time that'll get converted to unix time.
# Here we'll specify a custom year and set the rest from the current
# (real) time from the system.
echo Get time!
get_system_time_from_device="+2006/%m/%d %H:%M:%S"
# Convert the time in the file to unix time
# Then write the unix time to a file
# and convert the unix time in the file
# to hex which will be read by the emulated
# console.
	echo | date "$get_system_time_from_device" > .rvl_sys_time
rvl_human_read_time="`cat .rvl_sys_time`"
echo Got current system time and wrote to file.
rvl_rtc_manager="$rvl_human_read_time"
echo Do epoch time things.
		echo | date -u --date="$rvl_human_read_time" +%s > .rvl_clock
	rvl_clock="`echo | (echo "obase=16";cat .rvl_clock) | bc > .rvl_rtc`"
echo Convert epoch time to hex.
	rvl_timestamp=$(<.rvl_rtc)
echo Done!

# Flatpak
FlatPakExePath="/usr/bin/flatpak run"

# Command for launch
RevolutionOSLaunch="--branch=beta --arch=x86_64 --command=/app/bin/dolphin-emu-wrapper org.DolphinEmu.dolphin-emu --config=Dolphin.Core.EnableCheats=$UseDolphinsCheats --config=Dolphin.Interface.ConfirmStop=$ConfirmExit --config=Dolphin.General.UseDiscordPresence=$DiscordIntergration --config=Dolphin.Display.Fullscreen=$StartFullScreen --config=Achievements.Achievements.Enabled=$UseRetroAchievements --config Dolphin.Core.EnableCustomRTC=$UseRVLOSTimeManager --config Dolphin.Core.CustomRTCValue=0x$rvl_timestamp --nand_title=0000000100000002 --batch"

# Executable
$FlatPakExePath $FilePathDolphinFlatpak $RevolutionOSLaunch
exit
