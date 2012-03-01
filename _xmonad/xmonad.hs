import XMonad
import XMonad.Util.EZConfig
import XMonad.Config.Gnome
import XMonad.Layout.Gaps
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.CopyWindow
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Minimize
import XMonad.Layout.ToggleLayouts
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.RestoreMinimized
import XMonad.Hooks.EwmhDesktops

myWorkspaces    = ["1","2","3","4"]

myFocusedBorderColor = "1C397B"

basicLayout = desktopLayoutModifiers (mouseResizableTile ||| minimize (Tall 1 (3/100) (1/2)) ||| Tall 1 0.03 0.5 )
myLayout = toggleLayouts(Full) basicLayout
modm = mod4Mask

myManageHook = composeAll
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
---    , className =? "Unity-2d-panel" --> (ask >>= doF .  \w -> (\ws -> foldr ($) ws (copyToWss ["2", "3", "4"] w) ) ) :: ManageHook
    , className =? "Unity-2d-launcher" --> (ask >>= doF .  \w -> (\ws -> foldr ($) ws (copyToWss ["2", "3", "4"] w) ) ) :: ManageHook
    , manageDocks
    , isFullscreen --> doFullFloat
    ]
    where copyToWss ids win = map (copyWindow win) ids -- TODO: find method that only calls windows once

myKeys=
   [
     ((modm,               xK_Right),  nextWS)
   , ((modm,               xK_Left),    prevWS)
   , ((modm .|. shiftMask, xK_Down),  shiftToNext)
   , ((modm .|. shiftMask, xK_Up),    shiftToPrev)
   , ((modm,               xK_Up), rotFocusedUp)
   , ((modm,               xK_Down),  rotFocusedDown)
   , ((modm .|. shiftMask, xK_Right), shiftNextScreen)
   , ((modm .|. shiftMask, xK_Left),  shiftPrevScreen)
   , ((modm,               xK_z),     toggleWS)
   , ((modm,                 xK_f    ), sendMessage ToggleLayout)
   ]

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
     where fadeAmount = 0.8

main = xmonad $ gnomeConfig 
	{ 
	  manageHook = myManageHook
        , logHook = ewmhDesktopsLogHook
	, modMask = mod4Mask -- set the mod key to the windows key
        , layoutHook = smartBorders (myLayout)
	, workspaces = myWorkspaces
    	, focusedBorderColor = myFocusedBorderColor
    	, normalBorderColor = myFocusedBorderColor
	} `additionalKeys` myKeys
