import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
	{ manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
	, logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask
        , terminal = "urxvt"
        , borderWidth = 2
        , normalBorderColor = "black"
        , focusedBorderColor = "orange"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock")
        , ((mod4Mask, xK_s), spawn "/home/mburrows/scripts/sshmenu")
        , ((mod4Mask, xK_f), spawn "firefox")
        , ((mod4Mask, xK_Down), nextWS)
        , ((mod4Mask, xK_Up), prevWS)
        , ((mod4Mask .|. shiftMask, xK_Down), shiftToNext)
        , ((mod4Mask .|. shiftMask, xK_Up), shiftToPrev)
        , ((mod4Mask, xK_Right), nextScreen)
        , ((mod4Mask, xK_Left), prevScreen)
        , ((mod4Mask .|. shiftMask, xK_Right), shiftNextScreen)
        , ((mod4Mask .|. shiftMask, xK_Left), shiftPrevScreen)
        , ((mod4Mask, xK_z), toggleWS)
        , ((mod4Mask, xK_e), moveTo Next EmptyWS)
        , ((mod4Mask .|. shiftMask, xK_e), shiftTo Next EmptyWS)
        ]
