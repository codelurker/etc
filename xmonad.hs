import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.HintedTile
import XMonad.Layout.NoBorders
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Ssh
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
                        , ppTitle = xmobarColor "darkcyan" "" . shorten 50
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
        , ((mod4Mask, xK_s), sshPrompt myXPConfig)
        , ((mod4Mask, xK_e), runOrRaise "emacs" (className =? "Emacs"))
        , ((mod4Mask, xK_f), runOrRaise "firefox" (className =? "Firefox"))
        , ((mod4Mask, xK_r), runOrRaisePrompt myXPConfig)
        , ((mod4Mask, xK_g), windowPromptGoto myXPConfig)
        , ((mod4Mask, xK_b), windowPromptBring myXPConfig)
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

myLayouts = avoidStruts $ smartBorders $
            tabbed shrinkText myTabConfig ||| Full ||| hintedTile XMonad.Layout.HintedTile.Tall ||| hintedTile Wide ||| Accordion 
  where
    hintedTile = HintedTile nmaster delta ratio TopLeft
    nmaster    = 1
    delta      = 3/100
    ratio      = 1/2

myXPConfig = defaultXPConfig { font = "xft:Inconsolata-8" }

myTabConfig = defaultTheme { fontName = "xft:Inconsolata-8", decoHeight = 14 }