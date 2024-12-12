{ ... }:
{
  imports = [ <plasma-manager/modules> ];

  programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-aa349499-c654-46cd-8ef2-dce34a1370ad" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "Vulkan Rust-4.desktop"."_launch" = [ ];
      "Vulkan Rust-8.desktop"."_launch" = [ ];
      "Vulkan Rust-9.desktop"."_launch" = [ ];
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = "Touchpad Toggle";
      "kded5"."Show System Activity" = "Ctrl+Esc";
      "kded5"."display" = [
        "Display"
        "Meta+P,Display"
        "Meta+P,Switch Display"
      ];
      "khotkeys"."{b42f609d-4eae-4924-acba-b9b74d753f4d}" = "Ctrl+F12,none,Open Nix Config";
      "khotkeys"."{d03619b6-9b3c-48cc-9d9c-a2aadb485550}" = [ ];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = [
        "Microphone Mute"
        "Meta+Volume Mute,Microphone Mute"
        "Meta+Volume Mute,Mute Microphone"
      ];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = "none,,Halt Without Confirmation";
      "ksmserver"."Lock Session" = [
        "Meta+L"
        "Screensaver,Meta+L"
        "Screensaver,Lock Session"
      ];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = "none,,Log Out Without Confirmation";
      "ksmserver"."Reboot" = [ ];
      "ksmserver"."Reboot Without Confirmation" = "none,,Reboot Without Confirmation";
      "ksmserver"."Shut Down" = [ ];
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = "none,,Decrease Opacity of Active Window by 5%";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = [
        "Ctrl+F10"
        "Launch (C),Ctrl+F10"
        "Launch (C),Toggle Present Windows (All desktops)"
      ];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = "none,,Increase Opacity of Active Window by 5%";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [ ];
      "kwin"."MoveZoomLeft" = [ ];
      "kwin"."MoveZoomRight" = [ ];
      "kwin"."MoveZoomUp" = [ ];
      "kwin"."Overview" = "Meta+W";
      "kwin"."Setup Window Shortcut" = "none,,Setup Window Shortcut";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."ShowDesktopGrid" = "Meta+F8";
      "kwin"."Suspend Compositing" = "Alt+Shift+F12";
      "kwin"."Switch One Desktop Down" = "Meta+Down,Meta+Ctrl+Down,Switch One Desktop Down";
      "kwin"."Switch One Desktop Up" = "Meta+Up,Meta+Ctrl+Up,Switch One Desktop Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Left,Meta+Ctrl+Left,Switch One Desktop to the Left";
      "kwin"."Switch One Desktop to the Right" =
        "Meta+Right,Meta+Ctrl+Right,Switch One Desktop to the Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
      "kwin"."Switch to Desktop 10" = "none,,Switch to Desktop 10";
      "kwin"."Switch to Desktop 11" = "none,,Switch to Desktop 11";
      "kwin"."Switch to Desktop 12" = "none,,Switch to Desktop 12";
      "kwin"."Switch to Desktop 13" = "none,,Switch to Desktop 13";
      "kwin"."Switch to Desktop 14" = "none,,Switch to Desktop 14";
      "kwin"."Switch to Desktop 15" = "none,,Switch to Desktop 15";
      "kwin"."Switch to Desktop 16" = "none,,Switch to Desktop 16";
      "kwin"."Switch to Desktop 17" = "none,,Switch to Desktop 17";
      "kwin"."Switch to Desktop 18" = "none,,Switch to Desktop 18";
      "kwin"."Switch to Desktop 19" = "none,,Switch to Desktop 19";
      "kwin"."Switch to Desktop 2" = "Ctrl+F2";
      "kwin"."Switch to Desktop 20" = "none,,Switch to Desktop 20";
      "kwin"."Switch to Desktop 3" = "Ctrl+F3";
      "kwin"."Switch to Desktop 4" = "Ctrl+F4";
      "kwin"."Switch to Desktop 5" = "none,,Switch to Desktop 5";
      "kwin"."Switch to Desktop 6" = "none,,Switch to Desktop 6";
      "kwin"."Switch to Desktop 7" = "none,,Switch to Desktop 7";
      "kwin"."Switch to Desktop 8" = "none,,Switch to Desktop 8";
      "kwin"."Switch to Desktop 9" = "none,,Switch to Desktop 9";
      "kwin"."Switch to Next Desktop" = "none,,Switch to Next Desktop";
      "kwin"."Switch to Next Screen" = "none,,Switch to Next Screen";
      "kwin"."Switch to Previous Desktop" = "none,,Switch to Previous Desktop";
      "kwin"."Switch to Previous Screen" = "none,,Switch to Previous Screen";
      "kwin"."Switch to Screen 0" = "none,,Switch to Screen 0";
      "kwin"."Switch to Screen 1" = "none,,Switch to Screen 1";
      "kwin"."Switch to Screen 2" = "none,,Switch to Screen 2";
      "kwin"."Switch to Screen 3" = "none,,Switch to Screen 3";
      "kwin"."Switch to Screen 4" = "none,,Switch to Screen 4";
      "kwin"."Switch to Screen 5" = "none,,Switch to Screen 5";
      "kwin"."Switch to Screen 6" = "none,,Switch to Screen 6";
      "kwin"."Switch to Screen 7" = "none,,Switch to Screen 7";
      "kwin"."Switch to Screen Above" = "none,,Switch to Screen Above";
      "kwin"."Switch to Screen Below" = "none,,Switch to Screen Below";
      "kwin"."Switch to Screen to the Left" = "none,,Switch to Screen to the Left";
      "kwin"."Switch to Screen to the Right" = "none,,Switch to Screen to the Right";
      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";
      "kwin"."Walk Through Desktop List" = "none,,Walk Through Desktop List";
      "kwin"."Walk Through Desktop List (Reverse)" = "none,,Walk Through Desktop List (Reverse)";
      "kwin"."Walk Through Desktops" = "none,,Walk Through Desktops";
      "kwin"."Walk Through Desktops (Reverse)" = "none,,Walk Through Desktops (Reverse)";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Backtab";
      "kwin"."Walk Through Windows Alternative" = "none,,Walk Through Windows Alternative";
      "kwin"."Walk Through Windows Alternative (Reverse)" =
        "none,,Walk Through Windows Alternative (Reverse)";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" =
        "none,,Walk Through Windows of Current Application Alternative";
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" =
        "none,,Walk Through Windows of Current Application Alternative (Reverse)";
      "kwin"."Window Above Other Windows" = "none,,Keep Window Above Others";
      "kwin"."Window Below Other Windows" = "none,,Keep Window Below Others";
      "kwin"."Window Close" = "Alt+F4";
      "kwin"."Window Fullscreen" = "none,,Make Window Fullscreen";
      "kwin"."Window Grow Horizontal" = "none,,Expand Window Horizontally";
      "kwin"."Window Grow Vertical" = "none,,Expand Window Vertically";
      "kwin"."Window Lower" = "none,,Lower Window";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = "none,,Maximize Window Horizontally";
      "kwin"."Window Maximize Vertical" = "none,,Maximize Window Vertically";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = "none,,Move Window";
      "kwin"."Window Move Center" = "none,,Move Window to the Center";
      "kwin"."Window No Border" = "none,,Toggle Window Titlebar and Frame";
      "kwin"."Window On All Desktops" = "none,,Keep Window on All Desktops";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = "none,,Window One Screen Down";
      "kwin"."Window One Screen Up" = "none,,Window One Screen Up";
      "kwin"."Window One Screen to the Left" = "none,,Window One Screen to the Left";
      "kwin"."Window One Screen to the Right" = "none,,Window One Screen to the Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = "none,,Move Window Down";
      "kwin"."Window Pack Left" = "none,,Move Window Left";
      "kwin"."Window Pack Right" = "none,,Move Window Right";
      "kwin"."Window Pack Up" = "none,,Move Window Up";
      "kwin"."Window Quick Tile Bottom" = "none,Meta+Down,Quick Tile Window to the Bottom";
      "kwin"."Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
      "kwin"."Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
      "kwin"."Window Quick Tile Left" = "none,Meta+Left,Quick Tile Window to the Left";
      "kwin"."Window Quick Tile Right" = "none,Meta+Right,Quick Tile Window to the Right";
      "kwin"."Window Quick Tile Top" = "none,Meta+Up,Quick Tile Window to the Top";
      "kwin"."Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
      "kwin"."Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
      "kwin"."Window Raise" = "none,,Raise Window";
      "kwin"."Window Resize" = "none,,Resize Window";
      "kwin"."Window Shade" = "none,,Shade Window";
      "kwin"."Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
      "kwin"."Window Shrink Vertical" = "none,,Shrink Window Vertically";
      "kwin"."Window to Desktop 1" = "none,,Window to Desktop 1";
      "kwin"."Window to Desktop 10" = "none,,Window to Desktop 10";
      "kwin"."Window to Desktop 11" = "none,,Window to Desktop 11";
      "kwin"."Window to Desktop 12" = "none,,Window to Desktop 12";
      "kwin"."Window to Desktop 13" = "none,,Window to Desktop 13";
      "kwin"."Window to Desktop 14" = "none,,Window to Desktop 14";
      "kwin"."Window to Desktop 15" = "none,,Window to Desktop 15";
      "kwin"."Window to Desktop 16" = "none,,Window to Desktop 16";
      "kwin"."Window to Desktop 17" = "none,,Window to Desktop 17";
      "kwin"."Window to Desktop 18" = "none,,Window to Desktop 18";
      "kwin"."Window to Desktop 19" = "none,,Window to Desktop 19";
      "kwin"."Window to Desktop 2" = "none,,Window to Desktop 2";
      "kwin"."Window to Desktop 20" = "none,,Window to Desktop 20";
      "kwin"."Window to Desktop 3" = "none,,Window to Desktop 3";
      "kwin"."Window to Desktop 4" = "none,,Window to Desktop 4";
      "kwin"."Window to Desktop 5" = "none,,Window to Desktop 5";
      "kwin"."Window to Desktop 6" = "none,,Window to Desktop 6";
      "kwin"."Window to Desktop 7" = "none,,Window to Desktop 7";
      "kwin"."Window to Desktop 8" = "none,,Window to Desktop 8";
      "kwin"."Window to Desktop 9" = "none,,Window to Desktop 9";
      "kwin"."Window to Next Desktop" = "none,,Window to Next Desktop";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = "none,,Window to Previous Desktop";
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."Window to Screen 0" = "none,,Window to Screen 0";
      "kwin"."Window to Screen 1" = "none,,Window to Screen 1";
      "kwin"."Window to Screen 2" = "none,,Window to Screen 2";
      "kwin"."Window to Screen 3" = "none,,Window to Screen 3";
      "kwin"."Window to Screen 4" = "none,,Window to Screen 4";
      "kwin"."Window to Screen 5" = "none,,Window to Screen 5";
      "kwin"."Window to Screen 6" = "none,,Window to Screen 6";
      "kwin"."Window to Screen 7" = "none,,Window to Screen 7";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = [
        "Meta++"
        "Meta+=,Meta++"
        "Meta+=,Zoom In"
      ];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = [ ];
      "mediacontrol"."mediavolumeup" = [ ];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = [ ];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org.kde.dolphin.desktop"."_launch" = "Meta+E";
      "org.kde.konsole.desktop"."NewTab" = [ ];
      "org.kde.konsole.desktop"."NewWindow" = [ ];
      "org.kde.konsole.desktop"."_launch" = "Ctrl+Alt+T";
      "org.kde.krunner.desktop"."RunClipboard" = "Alt+Shift+F2";
      "org.kde.krunner.desktop"."_launch" = [
        "Alt+Space"
        "Alt+F2"
        "Search,Alt+Space"
        "Alt+F2"
        "Search,KRunner"
      ];
      "org.kde.plasma.emojier.desktop"."_launch" = [
        "Meta+."
        "Meta+Ctrl+Alt+Shift+Space,Meta+."
        "Meta+Ctrl+Alt+Shift+Space,Emoji Selector"
      ];
      "org.kde.spectacle.desktop"."ActiveWindowScreenShot" = "Meta+Print";
      "org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = [ ];
      "org.kde.spectacle.desktop"."FullScreenScreenShot" = "Shift+Print";
      "org.kde.spectacle.desktop"."OpenWithoutScreenshot" = [ ];
      "org.kde.spectacle.desktop"."RectangularRegionScreenShot" =
        "Print,Meta+Shift+Print,Capture Rectangular Region";
      "org.kde.spectacle.desktop"."WindowUnderCursorScreenShot" = "Meta+Ctrl+Print";
      "org.kde.spectacle.desktop"."_launch" = "none,Print,Launch Spectacle";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = [
        "Battery"
        "Meta+B,Battery"
        "Meta+B,Switch Power Profile"
      ];
      "plasmashell"."activate task manager entry 1" = "Meta+1";
      "plasmashell"."activate task manager entry 10" = "none,Meta+0,Activate Task Manager Entry 10";
      "plasmashell"."activate task manager entry 2" = "Meta+2";
      "plasmashell"."activate task manager entry 3" = "Meta+3";
      "plasmashell"."activate task manager entry 4" = "Meta+4";
      "plasmashell"."activate task manager entry 5" = "Meta+5";
      "plasmashell"."activate task manager entry 6" = "Meta+6";
      "plasmashell"."activate task manager entry 7" = "Meta+7";
      "plasmashell"."activate task manager entry 8" = "Meta+8";
      "plasmashell"."activate task manager entry 9" = "Meta+9";
      "plasmashell"."clear-history" = "none,,Clear Clipboard History";
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = "none,,Next History Item";
      "plasmashell"."cyclePrevAction" = "none,,Previous History Item";
      "plasmashell"."edit_clipboard" = "none,,Edit Contents…";
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+Tab";
      "plasmashell"."previous activity" = "Meta+Shift+Tab";
      "plasmashell"."repeat_action" = "Meta+Ctrl+R";
      "plasmashell"."show dashboard" = "none,Ctrl+F12,Show Desktop";
      "plasmashell"."show-barcode" = "none,,Show Barcode…";
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = "none,,Switch to Next Activity";
      "plasmashell"."switch to previous activity" = "none,,Switch to Previous Activity";
      "plasmashell"."toggle do not disturb" = "none,,Toggle do not disturb";
      "systemsettings.desktop"."_launch" = "Tools";
      "systemsettings.desktop"."kcm-kscreen" = [ ];
      "systemsettings.desktop"."kcm-lookandfeel" = [ ];
      "systemsettings.desktop"."kcm-users" = [ ];
      "systemsettings.desktop"."powerdevilprofilesconfig" = [ ];
      "systemsettings.desktop"."screenlocker" = [ ];
      "yakuake"."toggle-window-state" = "Meta+Space,F12,Open/Retract Yakuake";
    };
    configFile = {
      "baloofilerc"."General"."dbVersion" = 2;
      "baloofilerc"."General"."exclude filters" =
        "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
      "baloofilerc"."General"."exclude filters version" = 8;
      "dolphinrc"."DetailsMode"."PreviewSize" = 16;
      "dolphinrc"."ExtractDialog"."1805x1203 screen: Height" = 604;
      "dolphinrc"."ExtractDialog"."1805x1203 screen: Width" = 1203;
      "dolphinrc"."ExtractDialog"."DirHistory[$e]" = "$HOME/dev/acg/Maarten/";
      "dolphinrc"."General"."ViewPropsTimestamp" = "2024,3,16,16,13,28.249";
      "dolphinrc"."IconsMode"."PreviewSize" = 256;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."KFileDialog Settings"."detailViewIconSize" = 16;
      "kactivitymanagerdrc"."activities"."aa349499-c654-46cd-8ef2-dce34a1370ad" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "aa349499-c654-46cd-8ef2-dce34a1370ad";
      "katerc"."General"."Allow Tab Scrolling" = true;
      "katerc"."General"."Auto Hide Tabs" = false;
      "katerc"."General"."Close After Last" = false;
      "katerc"."General"."Close documents with window" = true;
      "katerc"."General"."Days Meta Infos" = 30;
      "katerc"."General"."Diff Show Style" = 0;
      "katerc"."General"."Elide Tab Text" = false;
      "katerc"."General"."Expand Tabs" = false;
      "katerc"."General"."Icon size for left and right sidebar buttons" = 32;
      "katerc"."General"."Modified Notification" = false;
      "katerc"."General"."Mouse back button action" = 0;
      "katerc"."General"."Mouse forward button action" = 0;
      "katerc"."General"."Open New Tab To The Right Of Current" = false;
      "katerc"."General"."Output History Limit" = 100;
      "katerc"."General"."Recent File List Entry Count" = 10;
      "katerc"."General"."Restore Window Configuration" = true;
      "katerc"."General"."SDI Mode" = false;
      "katerc"."General"."Save Meta Infos" = true;
      "katerc"."General"."Show Full Path in Title" = false;
      "katerc"."General"."Show Menu Bar" = true;
      "katerc"."General"."Show Status Bar" = true;
      "katerc"."General"."Show Symbol In Navigation Bar" = true;
      "katerc"."General"."Show Tab Bar" = true;
      "katerc"."General"."Show Tabs Close Button" = true;
      "katerc"."General"."Show Url Nav Bar" = true;
      "katerc"."General"."Show output view for message type" = 1;
      "katerc"."General"."Show text for left and right sidebar" = false;
      "katerc"."General"."Show welcome view for new window" = false;
      "katerc"."General"."Startup Session" = "manual";
      "katerc"."General"."Stash new unsaved files" = true;
      "katerc"."General"."Stash unsaved file changes" = false;
      "katerc"."General"."Sync section size with tab positions" = false;
      "katerc"."General"."Tab Double Click New Document" = true;
      "katerc"."General"."Tab Middle Click Close Document" = true;
      "katerc"."General"."Tabbar Tab Limit" = 0;
      "katerc"."KFileDialog Settings"."detailViewIconSize" = 16;
      "katerc"."KTextEditor Document"."Allow End of Line Detection" = true;
      "katerc"."KTextEditor Document"."Auto Detect Indent" = true;
      "katerc"."KTextEditor Document"."Auto Reload If State Is In Version Control" = true;
      "katerc"."KTextEditor Document"."Auto Save" = true;
      "katerc"."KTextEditor Document"."Auto Save Interval" = 5;
      "katerc"."KTextEditor Document"."Auto Save On Focus Out" = true;
      "katerc"."KTextEditor Document"."BOM" = false;
      "katerc"."KTextEditor Document"."Backup Local" = false;
      "katerc"."KTextEditor Document"."Backup Prefix" = "";
      "katerc"."KTextEditor Document"."Backup Remote" = false;
      "katerc"."KTextEditor Document"."Backup Suffix" = "~";
      "katerc"."KTextEditor Document"."Camel Cursor" = true;
      "katerc"."KTextEditor Document"."Encoding" = "UTF-8";
      "katerc"."KTextEditor Document"."End of Line" = 0;
      "katerc"."KTextEditor Document"."Indent On Backspace" = true;
      "katerc"."KTextEditor Document"."Indent On Tab" = true;
      "katerc"."KTextEditor Document"."Indent On Text Paste" = false;
      "katerc"."KTextEditor Document"."Indentation Mode" = "normal";
      "katerc"."KTextEditor Document"."Indentation Width" = 4;
      "katerc"."KTextEditor Document"."Keep Extra Spaces" = false;
      "katerc"."KTextEditor Document"."Line Length Limit" = 10000;
      "katerc"."KTextEditor Document"."Newline at End of File" = true;
      "katerc"."KTextEditor Document"."On-The-Fly Spellcheck" = false;
      "katerc"."KTextEditor Document"."Overwrite Mode" = false;
      "katerc"."KTextEditor Document"."PageUp/PageDown Moves Cursor" = false;
      "katerc"."KTextEditor Document"."Remove Spaces" = 1;
      "katerc"."KTextEditor Document"."ReplaceTabsDyn" = true;
      "katerc"."KTextEditor Document"."Show Spaces" = 0;
      "katerc"."KTextEditor Document"."Show Tabs" = true;
      "katerc"."KTextEditor Document"."Smart Home" = true;
      "katerc"."KTextEditor Document"."Swap Directory" = "";
      "katerc"."KTextEditor Document"."Swap File Mode" = 1;
      "katerc"."KTextEditor Document"."Swap Sync Interval" = 15;
      "katerc"."KTextEditor Document"."Tab Handling" = 2;
      "katerc"."KTextEditor Document"."Tab Width" = 4;
      "katerc"."KTextEditor Document"."Trailing Marker Size" = 1;
      "katerc"."KTextEditor Document"."Word Wrap" = false;
      "katerc"."KTextEditor Document"."Word Wrap Column" = 80;
      "katerc"."KTextEditor Editor"."Encoding Prober Type" = 1;
      "katerc"."KTextEditor Editor"."Fallback Encoding" = "ISO 8859-15";
      "katerc"."KTextEditor Renderer"."Animate Bracket Matching" = false;
      "katerc"."KTextEditor Renderer"."Auto Color Theme Selection" = true;
      "katerc"."KTextEditor Renderer"."Color Theme" = "Breeze Dark";
      "katerc"."KTextEditor Renderer"."Font" = "Hack,10,-1,7,50,0,0,0,0,0";
      "katerc"."KTextEditor Renderer"."Line Height Multiplier" = 1;
      "katerc"."KTextEditor Renderer"."Show Indentation Lines" = false;
      "katerc"."KTextEditor Renderer"."Show Whole Bracket Expression" = false;
      "katerc"."KTextEditor Renderer"."Word Wrap Marker" = false;
      "katerc"."KTextEditor View"."Allow Mark Menu" = true;
      "katerc"."KTextEditor View"."Auto Brackets" = true;
      "katerc"."KTextEditor View"."Auto Center Lines" = 0;
      "katerc"."KTextEditor View"."Auto Completion" = true;
      "katerc"."KTextEditor View"."Auto Completion Preselect First Entry" = true;
      "katerc"."KTextEditor View"."Backspace Remove Composed Characters" = false;
      "katerc"."KTextEditor View"."Bookmark Menu Sorting" = 0;
      "katerc"."KTextEditor View"."Bracket Match Preview" = false;
      "katerc"."KTextEditor View"."Chars To Enclose Selection" = "<>(){}[]'\"";
      "katerc"."KTextEditor View"."Default Mark Type" = 1;
      "katerc"."KTextEditor View"."Dynamic Word Wrap" = true;
      "katerc"."KTextEditor View"."Dynamic Word Wrap Align Indent" = 80;
      "katerc"."KTextEditor View"."Dynamic Word Wrap At Static Marker" = false;
      "katerc"."KTextEditor View"."Dynamic Word Wrap Indicators" = 1;
      "katerc"."KTextEditor View"."Dynamic Wrap not at word boundaries" = false;
      "katerc"."KTextEditor View"."Enable Tab completion" = false;
      "katerc"."KTextEditor View"."Fold First Line" = false;
      "katerc"."KTextEditor View"."Folding Bar" = true;
      "katerc"."KTextEditor View"."Folding Preview" = true;
      "katerc"."KTextEditor View"."Icon Bar" = false;
      "katerc"."KTextEditor View"."Input Mode" = 0;
      "katerc"."KTextEditor View"."Keyword Completion" = true;
      "katerc"."KTextEditor View"."Line Modification" = true;
      "katerc"."KTextEditor View"."Line Numbers" = true;
      "katerc"."KTextEditor View"."Max Clipboard History Entries" = 20;
      "katerc"."KTextEditor View"."Maximum Search History Size" = 100;
      "katerc"."KTextEditor View"."Mouse Paste At Cursor Position" = false;
      "katerc"."KTextEditor View"."Multiple Cursor Modifier" = 134217728;
      "katerc"."KTextEditor View"."Persistent Selection" = false;
      "katerc"."KTextEditor View"."Scroll Bar Marks" = false;
      "katerc"."KTextEditor View"."Scroll Bar Mini Map All" = true;
      "katerc"."KTextEditor View"."Scroll Bar Mini Map Width" = 60;
      "katerc"."KTextEditor View"."Scroll Bar MiniMap" = true;
      "katerc"."KTextEditor View"."Scroll Bar Preview" = true;
      "katerc"."KTextEditor View"."Scroll Past End" = false;
      "katerc"."KTextEditor View"."Search/Replace Flags" = 140;
      "katerc"."KTextEditor View"."Shoe Line Ending Type in Statusbar" = false;
      "katerc"."KTextEditor View"."Show Documentation With Completion" = true;
      "katerc"."KTextEditor View"."Show File Encoding" = true;
      "katerc"."KTextEditor View"."Show Focus Frame Around Editor" = true;
      "katerc"."KTextEditor View"."Show Folding Icons On Hover Only" = true;
      "katerc"."KTextEditor View"."Show Line Count" = false;
      "katerc"."KTextEditor View"."Show Scrollbars" = 0;
      "katerc"."KTextEditor View"."Show Statusbar Dictionary" = true;
      "katerc"."KTextEditor View"."Show Statusbar Highlighting Mode" = true;
      "katerc"."KTextEditor View"."Show Statusbar Input Mode" = true;
      "katerc"."KTextEditor View"."Show Statusbar Line Column" = true;
      "katerc"."KTextEditor View"."Show Statusbar Tab Settings" = true;
      "katerc"."KTextEditor View"."Show Word Count" = false;
      "katerc"."KTextEditor View"."Smart Copy Cut" = true;
      "katerc"."KTextEditor View"."Statusbar Line Column Compact Mode" = true;
      "katerc"."KTextEditor View"."Text Drag And Drop" = true;
      "katerc"."KTextEditor View"."User Sets Of Chars To Enclose Selection" = "";
      "katerc"."KTextEditor View"."Vi Input Mode Steal Keys" = false;
      "katerc"."KTextEditor View"."Vi Relative Line Numbers" = false;
      "katerc"."KTextEditor View"."Word Completion" = true;
      "katerc"."KTextEditor View"."Word Completion Minimal Word Length" = 3;
      "katerc"."KTextEditor View"."Word Completion Remove Tail" = true;
      "katerc"."KTextEditor::Search"."Search History" = "nixvim";
      "katerc"."Konsole"."AutoSyncronize" = true;
      "katerc"."Konsole"."KonsoleEscKeyBehaviour" = true;
      "katerc"."Konsole"."KonsoleEscKeyExceptions" = "vi,vim,nvim,git";
      "katerc"."Konsole"."RemoveExtension" = false;
      "katerc"."Konsole"."RunPrefix" = "";
      "katerc"."Konsole"."SetEditor" = false;
      "katerc"."Notification Messages"."kate_close_modonhd_3" = false;
      "katerc"."filetree"."editShade" = "31,81,106";
      "katerc"."filetree"."listMode" = false;
      "katerc"."filetree"."shadingEnabled" = true;
      "katerc"."filetree"."showCloseButton" = false;
      "katerc"."filetree"."showFullPathOnRoots" = false;
      "katerc"."filetree"."showToolbar" = true;
      "katerc"."filetree"."sortRole" = 0;
      "katerc"."filetree"."viewShade" = "81,49,95";
      "katerc"."kategit"."lastExecutedGitCmds" = "git push origin main,git pull origin main";
      "katerc"."lspclient"."AllowedServerCommandLines" =
        "/nix/store/wm5ayhhw5rnvl0akydd3gjz739gxvka1-glslls-0.5.0/bin/glslls --stdin,/run/current-system/sw/bin/rust-analyzer";
      "katerc"."lspclient"."AutoHover" = true;
      "katerc"."lspclient"."AutoImport" = true;
      "katerc"."lspclient"."BlockedServerCommandLines" = "";
      "katerc"."lspclient"."CompletionDocumentation" = true;
      "katerc"."lspclient"."CompletionParens" = true;
      "katerc"."lspclient"."Diagnostics" = true;
      "katerc"."lspclient"."FormatOnSave" = false;
      "katerc"."lspclient"."HighlightGoto" = true;
      "katerc"."lspclient"."IncrementalSync" = false;
      "katerc"."lspclient"."InlayHints" = false;
      "katerc"."lspclient"."Messages" = true;
      "katerc"."lspclient"."ReferencesDeclaration" = true;
      "katerc"."lspclient"."SemanticHighlighting" = true;
      "katerc"."lspclient"."ServerConfiguration" = "";
      "katerc"."lspclient"."SignatureHelp" = true;
      "katerc"."lspclient"."SymbolDetails" = false;
      "katerc"."lspclient"."SymbolExpand" = true;
      "katerc"."lspclient"."SymbolSort" = false;
      "katerc"."lspclient"."SymbolTree" = true;
      "katerc"."lspclient"."TypeFormatting" = false;
      "kcminputrc"."Libinput/1133/49278/Logitech Gaming Mouse G402"."PointerAcceleration" = "-0.600";
      "kcminputrc"."Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad"."NaturalScroll" = true;
      "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat" = true;
      "kcminputrc"."Mouse"."XLbInptNaturalScroll" = false;
      "kcminputrc"."Mouse"."XLbInptPointerAcceleration" = 0.6;
      "kcminputrc"."Tmp"."update_info" = "delete_cursor_old_default_size.upd:DeleteCursorOldDefaultSize";
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 4;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "1069,715";
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."TerminalApplication" = "yakuake";
      "kdeglobals"."General"."TerminalService" = "org.kde.yakuake.desktop";
      "kdeglobals"."General"."XftHintStyle" = "hintslight";
      "kdeglobals"."General"."XftSubPixel" = "none";
      "kdeglobals"."KDE"."SingleClick" = false;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = true;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Date";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = true;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 138;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."KScreen"."ScaleFactor" = 1.0625;
      "kdeglobals"."KScreen"."ScreenScaleFactors" =
        "eDP-1=1.0625;DP-1=1.0625;DP-2=1.0625;DP-3=1.0625;DP-4=1.0625;";
      "kdeglobals"."KShortcutsDialog Settings"."Dialog Size" = "600,480";
      "kdeglobals"."WM"."activeBackground" = "49,54,59";
      "kdeglobals"."WM"."activeBlend" = "252,252,252";
      "kdeglobals"."WM"."activeForeground" = "252,252,252";
      "kdeglobals"."WM"."inactiveBackground" = "42,46,50";
      "kdeglobals"."WM"."inactiveBlend" = "161,169,177";
      "kdeglobals"."WM"."inactiveForeground" = "161,169,177";
      "kgammarc"."ConfigFile"."use" = "kgammarc";
      "kgammarc"."Screen 0"."bgamma" = 1.25;
      "kgammarc"."Screen 0"."ggamma" = 1.25;
      "kgammarc"."Screen 0"."rgamma" = 1.25;
      "kgammarc"."SyncBox"."sync" = "no";
      "khotkeysrc"."Data"."DataCount" = 4;
      "khotkeysrc"."Data_1"."Comment" = "KMenuEdit Global Shortcuts";
      "khotkeysrc"."Data_1"."DataCount" = 1;
      "khotkeysrc"."Data_1"."Enabled" = true;
      "khotkeysrc"."Data_1"."Name" = "KMenuEdit";
      "khotkeysrc"."Data_1"."SystemGroup" = 1;
      "khotkeysrc"."Data_1"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_1_1"."Comment" = "Comment";
      "khotkeysrc"."Data_1_1"."Enabled" = true;
      "khotkeysrc"."Data_1_1"."Name" = "Search";
      "khotkeysrc"."Data_1_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_1_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_1_1Actions0"."CommandURL" = "http://google.com";
      "khotkeysrc"."Data_1_1Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_1_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_1_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_1_1Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_1_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_1_1Triggers0"."Key" = "";
      "khotkeysrc"."Data_1_1Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_1_1Triggers0"."Uuid" = "{d03619b6-9b3c-48cc-9d9c-a2aadb485550}";
      "khotkeysrc"."Data_2"."Comment" =
        "This group contains various examples demonstrating most of the features of KHotkeys. (Note that this group and all its actions are disabled by default.)";
      "khotkeysrc"."Data_2"."DataCount" = 8;
      "khotkeysrc"."Data_2"."Enabled" = true;
      "khotkeysrc"."Data_2"."ImportId" = "kde32b1";
      "khotkeysrc"."Data_2"."Name" = "Examples";
      "khotkeysrc"."Data_2"."SystemGroup" = 0;
      "khotkeysrc"."Data_2"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_1"."Comment" =
        "After pressing Ctrl+Alt+I, the KSIRC window will be activated, if it exists. Simple.";
      "khotkeysrc"."Data_2_1"."Enabled" = false;
      "khotkeysrc"."Data_2_1"."Name" = "Activate KSIRC Window";
      "khotkeysrc"."Data_2_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_1Actions0"."Type" = "ACTIVATE_WINDOW";
      "khotkeysrc"."Data_2_1Actions0Window"."Comment" = "KSIRC window";
      "khotkeysrc"."Data_2_1Actions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_1Actions0Window0"."Class" = "ksirc";
      "khotkeysrc"."Data_2_1Actions0Window0"."ClassType" = 1;
      "khotkeysrc"."Data_2_1Actions0Window0"."Comment" = "KSIRC";
      "khotkeysrc"."Data_2_1Actions0Window0"."Role" = "";
      "khotkeysrc"."Data_2_1Actions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_2_1Actions0Window0"."Title" = "";
      "khotkeysrc"."Data_2_1Actions0Window0"."TitleType" = 0;
      "khotkeysrc"."Data_2_1Actions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_1Actions0Window0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_1Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_1Triggers0"."Key" = "Ctrl+Alt+I";
      "khotkeysrc"."Data_2_1Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_1Triggers0"."Uuid" = "{5cf3cced-7fa7-40ca-91a9-6a07bec5b1db}";
      "khotkeysrc"."Data_2_2"."Comment" =
        "After pressing Alt+Ctrl+H the input of 'Hello' will be simulated, as if you typed it.  This is especially useful if you have call to frequently type a word (for instance, 'unsigned').  Every keypress in the input is separated by a colon ':'. Note that the keypresses literally mean keypresses, so you have to write what you would press on the keyboard. In the table below, the left column shows the input and the right column shows what to type.\n\n\"enter\" (i.e. new line)                Enter or Return\na (i.e. small a)                          A\nA (i.e. capital a)                       Shift+A\n: (colon)                                  Shift+;\n' '  (space)                              Space";
      "khotkeysrc"."Data_2_2"."Enabled" = false;
      "khotkeysrc"."Data_2_2"."Name" = "Type 'Hello'";
      "khotkeysrc"."Data_2_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_2Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_2Actions0"."Input" = "Shift+H:E:L:L:O\n";
      "khotkeysrc"."Data_2_2Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_2Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_2Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_2Triggers0"."Key" = "Ctrl+Alt+H";
      "khotkeysrc"."Data_2_2Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_2Triggers0"."Uuid" = "{605ad5c9-676a-48cb-a26e-038f831debd5}";
      "khotkeysrc"."Data_2_3"."Comment" = "This action runs Konsole, after pressing Ctrl+Alt+T.";
      "khotkeysrc"."Data_2_3"."Enabled" = false;
      "khotkeysrc"."Data_2_3"."Name" = "Run Konsole";
      "khotkeysrc"."Data_2_3"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_3Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_3Actions0"."CommandURL" = "konsole";
      "khotkeysrc"."Data_2_3Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_2_3Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_3Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_3Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_3Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_3Triggers0"."Key" = "Ctrl+Alt+T";
      "khotkeysrc"."Data_2_3Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_3Triggers0"."Uuid" = "{ec59f1d2-94b0-458d-bb31-d09137ecd318}";
      "khotkeysrc"."Data_2_4"."Comment" =
        "Read the comment on the \"Type 'Hello'\" action first.\n\nQt Designer uses Ctrl+F4 for closing windows.  In KDE, however, Ctrl+F4 is the shortcut for going to virtual desktop 4, so this shortcut does not work in Qt Designer.  Further, Qt Designer does not use KDE's standard Ctrl+W for closing the window.\n\nThis problem can be solved by remapping Ctrl+W to Ctrl+F4 when the active window is Qt Designer. When Qt Designer is active, every time Ctrl+W is pressed, Ctrl+F4 will be sent to Qt Designer instead. In other applications, the effect of Ctrl+W is unchanged.\n\nWe now need to specify three things: A new shortcut trigger on 'Ctrl+W', a new keyboard input action sending Ctrl+F4, and a new condition that the active window is Qt Designer.\nQt Designer seems to always have title 'Qt Designer by Trolltech', so the condition will check for the active window having that title.";
      "khotkeysrc"."Data_2_4"."Enabled" = false;
      "khotkeysrc"."Data_2_4"."Name" = "Remap Ctrl+W to Ctrl+F4 in Qt Designer";
      "khotkeysrc"."Data_2_4"."Type" = "GENERIC_ACTION_DATA";
      "khotkeysrc"."Data_2_4Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_4Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_4Actions0"."Input" = "Ctrl+F4";
      "khotkeysrc"."Data_2_4Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_4Conditions"."ConditionsCount" = 1;
      "khotkeysrc"."Data_2_4Conditions0"."Type" = "ACTIVE_WINDOW";
      "khotkeysrc"."Data_2_4Conditions0Window"."Comment" = "Qt Designer";
      "khotkeysrc"."Data_2_4Conditions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Class" = "";
      "khotkeysrc"."Data_2_4Conditions0Window0"."ClassType" = 0;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Comment" = "";
      "khotkeysrc"."Data_2_4Conditions0Window0"."Role" = "";
      "khotkeysrc"."Data_2_4Conditions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Title" = "Qt Designer by Trolltech";
      "khotkeysrc"."Data_2_4Conditions0Window0"."TitleType" = 2;
      "khotkeysrc"."Data_2_4Conditions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_4Conditions0Window0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_4Triggers"."Comment" = "";
      "khotkeysrc"."Data_2_4Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_4Triggers0"."Key" = "Ctrl+W";
      "khotkeysrc"."Data_2_4Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_4Triggers0"."Uuid" = "{65b2dcb0-e29b-4c51-9251-21261b3f120d}";
      "khotkeysrc"."Data_2_5"."Comment" =
        "By pressing Alt+Ctrl+W a D-Bus call will be performed that will show the minicli. You can use any kind of D-Bus call, just like using the command line 'qdbus' tool.";
      "khotkeysrc"."Data_2_5"."Enabled" = false;
      "khotkeysrc"."Data_2_5"."Name" = "Perform D-Bus call 'qdbus org.kde.krunner /App display'";
      "khotkeysrc"."Data_2_5"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_5Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_5Actions0"."Arguments" = "";
      "khotkeysrc"."Data_2_5Actions0"."Call" = "popupExecuteCommand";
      "khotkeysrc"."Data_2_5Actions0"."RemoteApp" = "org.kde.krunner";
      "khotkeysrc"."Data_2_5Actions0"."RemoteObj" = "/App";
      "khotkeysrc"."Data_2_5Actions0"."Type" = "DBUS";
      "khotkeysrc"."Data_2_5Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_5Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_5Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_5Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_5Triggers0"."Key" = "Ctrl+Alt+W";
      "khotkeysrc"."Data_2_5Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_5Triggers0"."Uuid" = "{e93bcb28-0bf5-4512-ab37-cc309eec75da}";
      "khotkeysrc"."Data_2_6"."Comment" =
        "Read the comment on the \"Type 'Hello'\" action first.\n\nJust like the \"Type 'Hello'\" action, this one simulates keyboard input, specifically, after pressing Ctrl+Alt+B, it sends B to XMMS (B in XMMS jumps to the next song). The 'Send to specific window' checkbox is checked and a window with its class containing 'XMMS_Player' is specified; this will make the input always be sent to this window. This way, you can control XMMS even if, for instance, it is on a different virtual desktop.\n\n(Run 'xprop' and click on the XMMS window and search for WM_CLASS to see 'XMMS_Player').";
      "khotkeysrc"."Data_2_6"."Enabled" = false;
      "khotkeysrc"."Data_2_6"."Name" = "Next in XMMS";
      "khotkeysrc"."Data_2_6"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_6Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_6Actions0"."DestinationWindow" = 1;
      "khotkeysrc"."Data_2_6Actions0"."Input" = "B";
      "khotkeysrc"."Data_2_6Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow"."Comment" = "XMMS window";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Class" = "XMMS_Player";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."ClassType" = 1;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Comment" = "XMMS Player window";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Role" = "";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."RoleType" = 0;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Title" = "";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."TitleType" = 0;
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_6Actions0DestinationWindow0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_6Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_6Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_6Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_6Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_6Triggers0"."Key" = "Ctrl+Alt+B";
      "khotkeysrc"."Data_2_6Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_6Triggers0"."Uuid" = "{09144e1e-be07-4e1f-9c02-896f01f25483}";
      "khotkeysrc"."Data_2_7"."Comment" =
        "Konqueror in KDE3.1 has tabs, and now you can also have gestures.\n\nJust press the middle mouse button and start drawing one of the gestures, and after you are finished, release the mouse button. If you only need to paste the selection, it still works, just click the middle mouse button. (You can change the mouse button to use in the global settings).\n\nRight now, there are the following gestures available:\nmove right and back left - Forward (Alt+Right)\nmove left and back right - Back (Alt+Left)\nmove up and back down  - Up (Alt+Up)\ncircle counterclockwise - Reload (F5)\n\nThe gesture shapes can be entered by performing them in the configuration dialog. You can also look at your numeric pad to help you: gestures are recognized like a 3x3 grid of fields, numbered 1 to 9.\n\nNote that you must perform exactly the gesture to trigger the action. Because of this, it is possible to enter more gestures for the action. You should try to avoid complicated gestures where you change the direction of mouse movement more than once.  For instance, 45654 or 74123 are simple to perform, but 1236987 may be already quite difficult.\n\nThe conditions for all gestures are defined in this group. All these gestures are active only if the active window is Konqueror (class contains 'konqueror').";
      "khotkeysrc"."Data_2_7"."DataCount" = 4;
      "khotkeysrc"."Data_2_7"."Enabled" = false;
      "khotkeysrc"."Data_2_7"."Name" = "Konqi Gestures";
      "khotkeysrc"."Data_2_7"."SystemGroup" = 0;
      "khotkeysrc"."Data_2_7"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_2_7Conditions"."Comment" = "Konqueror window";
      "khotkeysrc"."Data_2_7Conditions"."ConditionsCount" = 1;
      "khotkeysrc"."Data_2_7Conditions0"."Type" = "ACTIVE_WINDOW";
      "khotkeysrc"."Data_2_7Conditions0Window"."Comment" = "Konqueror";
      "khotkeysrc"."Data_2_7Conditions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Class" = "konqueror";
      "khotkeysrc"."Data_2_7Conditions0Window0"."ClassType" = 1;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Comment" = "Konqueror";
      "khotkeysrc"."Data_2_7Conditions0Window0"."Role" = "";
      "khotkeysrc"."Data_2_7Conditions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Title" = "";
      "khotkeysrc"."Data_2_7Conditions0Window0"."TitleType" = 0;
      "khotkeysrc"."Data_2_7Conditions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_2_7Conditions0Window0"."WindowTypes" = 33;
      "khotkeysrc"."Data_2_7_1"."Comment" = "";
      "khotkeysrc"."Data_2_7_1"."Enabled" = false;
      "khotkeysrc"."Data_2_7_1"."Name" = "Back";
      "khotkeysrc"."Data_2_7_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_1Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_1Actions0"."Input" = "Alt+Left";
      "khotkeysrc"."Data_2_7_1Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_1Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_1Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_1Triggers0"."GesturePointData" =
        "0,0.0625,1,1,0.5,0.0625,0.0625,1,0.875,0.5,0.125,0.0625,1,0.75,0.5,0.1875,0.0625,1,0.625,0.5,0.25,0.0625,1,0.5,0.5,0.3125,0.0625,1,0.375,0.5,0.375,0.0625,1,0.25,0.5,0.4375,0.0625,1,0.125,0.5,0.5,0.0625,0,0,0.5,0.5625,0.0625,0,0.125,0.5,0.625,0.0625,0,0.25,0.5,0.6875,0.0625,0,0.375,0.5,0.75,0.0625,0,0.5,0.5,0.8125,0.0625,0,0.625,0.5,0.875,0.0625,0,0.75,0.5,0.9375,0.0625,0,0.875,0.5,1,0,0,1,0.5";
      "khotkeysrc"."Data_2_7_1Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_1Triggers1"."GesturePointData" =
        "0,0.0833333,1,0.5,0.5,0.0833333,0.0833333,1,0.375,0.5,0.166667,0.0833333,1,0.25,0.5,0.25,0.0833333,1,0.125,0.5,0.333333,0.0833333,0,0,0.5,0.416667,0.0833333,0,0.125,0.5,0.5,0.0833333,0,0.25,0.5,0.583333,0.0833333,0,0.375,0.5,0.666667,0.0833333,0,0.5,0.5,0.75,0.0833333,0,0.625,0.5,0.833333,0.0833333,0,0.75,0.5,0.916667,0.0833333,0,0.875,0.5,1,0,0,1,0.5";
      "khotkeysrc"."Data_2_7_1Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_1Triggers2"."GesturePointData" =
        "0,0.0833333,1,1,0.5,0.0833333,0.0833333,1,0.875,0.5,0.166667,0.0833333,1,0.75,0.5,0.25,0.0833333,1,0.625,0.5,0.333333,0.0833333,1,0.5,0.5,0.416667,0.0833333,1,0.375,0.5,0.5,0.0833333,1,0.25,0.5,0.583333,0.0833333,1,0.125,0.5,0.666667,0.0833333,0,0,0.5,0.75,0.0833333,0,0.125,0.5,0.833333,0.0833333,0,0.25,0.5,0.916667,0.0833333,0,0.375,0.5,1,0,0,0.5,0.5";
      "khotkeysrc"."Data_2_7_1Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_2"."Comment" = "";
      "khotkeysrc"."Data_2_7_2"."Enabled" = false;
      "khotkeysrc"."Data_2_7_2"."Name" = "Forward";
      "khotkeysrc"."Data_2_7_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_2Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_2Actions0"."Input" = "Alt+Right";
      "khotkeysrc"."Data_2_7_2Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_2Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_2Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_2Triggers0"."GesturePointData" =
        "0,0.0625,0,0,0.5,0.0625,0.0625,0,0.125,0.5,0.125,0.0625,0,0.25,0.5,0.1875,0.0625,0,0.375,0.5,0.25,0.0625,0,0.5,0.5,0.3125,0.0625,0,0.625,0.5,0.375,0.0625,0,0.75,0.5,0.4375,0.0625,0,0.875,0.5,0.5,0.0625,1,1,0.5,0.5625,0.0625,1,0.875,0.5,0.625,0.0625,1,0.75,0.5,0.6875,0.0625,1,0.625,0.5,0.75,0.0625,1,0.5,0.5,0.8125,0.0625,1,0.375,0.5,0.875,0.0625,1,0.25,0.5,0.9375,0.0625,1,0.125,0.5,1,0,0,0,0.5";
      "khotkeysrc"."Data_2_7_2Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_2Triggers1"."GesturePointData" =
        "0,0.0833333,0,0.5,0.5,0.0833333,0.0833333,0,0.625,0.5,0.166667,0.0833333,0,0.75,0.5,0.25,0.0833333,0,0.875,0.5,0.333333,0.0833333,1,1,0.5,0.416667,0.0833333,1,0.875,0.5,0.5,0.0833333,1,0.75,0.5,0.583333,0.0833333,1,0.625,0.5,0.666667,0.0833333,1,0.5,0.5,0.75,0.0833333,1,0.375,0.5,0.833333,0.0833333,1,0.25,0.5,0.916667,0.0833333,1,0.125,0.5,1,0,0,0,0.5";
      "khotkeysrc"."Data_2_7_2Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_2Triggers2"."GesturePointData" =
        "0,0.0833333,0,0,0.5,0.0833333,0.0833333,0,0.125,0.5,0.166667,0.0833333,0,0.25,0.5,0.25,0.0833333,0,0.375,0.5,0.333333,0.0833333,0,0.5,0.5,0.416667,0.0833333,0,0.625,0.5,0.5,0.0833333,0,0.75,0.5,0.583333,0.0833333,0,0.875,0.5,0.666667,0.0833333,1,1,0.5,0.75,0.0833333,1,0.875,0.5,0.833333,0.0833333,1,0.75,0.5,0.916667,0.0833333,1,0.625,0.5,1,0,0,0.5,0.5";
      "khotkeysrc"."Data_2_7_2Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_3"."Comment" = "";
      "khotkeysrc"."Data_2_7_3"."Enabled" = false;
      "khotkeysrc"."Data_2_7_3"."Name" = "Up";
      "khotkeysrc"."Data_2_7_3"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_3Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_3Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_3Actions0"."Input" = "Alt+Up";
      "khotkeysrc"."Data_2_7_3Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_3Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_3Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_3Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_3Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_3Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_2_7_3Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_3Triggers1"."GesturePointData" =
        "0,0.0833333,-0.5,0.5,1,0.0833333,0.0833333,-0.5,0.5,0.875,0.166667,0.0833333,-0.5,0.5,0.75,0.25,0.0833333,-0.5,0.5,0.625,0.333333,0.0833333,-0.5,0.5,0.5,0.416667,0.0833333,-0.5,0.5,0.375,0.5,0.0833333,-0.5,0.5,0.25,0.583333,0.0833333,-0.5,0.5,0.125,0.666667,0.0833333,0.5,0.5,0,0.75,0.0833333,0.5,0.5,0.125,0.833333,0.0833333,0.5,0.5,0.25,0.916667,0.0833333,0.5,0.5,0.375,1,0,0,0.5,0.5";
      "khotkeysrc"."Data_2_7_3Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_3Triggers2"."GesturePointData" =
        "0,0.0833333,-0.5,0.5,0.5,0.0833333,0.0833333,-0.5,0.5,0.375,0.166667,0.0833333,-0.5,0.5,0.25,0.25,0.0833333,-0.5,0.5,0.125,0.333333,0.0833333,0.5,0.5,0,0.416667,0.0833333,0.5,0.5,0.125,0.5,0.0833333,0.5,0.5,0.25,0.583333,0.0833333,0.5,0.5,0.375,0.666667,0.0833333,0.5,0.5,0.5,0.75,0.0833333,0.5,0.5,0.625,0.833333,0.0833333,0.5,0.5,0.75,0.916667,0.0833333,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_2_7_3Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_4"."Comment" = "";
      "khotkeysrc"."Data_2_7_4"."Enabled" = false;
      "khotkeysrc"."Data_2_7_4"."Name" = "Reload";
      "khotkeysrc"."Data_2_7_4"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_7_4Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_7_4Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_2_7_4Actions0"."Input" = "F5";
      "khotkeysrc"."Data_2_7_4Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_2_7_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_7_4Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_7_4Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_2_7_4Triggers"."TriggersCount" = 3;
      "khotkeysrc"."Data_2_7_4Triggers0"."GesturePointData" =
        "0,0.03125,0,0,1,0.03125,0.03125,0,0.125,1,0.0625,0.03125,0,0.25,1,0.09375,0.03125,0,0.375,1,0.125,0.03125,0,0.5,1,0.15625,0.03125,0,0.625,1,0.1875,0.03125,0,0.75,1,0.21875,0.03125,0,0.875,1,0.25,0.03125,-0.5,1,1,0.28125,0.03125,-0.5,1,0.875,0.3125,0.03125,-0.5,1,0.75,0.34375,0.03125,-0.5,1,0.625,0.375,0.03125,-0.5,1,0.5,0.40625,0.03125,-0.5,1,0.375,0.4375,0.03125,-0.5,1,0.25,0.46875,0.03125,-0.5,1,0.125,0.5,0.03125,1,1,0,0.53125,0.03125,1,0.875,0,0.5625,0.03125,1,0.75,0,0.59375,0.03125,1,0.625,0,0.625,0.03125,1,0.5,0,0.65625,0.03125,1,0.375,0,0.6875,0.03125,1,0.25,0,0.71875,0.03125,1,0.125,0,0.75,0.03125,0.5,0,0,0.78125,0.03125,0.5,0,0.125,0.8125,0.03125,0.5,0,0.25,0.84375,0.03125,0.5,0,0.375,0.875,0.03125,0.5,0,0.5,0.90625,0.03125,0.5,0,0.625,0.9375,0.03125,0.5,0,0.75,0.96875,0.03125,0.5,0,0.875,1,0,0,0,1";
      "khotkeysrc"."Data_2_7_4Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_4Triggers1"."GesturePointData" =
        "0,0.0277778,0,0,1,0.0277778,0.0277778,0,0.125,1,0.0555556,0.0277778,0,0.25,1,0.0833333,0.0277778,0,0.375,1,0.111111,0.0277778,0,0.5,1,0.138889,0.0277778,0,0.625,1,0.166667,0.0277778,0,0.75,1,0.194444,0.0277778,0,0.875,1,0.222222,0.0277778,-0.5,1,1,0.25,0.0277778,-0.5,1,0.875,0.277778,0.0277778,-0.5,1,0.75,0.305556,0.0277778,-0.5,1,0.625,0.333333,0.0277778,-0.5,1,0.5,0.361111,0.0277778,-0.5,1,0.375,0.388889,0.0277778,-0.5,1,0.25,0.416667,0.0277778,-0.5,1,0.125,0.444444,0.0277778,1,1,0,0.472222,0.0277778,1,0.875,0,0.5,0.0277778,1,0.75,0,0.527778,0.0277778,1,0.625,0,0.555556,0.0277778,1,0.5,0,0.583333,0.0277778,1,0.375,0,0.611111,0.0277778,1,0.25,0,0.638889,0.0277778,1,0.125,0,0.666667,0.0277778,0.5,0,0,0.694444,0.0277778,0.5,0,0.125,0.722222,0.0277778,0.5,0,0.25,0.75,0.0277778,0.5,0,0.375,0.777778,0.0277778,0.5,0,0.5,0.805556,0.0277778,0.5,0,0.625,0.833333,0.0277778,0.5,0,0.75,0.861111,0.0277778,0.5,0,0.875,0.888889,0.0277778,0,0,1,0.916667,0.0277778,0,0.125,1,0.944444,0.0277778,0,0.25,1,0.972222,0.0277778,0,0.375,1,1,0,0,0.5,1";
      "khotkeysrc"."Data_2_7_4Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_7_4Triggers2"."GesturePointData" =
        "0,0.0277778,0.5,0,0.5,0.0277778,0.0277778,0.5,0,0.625,0.0555556,0.0277778,0.5,0,0.75,0.0833333,0.0277778,0.5,0,0.875,0.111111,0.0277778,0,0,1,0.138889,0.0277778,0,0.125,1,0.166667,0.0277778,0,0.25,1,0.194444,0.0277778,0,0.375,1,0.222222,0.0277778,0,0.5,1,0.25,0.0277778,0,0.625,1,0.277778,0.0277778,0,0.75,1,0.305556,0.0277778,0,0.875,1,0.333333,0.0277778,-0.5,1,1,0.361111,0.0277778,-0.5,1,0.875,0.388889,0.0277778,-0.5,1,0.75,0.416667,0.0277778,-0.5,1,0.625,0.444444,0.0277778,-0.5,1,0.5,0.472222,0.0277778,-0.5,1,0.375,0.5,0.0277778,-0.5,1,0.25,0.527778,0.0277778,-0.5,1,0.125,0.555556,0.0277778,1,1,0,0.583333,0.0277778,1,0.875,0,0.611111,0.0277778,1,0.75,0,0.638889,0.0277778,1,0.625,0,0.666667,0.0277778,1,0.5,0,0.694444,0.0277778,1,0.375,0,0.722222,0.0277778,1,0.25,0,0.75,0.0277778,1,0.125,0,0.777778,0.0277778,0.5,0,0,0.805556,0.0277778,0.5,0,0.125,0.833333,0.0277778,0.5,0,0.25,0.861111,0.0277778,0.5,0,0.375,0.888889,0.0277778,0.5,0,0.5,0.916667,0.0277778,0.5,0,0.625,0.944444,0.0277778,0.5,0,0.75,0.972222,0.0277778,0.5,0,0.875,1,0,0,0,1";
      "khotkeysrc"."Data_2_7_4Triggers2"."Type" = "GESTURE";
      "khotkeysrc"."Data_2_8"."Comment" =
        "After pressing Win+E (Tux+E) a WWW browser will be launched, and it will open http://www.kde.org . You may run all kind of commands you can run in minicli (Alt+F2).";
      "khotkeysrc"."Data_2_8"."Enabled" = false;
      "khotkeysrc"."Data_2_8"."Name" = "Go to KDE Website";
      "khotkeysrc"."Data_2_8"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_2_8Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_2_8Actions0"."CommandURL" = "http://www.kde.org";
      "khotkeysrc"."Data_2_8Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_2_8Conditions"."Comment" = "";
      "khotkeysrc"."Data_2_8Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_2_8Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_2_8Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_2_8Triggers0"."Key" = "Meta+E";
      "khotkeysrc"."Data_2_8Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_2_8Triggers0"."Uuid" = "{bd639eb9-4d51-4353-93c1-97796f74a012}";
      "khotkeysrc"."Data_3"."Comment" = "Basic Konqueror gestures.";
      "khotkeysrc"."Data_3"."DataCount" = 14;
      "khotkeysrc"."Data_3"."Enabled" = true;
      "khotkeysrc"."Data_3"."ImportId" = "konqueror_gestures_kde321";
      "khotkeysrc"."Data_3"."Name" = "Konqueror Gestures";
      "khotkeysrc"."Data_3"."SystemGroup" = 0;
      "khotkeysrc"."Data_3"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_3Conditions"."Comment" = "Konqueror window";
      "khotkeysrc"."Data_3Conditions"."ConditionsCount" = 1;
      "khotkeysrc"."Data_3Conditions0"."Type" = "ACTIVE_WINDOW";
      "khotkeysrc"."Data_3Conditions0Window"."Comment" = "Konqueror";
      "khotkeysrc"."Data_3Conditions0Window"."WindowsCount" = 1;
      "khotkeysrc"."Data_3Conditions0Window0"."Class" = "^konqueror\s";
      "khotkeysrc"."Data_3Conditions0Window0"."ClassType" = 3;
      "khotkeysrc"."Data_3Conditions0Window0"."Comment" = "Konqueror";
      "khotkeysrc"."Data_3Conditions0Window0"."Role" = "konqueror-mainwindow#1";
      "khotkeysrc"."Data_3Conditions0Window0"."RoleType" = 0;
      "khotkeysrc"."Data_3Conditions0Window0"."Title" = "file:/ - Konqueror";
      "khotkeysrc"."Data_3Conditions0Window0"."TitleType" = 0;
      "khotkeysrc"."Data_3Conditions0Window0"."Type" = "SIMPLE";
      "khotkeysrc"."Data_3Conditions0Window0"."WindowTypes" = 1;
      "khotkeysrc"."Data_3_1"."Comment" = "Press, move left, release.";
      "khotkeysrc"."Data_3_1"."Enabled" = true;
      "khotkeysrc"."Data_3_1"."Name" = "Back";
      "khotkeysrc"."Data_3_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_10"."Comment" =
        "Opera-style: Press, move up, release.\nNOTE: Conflicts with 'New Tab', and as such is disabled by default.";
      "khotkeysrc"."Data_3_10"."Enabled" = false;
      "khotkeysrc"."Data_3_10"."Name" = "Stop Loading";
      "khotkeysrc"."Data_3_10"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_10Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_10Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_10Actions0"."Input" = "Escape\n";
      "khotkeysrc"."Data_3_10Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_10Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_10Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_10Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_10Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_10Triggers0"."GesturePointData" =
        "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
      "khotkeysrc"."Data_3_10Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_11"."Comment" =
        "Going up in URL/directory structure.\nMozilla-style: Press, move up, move left, move up, release.";
      "khotkeysrc"."Data_3_11"."Enabled" = true;
      "khotkeysrc"."Data_3_11"."Name" = "Up";
      "khotkeysrc"."Data_3_11"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_11Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_11Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_11Actions0"."Input" = "Alt+Up";
      "khotkeysrc"."Data_3_11Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_11Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_11Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_11Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_11Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_11Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,1,1,0.5,0.3125,0.0625,1,0.875,0.5,0.375,0.0625,1,0.75,0.5,0.4375,0.0625,1,0.625,0.5,0.5,0.0625,1,0.5,0.5,0.5625,0.0625,1,0.375,0.5,0.625,0.0625,1,0.25,0.5,0.6875,0.0625,1,0.125,0.5,0.75,0.0625,-0.5,0,0.5,0.8125,0.0625,-0.5,0,0.375,0.875,0.0625,-0.5,0,0.25,0.9375,0.0625,-0.5,0,0.125,1,0,0,0,0";
      "khotkeysrc"."Data_3_11Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_12"."Comment" =
        "Going up in URL/directory structure.\nOpera-style: Press, move up, move left, move up, release.\nNOTE: Conflicts with  \"Activate Previous Tab\", and as such is disabled by default.";
      "khotkeysrc"."Data_3_12"."Enabled" = false;
      "khotkeysrc"."Data_3_12"."Name" = "Up #2";
      "khotkeysrc"."Data_3_12"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_12Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_12Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_12Actions0"."Input" = "Alt+Up\n";
      "khotkeysrc"."Data_3_12Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_12Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_12Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_12Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_12Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_12Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
      "khotkeysrc"."Data_3_12Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_13"."Comment" = "Press, move up, move right, release.";
      "khotkeysrc"."Data_3_13"."Enabled" = true;
      "khotkeysrc"."Data_3_13"."Name" = "Activate Next Tab";
      "khotkeysrc"."Data_3_13"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_13Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_13Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_13Actions0"."Input" = "Ctrl+.\n";
      "khotkeysrc"."Data_3_13Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_13Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_13Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_13Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_13Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_13Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,0,1,0.0625,0.0625,-0.5,0,0.875,0.125,0.0625,-0.5,0,0.75,0.1875,0.0625,-0.5,0,0.625,0.25,0.0625,-0.5,0,0.5,0.3125,0.0625,-0.5,0,0.375,0.375,0.0625,-0.5,0,0.25,0.4375,0.0625,-0.5,0,0.125,0.5,0.0625,0,0,0,0.5625,0.0625,0,0.125,0,0.625,0.0625,0,0.25,0,0.6875,0.0625,0,0.375,0,0.75,0.0625,0,0.5,0,0.8125,0.0625,0,0.625,0,0.875,0.0625,0,0.75,0,0.9375,0.0625,0,0.875,0,1,0,0,1,0";
      "khotkeysrc"."Data_3_13Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_14"."Comment" = "Press, move up, move left, release.";
      "khotkeysrc"."Data_3_14"."Enabled" = true;
      "khotkeysrc"."Data_3_14"."Name" = "Activate Previous Tab";
      "khotkeysrc"."Data_3_14"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_14Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_14Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_14Actions0"."Input" = "Ctrl+,";
      "khotkeysrc"."Data_3_14Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_14Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_14Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_14Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_14Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_14Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
      "khotkeysrc"."Data_3_14Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_1Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_1Actions0"."Input" = "Alt+Left";
      "khotkeysrc"."Data_3_1Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_1Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_1Triggers0"."GesturePointData" =
        "0,0.125,1,1,0.5,0.125,0.125,1,0.875,0.5,0.25,0.125,1,0.75,0.5,0.375,0.125,1,0.625,0.5,0.5,0.125,1,0.5,0.5,0.625,0.125,1,0.375,0.5,0.75,0.125,1,0.25,0.5,0.875,0.125,1,0.125,0.5,1,0,0,0,0.5";
      "khotkeysrc"."Data_3_1Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_2"."Comment" = "Press, move down, move up, move down, release.";
      "khotkeysrc"."Data_3_2"."Enabled" = true;
      "khotkeysrc"."Data_3_2"."Name" = "Duplicate Tab";
      "khotkeysrc"."Data_3_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_2Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_2Actions0"."Input" = "Ctrl+Shift+D\n";
      "khotkeysrc"."Data_3_2Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_2Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_2Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_2Triggers0"."GesturePointData" =
        "0,0.0416667,0.5,0.5,0,0.0416667,0.0416667,0.5,0.5,0.125,0.0833333,0.0416667,0.5,0.5,0.25,0.125,0.0416667,0.5,0.5,0.375,0.166667,0.0416667,0.5,0.5,0.5,0.208333,0.0416667,0.5,0.5,0.625,0.25,0.0416667,0.5,0.5,0.75,0.291667,0.0416667,0.5,0.5,0.875,0.333333,0.0416667,-0.5,0.5,1,0.375,0.0416667,-0.5,0.5,0.875,0.416667,0.0416667,-0.5,0.5,0.75,0.458333,0.0416667,-0.5,0.5,0.625,0.5,0.0416667,-0.5,0.5,0.5,0.541667,0.0416667,-0.5,0.5,0.375,0.583333,0.0416667,-0.5,0.5,0.25,0.625,0.0416667,-0.5,0.5,0.125,0.666667,0.0416667,0.5,0.5,0,0.708333,0.0416667,0.5,0.5,0.125,0.75,0.0416667,0.5,0.5,0.25,0.791667,0.0416667,0.5,0.5,0.375,0.833333,0.0416667,0.5,0.5,0.5,0.875,0.0416667,0.5,0.5,0.625,0.916667,0.0416667,0.5,0.5,0.75,0.958333,0.0416667,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_3_2Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_3"."Comment" = "Press, move down, move up, release.";
      "khotkeysrc"."Data_3_3"."Enabled" = true;
      "khotkeysrc"."Data_3_3"."Name" = "Duplicate Window";
      "khotkeysrc"."Data_3_3"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_3Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_3Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_3Actions0"."Input" = "Ctrl+D\n";
      "khotkeysrc"."Data_3_3Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_3Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_3Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_3Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_3Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_3Triggers0"."GesturePointData" =
        "0,0.0625,0.5,0.5,0,0.0625,0.0625,0.5,0.5,0.125,0.125,0.0625,0.5,0.5,0.25,0.1875,0.0625,0.5,0.5,0.375,0.25,0.0625,0.5,0.5,0.5,0.3125,0.0625,0.5,0.5,0.625,0.375,0.0625,0.5,0.5,0.75,0.4375,0.0625,0.5,0.5,0.875,0.5,0.0625,-0.5,0.5,1,0.5625,0.0625,-0.5,0.5,0.875,0.625,0.0625,-0.5,0.5,0.75,0.6875,0.0625,-0.5,0.5,0.625,0.75,0.0625,-0.5,0.5,0.5,0.8125,0.0625,-0.5,0.5,0.375,0.875,0.0625,-0.5,0.5,0.25,0.9375,0.0625,-0.5,0.5,0.125,1,0,0,0.5,0";
      "khotkeysrc"."Data_3_3Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_4"."Comment" = "Press, move right, release.";
      "khotkeysrc"."Data_3_4"."Enabled" = true;
      "khotkeysrc"."Data_3_4"."Name" = "Forward";
      "khotkeysrc"."Data_3_4"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_4Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_4Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_4Actions0"."Input" = "Alt+Right";
      "khotkeysrc"."Data_3_4Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_4Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_4Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_4Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_4Triggers0"."GesturePointData" =
        "0,0.125,0,0,0.5,0.125,0.125,0,0.125,0.5,0.25,0.125,0,0.25,0.5,0.375,0.125,0,0.375,0.5,0.5,0.125,0,0.5,0.5,0.625,0.125,0,0.625,0.5,0.75,0.125,0,0.75,0.5,0.875,0.125,0,0.875,0.5,1,0,0,1,0.5";
      "khotkeysrc"."Data_3_4Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_5"."Comment" =
        "Press, move down, move half up, move right, move down, release.\n(Drawing a lowercase 'h'.)";
      "khotkeysrc"."Data_3_5"."Enabled" = true;
      "khotkeysrc"."Data_3_5"."Name" = "Home";
      "khotkeysrc"."Data_3_5"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_5Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_5Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_5Actions0"."Input" = "Alt+Home\n";
      "khotkeysrc"."Data_3_5Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_5Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_5Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_5Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_5Triggers"."TriggersCount" = 2;
      "khotkeysrc"."Data_3_5Triggers0"."GesturePointData" =
        "0,0.0461748,0.5,0,0,0.0461748,0.0461748,0.5,0,0.125,0.0923495,0.0461748,0.5,0,0.25,0.138524,0.0461748,0.5,0,0.375,0.184699,0.0461748,0.5,0,0.5,0.230874,0.0461748,0.5,0,0.625,0.277049,0.0461748,0.5,0,0.75,0.323223,0.0461748,0.5,0,0.875,0.369398,0.065301,-0.25,0,1,0.434699,0.065301,-0.25,0.125,0.875,0.5,0.065301,-0.25,0.25,0.75,0.565301,0.065301,-0.25,0.375,0.625,0.630602,0.0461748,0,0.5,0.5,0.676777,0.0461748,0,0.625,0.5,0.722951,0.0461748,0,0.75,0.5,0.769126,0.0461748,0,0.875,0.5,0.815301,0.0461748,0.5,1,0.5,0.861476,0.0461748,0.5,1,0.625,0.90765,0.0461748,0.5,1,0.75,0.953825,0.0461748,0.5,1,0.875,1,0,0,1,1";
      "khotkeysrc"."Data_3_5Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_5Triggers1"."GesturePointData" =
        "0,0.0416667,0.5,0,0,0.0416667,0.0416667,0.5,0,0.125,0.0833333,0.0416667,0.5,0,0.25,0.125,0.0416667,0.5,0,0.375,0.166667,0.0416667,0.5,0,0.5,0.208333,0.0416667,0.5,0,0.625,0.25,0.0416667,0.5,0,0.75,0.291667,0.0416667,0.5,0,0.875,0.333333,0.0416667,-0.5,0,1,0.375,0.0416667,-0.5,0,0.875,0.416667,0.0416667,-0.5,0,0.75,0.458333,0.0416667,-0.5,0,0.625,0.5,0.0416667,0,0,0.5,0.541667,0.0416667,0,0.125,0.5,0.583333,0.0416667,0,0.25,0.5,0.625,0.0416667,0,0.375,0.5,0.666667,0.0416667,0,0.5,0.5,0.708333,0.0416667,0,0.625,0.5,0.75,0.0416667,0,0.75,0.5,0.791667,0.0416667,0,0.875,0.5,0.833333,0.0416667,0.5,1,0.5,0.875,0.0416667,0.5,1,0.625,0.916667,0.0416667,0.5,1,0.75,0.958333,0.0416667,0.5,1,0.875,1,0,0,1,1";
      "khotkeysrc"."Data_3_5Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_6"."Comment" =
        "Press, move right, move down, move right, release.\nMozilla-style: Press, move down, move right, release.";
      "khotkeysrc"."Data_3_6"."Enabled" = true;
      "khotkeysrc"."Data_3_6"."Name" = "Close Tab";
      "khotkeysrc"."Data_3_6"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_6Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_6Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_6Actions0"."Input" = "Ctrl+W\n";
      "khotkeysrc"."Data_3_6Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_6Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_6Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_6Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_6Triggers"."TriggersCount" = 2;
      "khotkeysrc"."Data_3_6Triggers0"."GesturePointData" =
        "0,0.0625,0,0,0,0.0625,0.0625,0,0.125,0,0.125,0.0625,0,0.25,0,0.1875,0.0625,0,0.375,0,0.25,0.0625,0.5,0.5,0,0.3125,0.0625,0.5,0.5,0.125,0.375,0.0625,0.5,0.5,0.25,0.4375,0.0625,0.5,0.5,0.375,0.5,0.0625,0.5,0.5,0.5,0.5625,0.0625,0.5,0.5,0.625,0.625,0.0625,0.5,0.5,0.75,0.6875,0.0625,0.5,0.5,0.875,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
      "khotkeysrc"."Data_3_6Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_6Triggers1"."GesturePointData" =
        "0,0.0625,0.5,0,0,0.0625,0.0625,0.5,0,0.125,0.125,0.0625,0.5,0,0.25,0.1875,0.0625,0.5,0,0.375,0.25,0.0625,0.5,0,0.5,0.3125,0.0625,0.5,0,0.625,0.375,0.0625,0.5,0,0.75,0.4375,0.0625,0.5,0,0.875,0.5,0.0625,0,0,1,0.5625,0.0625,0,0.125,1,0.625,0.0625,0,0.25,1,0.6875,0.0625,0,0.375,1,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
      "khotkeysrc"."Data_3_6Triggers1"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_7"."Comment" =
        "Press, move up, release.\nConflicts with Opera-style 'Up #2', which is disabled by default.";
      "khotkeysrc"."Data_3_7"."Enabled" = true;
      "khotkeysrc"."Data_3_7"."Name" = "New Tab";
      "khotkeysrc"."Data_3_7"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_7Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_7Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_7Actions0"."Input" = "Ctrl+Shift+N";
      "khotkeysrc"."Data_3_7Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_7Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_7Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_7Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_7Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_7Triggers0"."GesturePointData" =
        "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
      "khotkeysrc"."Data_3_7Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_8"."Comment" = "Press, move down, release.";
      "khotkeysrc"."Data_3_8"."Enabled" = true;
      "khotkeysrc"."Data_3_8"."Name" = "New Window";
      "khotkeysrc"."Data_3_8"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_8Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_8Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_8Actions0"."Input" = "Ctrl+N\n";
      "khotkeysrc"."Data_3_8Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_8Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_8Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_8Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_8Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_8Triggers0"."GesturePointData" =
        "0,0.125,0.5,0.5,0,0.125,0.125,0.5,0.5,0.125,0.25,0.125,0.5,0.5,0.25,0.375,0.125,0.5,0.5,0.375,0.5,0.125,0.5,0.5,0.5,0.625,0.125,0.5,0.5,0.625,0.75,0.125,0.5,0.5,0.75,0.875,0.125,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_3_8Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_3_9"."Comment" = "Press, move up, move down, release.";
      "khotkeysrc"."Data_3_9"."Enabled" = true;
      "khotkeysrc"."Data_3_9"."Name" = "Reload";
      "khotkeysrc"."Data_3_9"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_3_9Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_3_9Actions0"."DestinationWindow" = 2;
      "khotkeysrc"."Data_3_9Actions0"."Input" = "F5";
      "khotkeysrc"."Data_3_9Actions0"."Type" = "KEYBOARD_INPUT";
      "khotkeysrc"."Data_3_9Conditions"."Comment" = "";
      "khotkeysrc"."Data_3_9Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_3_9Triggers"."Comment" = "Gesture_triggers";
      "khotkeysrc"."Data_3_9Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_3_9Triggers0"."GesturePointData" =
        "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
      "khotkeysrc"."Data_3_9Triggers0"."Type" = "GESTURE";
      "khotkeysrc"."Data_4"."Comment" = "Comment";
      "khotkeysrc"."Data_4"."DataCount" = 2;
      "khotkeysrc"."Data_4"."Enabled" = true;
      "khotkeysrc"."Data_4"."Name" = "Stroby";
      "khotkeysrc"."Data_4"."SystemGroup" = 0;
      "khotkeysrc"."Data_4"."Type" = "ACTION_DATA_GROUP";
      "khotkeysrc"."Data_4Conditions"."Comment" = "";
      "khotkeysrc"."Data_4Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_4_1"."Comment" = "Comment";
      "khotkeysrc"."Data_4_1"."Enabled" = true;
      "khotkeysrc"."Data_4_1"."Name" = "Open Nix Config";
      "khotkeysrc"."Data_4_1"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_4_1Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_4_1Actions0"."CommandURL" = "kate ~/nixos";
      "khotkeysrc"."Data_4_1Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_4_1Conditions"."Comment" = "";
      "khotkeysrc"."Data_4_1Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_4_1Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_4_1Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_4_1Triggers0"."Key" = "Ctrl+F12";
      "khotkeysrc"."Data_4_1Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_4_1Triggers0"."Uuid" = "{b42f609d-4eae-4924-acba-b9b74d753f4d}";
      "khotkeysrc"."Data_4_2"."Comment" = "Comment";
      "khotkeysrc"."Data_4_2"."Enabled" = false;
      "khotkeysrc"."Data_4_2"."Name" = "Open NVim Config";
      "khotkeysrc"."Data_4_2"."Type" = "SIMPLE_ACTION_DATA";
      "khotkeysrc"."Data_4_2Actions"."ActionsCount" = 1;
      "khotkeysrc"."Data_4_2Actions0"."CommandURL" = "kate ~/.config/nvim";
      "khotkeysrc"."Data_4_2Actions0"."Type" = "COMMAND_URL";
      "khotkeysrc"."Data_4_2Conditions"."Comment" = "";
      "khotkeysrc"."Data_4_2Conditions"."ConditionsCount" = 0;
      "khotkeysrc"."Data_4_2Triggers"."Comment" = "Simple_action";
      "khotkeysrc"."Data_4_2Triggers"."TriggersCount" = 1;
      "khotkeysrc"."Data_4_2Triggers0"."Key" = "";
      "khotkeysrc"."Data_4_2Triggers0"."Type" = "SHORTCUT";
      "khotkeysrc"."Data_4_2Triggers0"."Uuid" = "{144ee464-e2c8-4660-9aa8-4e095b0c5023}";
      "khotkeysrc"."DirSelect Dialog"."DirSelectDialog Size[$d]" = "";
      "khotkeysrc"."General"."BrowserApplication[$d]" = "";
      "khotkeysrc"."General"."ColorSchemeHash[$d]" = "";
      "khotkeysrc"."General"."ColorScheme[$d]" = "";
      "khotkeysrc"."General"."TerminalApplication[$d]" = "";
      "khotkeysrc"."General"."TerminalService[$d]" = "";
      "khotkeysrc"."General"."XftHintStyle[$d]" = "";
      "khotkeysrc"."General"."XftSubPixel[$d]" = "";
      "khotkeysrc"."Gestures"."Disabled" = true;
      "khotkeysrc"."Gestures"."MouseButton" = 2;
      "khotkeysrc"."Gestures"."Timeout" = 300;
      "khotkeysrc"."GesturesExclude"."Comment" = "";
      "khotkeysrc"."GesturesExclude"."WindowsCount" = 0;
      "khotkeysrc"."Icons"."Theme[$d]" = "";
      "khotkeysrc"."KDE"."LookAndFeelPackage[$d]" = "";
      "khotkeysrc"."KDE"."SingleClick[$d]" = "";
      "khotkeysrc"."KDE"."widgetStyle[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Allow Expansion[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Automatically select filename extension[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Breadcrumb Navigation[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Decoration position[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."LocationCombo Completionmode[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."PathCombo Completionmode[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Bookmarks[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Full Path[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Inline Previews[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Preview[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show Speedbar[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Show hidden files[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort by[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort directories first[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort hidden files last[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Sort reversed[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."Speedbar Width[$d]" = "";
      "khotkeysrc"."KFileDialog Settings"."View Style[$d]" = "";
      "khotkeysrc"."KScreen"."ScaleFactor[$d]" = "";
      "khotkeysrc"."KScreen"."ScreenScaleFactors[$d]" = "";
      "khotkeysrc"."KShortcutsDialog Settings"."Dialog Size[$d]" = "";
      "khotkeysrc"."Main"."AlreadyImported" = "defaults,kde32b1,konqueror_gestures_kde321";
      "khotkeysrc"."Main"."Disabled" = false;
      "khotkeysrc"."Voice"."Shortcut" = "";
      "khotkeysrc"."WM"."activeBackground[$d]" = "";
      "khotkeysrc"."WM"."activeBlend[$d]" = "";
      "khotkeysrc"."WM"."activeForeground[$d]" = "";
      "khotkeysrc"."WM"."inactiveBackground[$d]" = "";
      "khotkeysrc"."WM"."inactiveBlend[$d]" = "";
      "khotkeysrc"."WM"."inactiveForeground[$d]" = "";
      "kiorc"."Confirmations"."ConfirmDelete" = false;
      "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
      "kiorc"."Executable scripts"."behaviourOnLaunch" = "execute";
      "ksmserverrc"."General"."confirmLogout" = false;
      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"."Desktops"."Id_1" = "4e5da478-4d3a-403d-ba82-8d898d0f6d5a";
      "kwinrc"."Desktops"."Id_2" = "98c3a9ef-486f-4f46-8f53-7c86b04e6705";
      "kwinrc"."Desktops"."Id_3" = "47abe191-9a4a-4659-a17e-3a4f056610fd";
      "kwinrc"."Desktops"."Id_4" = "99bc10a4-bd03-4c04-a214-827a62f1daf7";
      "kwinrc"."Desktops"."Number" = 4;
      "kwinrc"."Desktops"."Rows" = 2;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling/156cd5cf-43fc-56fb-b18a-a2699b27a52b"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/18c72a1b-b7fd-5a1c-91bc-3ed1c56e5abc"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/213a9620-187e-58a6-b80b-85d8fb95dfce"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/267ed368-d5d7-59d0-be1c-422d27b4e5c4"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/324055c1-4363-5720-97b5-a5fe2fbc8137"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/45fe0664-c932-5a6b-aeeb-b2fa4e252074"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/57d1dc0e-aba6-54f2-8401-1b4b4c1e7170"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/5b7a5ba4-43cc-5910-8e98-f358f9d54b43"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/811ccb43-b667-5f51-b2e8-f7253a3b2749"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/8c7f2678-f72c-502c-a598-c4bb7ffc45ba"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/91128530-ae52-5ea2-83f5-cc527773f934"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/b1c02637-64c5-5021-bee0-c1cd6bb56e4c"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/d67b1509-69a3-585f-adcc-1048a4265c4f"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/dd10eee0-376f-50e0-a4fb-40eca4ea6d1f"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/e3824f5f-653d-5c42-8a23-fc10d4d2d2dc"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Tiling/ececd6c7-8d4e-5cdb-b5e6-34e9e21207b5"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Xwayland"."Scale" = 1.5;
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasmanotifyrc"."Applications/discord"."Seen" = true;
      "plasmanotifyrc"."Applications/firefox"."Seen" = true;
      "plasmanotifyrc"."Applications/org.kde.yakuake"."ShowPopupsInDndMode" = true;
      "plasmanotifyrc"."Applications/org.telegram.desktop"."Seen" = true;
      "plasmanotifyrc"."Applications/thunderbird"."Seen" = true;
      "plasmanotifyrc"."Badges"."InTaskManager" = false;
      "plasmanotifyrc"."Notifications"."CriticalInDndMode" = false;
      "plasmanotifyrc"."Notifications"."LowPriorityPopups" = false;
      "plasmaparc"."General"."AudioFeedback" = false;
      "plasmaparc"."General"."RaiseMaximumVolume" = true;
      "plasmarc"."Wallpapers"."usersWallpapers" =
        "/home/stroby/Downloads/IMG_0710(1).jpg,/home/stroby/Downloads/y1jqr8m0fv531.jpg";
      "spectaclerc"."Annotations"."annotationToolType" = 3;
      "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
      "spectaclerc"."General"."onLaunchAction" = "UseLastUsedCapturemode";
      "spectaclerc"."GuiConfig"."captureMode" = 0;
      "spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
      "spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
    };
    dataFile = {
      "dolphin/view_properties/global/.directory"."Dolphin"."SortOrder" = 1;
      "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
      "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
      "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      "kate/anonymous.katesession"."Document 0"."Bookmarks" = "";
      "kate/anonymous.katesession"."Document 0"."Encoding" = "UTF-8";
      "kate/anonymous.katesession"."Document 0"."Highlighting" = "None";
      "kate/anonymous.katesession"."Document 0"."Highlighting Set By User" = false;
      "kate/anonymous.katesession"."Document 0"."Indentation Mode" = "normal";
      "kate/anonymous.katesession"."Document 0"."Mode" = "Normal";
      "kate/anonymous.katesession"."Document 0"."Mode Set By User" = false;
      "kate/anonymous.katesession"."Document 0"."URL" = "";
      "kate/anonymous.katesession"."Document 1"."Bookmarks" = "";
      "kate/anonymous.katesession"."Document 1"."Encoding" = "UTF-8";
      "kate/anonymous.katesession"."Document 1"."Highlighting" = "Nix";
      "kate/anonymous.katesession"."Document 1"."Highlighting Set By User" = false;
      "kate/anonymous.katesession"."Document 1"."Indentation Mode" = "normal";
      "kate/anonymous.katesession"."Document 1"."Mode" = "Nix";
      "kate/anonymous.katesession"."Document 1"."Mode Set By User" = false;
      "kate/anonymous.katesession"."Document 1"."URL" =
        "file:///home/stroby/nixos/configurations/kde.nix";
      "kate/anonymous.katesession"."Document 2"."Bookmarks" = "";
      "kate/anonymous.katesession"."Document 2"."Encoding" = "UTF-8";
      "kate/anonymous.katesession"."Document 2"."Highlighting" = "Nix";
      "kate/anonymous.katesession"."Document 2"."Highlighting Set By User" = false;
      "kate/anonymous.katesession"."Document 2"."Indentation Mode" = "normal";
      "kate/anonymous.katesession"."Document 2"."Mode" = "Nix";
      "kate/anonymous.katesession"."Document 2"."Mode Set By User" = false;
      "kate/anonymous.katesession"."Document 2"."URL" = "file:///home/stroby/nixos/home/fish.nix";
      "kate/anonymous.katesession"."Kate Plugins"."cmaketoolsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."compilerexplorer" = false;
      "kate/anonymous.katesession"."Kate Plugins"."eslintplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."externaltoolsplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."formatplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katebacktracebrowserplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katebuildplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katecloseexceptplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katecolorpickerplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katectagsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katefilebrowserplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katefiletreeplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."kategdbplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."kategitblameplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katekonsoleplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."kateprojectplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."katereplicodeplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katesearchplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."katesnippetsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katesqlplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katesymbolviewerplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katexmlcheckplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."katexmltoolsplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."keyboardmacrosplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."ktexteditorpreviewplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."latexcompletionplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."lspclientplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."openlinkplugin" = false;
      "kate/anonymous.katesession"."Kate Plugins"."rainbowparens" = false;
      "kate/anonymous.katesession"."Kate Plugins"."tabswitcherplugin" = true;
      "kate/anonymous.katesession"."Kate Plugins"."textfilterplugin" = true;
      "kate/anonymous.katesession"."MainWindow0"."2123x1416 screen: Window-Maximized" = true;
      "kate/anonymous.katesession"."MainWindow0"."Active ViewSpace" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-H-Splitter" = "340,1738,0";
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-0-Bar-0-TvList" =
        "kate_private_plugin_katefiletreeplugin,kateproject,kateprojectgit,lspclient_symbol_outline";
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-0-LastSize" = 340;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-0-SectSizes" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-0-Splitter" = 1242;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-1-Bar-0-TvList" = "";
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-1-LastSize" = 200;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-1-SectSizes" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-1-Splitter" = 1242;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-2-Bar-0-TvList" = "";
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-2-LastSize" = 200;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-2-SectSizes" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-2-Splitter" = 1738;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-3-Bar-0-TvList" =
        "output,diagnostics,kate_plugin_katesearch,kateprojectinfo,kate_private_plugin_katekonsoleplugin";
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-3-LastSize" = 269;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-3-SectSizes" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-3-Splitter" = 1831;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-Style" = 2;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-Sidebar-Visible" = true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-diagnostics-Position" = 3;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-diagnostics-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-diagnostics-Visible" = false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_plugin_katesearch-Position" = 3;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_plugin_katesearch-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_plugin_katesearch-Visible" =
        false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_private_plugin_katefiletreeplugin-Position" =
        0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_private_plugin_katefiletreeplugin-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_private_plugin_katefiletreeplugin-Visible" =
        false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_private_plugin_katekonsoleplugin-Position" =
        3;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_private_plugin_katekonsoleplugin-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kate_private_plugin_katekonsoleplugin-Visible" =
        false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateproject-Position" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateproject-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateproject-Visible" = true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateprojectgit-Position" = 0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateprojectgit-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateprojectgit-Visible" = false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateprojectinfo-Position" = 3;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateprojectinfo-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-kateprojectinfo-Visible" = false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-lspclient_symbol_outline-Position" =
        0;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-lspclient_symbol_outline-Show-Button-In-Sidebar" =
        true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-lspclient_symbol_outline-Visible" =
        false;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-output-Position" = 3;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-output-Show-Button-In-Sidebar" = true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-ToolView-output-Visible" = true;
      "kate/anonymous.katesession"."MainWindow0"."Kate-MDI-V-Splitter" = "0,972,269";
      "kate/anonymous.katesession"."MainWindow0"."ToolBarsMovable" = "Disabled";
      "kate/anonymous.katesession"."MainWindow0 Settings"."2123x1416 screen: Window-Maximized" = true;
      "kate/anonymous.katesession"."MainWindow0 Settings"."ToolBarsMovable" = "Disabled";
      "kate/anonymous.katesession"."MainWindow0 Settings"."WindowState" = 2;
      "kate/anonymous.katesession"."MainWindow0-Splitter 0"."Children" = "MainWindow0-ViewSpace 0";
      "kate/anonymous.katesession"."MainWindow0-Splitter 0"."Orientation" = 1;
      "kate/anonymous.katesession"."MainWindow0-Splitter 0"."Sizes" = 1738;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0"."Active View" = "";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0"."Count" = 1;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0"."Documents" = "\\0";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0"."View 0" =
        "file:///home/stroby/nixos/configurations/base.nix";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0"."View 1" =
        "file:///home/stroby/nixos/configurations/kde.nix";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0"."View 2" =
        "file:///home/stroby/nixos/home/fish.nix";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/base.nix"."CursorColumn" =
        23;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/base.nix"."CursorLine" =
        9;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/base.nix"."Dynamic Word Wrap" =
        true;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/base.nix"."JumpList" =
        "";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/base.nix"."TextFolding" =
        "{\"checksum\":\"445ab7b1062846ca52274624699dc326c3fe15f1\",\"ranges\":[]}";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/base.nix"."ViMarks" =
        "";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/kde.nix"."CursorColumn" =
        0;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/kde.nix"."CursorLine" =
        15;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/kde.nix"."Dynamic Word Wrap" =
        true;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/kde.nix"."JumpList" =
        "";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/kde.nix"."TextFolding" =
        "{\"checksum\":\"2edf663132aee28c6da29dde90ba9b160317fe8c\",\"ranges\":[]}";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/configurations\\/kde.nix"."ViMarks" =
        "";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/home\\/fish.nix"."CursorColumn" =
        0;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/home\\/fish.nix"."CursorLine" =
        0;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/home\\/fish.nix"."Dynamic Word Wrap" =
        true;
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/home\\/fish.nix"."JumpList" =
        "";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/home\\/fish.nix"."TextFolding" =
        "{\"checksum\":\"4f512c68266a81139ca76a3f6386e4dac3e78970\",\"ranges\":[]}";
      "kate/anonymous.katesession"."MainWindow0-ViewSpace 0 file:\\/\\/\\/home\\/stroby\\/nixos\\/home\\/fish.nix"."ViMarks" =
        "";
      "kate/anonymous.katesession"."Open Documents"."Count" = 1;
      "kate/anonymous.katesession"."Open MainWindows"."Count" = 1;
      "kate/anonymous.katesession"."Plugin:kateprojectplugin:"."projects" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."BinaryFiles" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."CurrentExcludeFilter" = 0;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."CurrentFilter" = 0;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."ExcludeFilters" = "\\0";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."ExpandSearchResults" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Filters" = "\\0";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."FollowSymLink" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."HiddenFiles" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."MatchCase" = false;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Place" = 1;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Recursive" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Replaces" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."Search" = "error";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeAllProjects" =
        true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeCurrentFile" =
        true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeFolder" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeOpenFiles" =
        true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchAsYouTypeProject" = true;
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchDiskFiles" = "";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."SearchDiskFiless" = "\\0";
      "kate/anonymous.katesession"."Plugin:katesearchplugin:MainWindow:0"."UseRegExp" = false;
    };
  };
}
