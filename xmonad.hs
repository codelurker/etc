import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
	{ manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = myLayouts
	, logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask
        , terminal = "gnome-terminal"
        , borderWidth = 2
        , normalBorderColor = "black"
        , focusedBorderColor = "orange"
        } `additionalKeys` myKeys
        
myKeys =
        -- Program launching
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "gnome-screensaver-command --lock")
        , ((mod4Mask, xK_s), spawn "/home/mburrows/scripts/sshmenu")
        , ((mod4Mask, xK_f), spawn "firefox")
        ]
        -- Cycle workspaces setup
        ++
        [ ((mod4Mask, xK_Down), nextWS)
        , ((mod4Mask, xK_Up), prevWS)
        , ((mod4Mask .|. shiftMask, xK_Down), shiftToNext)
        , ((mod4Mask .|. shiftMask, xK_Up), shiftToPrev)
        , ((mod4Mask, xK_Right), nextScreen)
        , ((mod4Mask, xK_Left), prevScreen)
        , ((mod4Mask .|. shiftMask, xK_Right), shiftNextScreen)
        , ((mod4Mask .|. shiftMask, xK_Left), shiftPrevScreen)
        , ((mod4Mask, xK_z), toggleWS)
        , ((mod4Mask, xK_o), moveTo Next EmptyWS)
        , ((mod4Mask .|. shiftMask, xK_o), shiftTo Next EmptyWS)
        ]
        -- Map screen switching onto F1..F4 
        ++
        [((m .|. mod4Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
              | (key, sc) <- zip [xK_F1, xK_F2, xK_F3, xK_F4] [0..]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myLayouts = avoidStruts $ 
            tiled ||| Mirror tiled ||| simpleTabbed ||| Accordion ||| Full
  where
    tiled = Tall 1 (3/100) (1/2)