import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import XMonad.Actions.GridSelect
import XMonad.Actions.PhysicalScreens
import XMonad.Config.Gnome
import XMonad.Config.Desktop(desktopLayoutModifiers)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.HintedTile
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.ToggleLayouts
import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Prompt.RunOrRaise
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import System.IO
import Data.Ratio ((%))

main = do
    xmonad $ gnomeConfig
	{ manageHook = myManageHook <+> manageDocks <+> manageHook gnomeConfig
        , layoutHook = desktopLayoutModifiers (myLayouts)
        , modMask = mod4Mask
        , terminal = "xterm -e zsh"
        , borderWidth = 1
        , normalBorderColor = "black"
        , focusedBorderColor = "orange"
        } `additionalKeys` myKeys
        
myKeys =
        -- Program launching
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "gnome-screensaver-command --lock")
        , ((mod4Mask, xK_s), spawn "/home/mburrows/scripts/sshmenu")
        , ((mod4Mask, xK_e), runOrRaise "emacs" (className =? "Emacs"))
        , ((mod4Mask, xK_w), runOrRaise "google-chrome" (className =? "Google-chrome"))
        , ((mod4Mask, xK_v), runOrRaise "vlc" (className =? "Vlc"))
        , ((mod4Mask, xK_y), runOrRaise "vmplayer" (className =? "Vmplayer"))
        , ((mod4Mask, xK_m), runOrRaise "thunderbird" (className =? "Thunderbird"))
        , ((mod4Mask, xK_n), runOrRaise "liferea" (className =? "Liferea"))
        , ((mod4Mask, xK_r), runOrRaisePrompt myXPConfig)
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
        , ((mod4Mask, xK_g), goToSelected defaultGSConfig)
        , ((mod4Mask, xK_b), windowPromptBring myXPConfig)
        , ((mod4Mask .|. controlMask, xK_space), sendMessage ToggleLayout)
        ]
        -- Map screen switching onto F1..F4 
        ++
        [((mod4Mask .|. mask, key), f sc)
             | (key, sc) <- zip [xK_F1, xK_F2, xK_F3, xK_F4] [0..]
             , (f, mask) <- [(viewScreen, 0), (sendToScreen, shiftMask)]]

myLayouts = toggle $ avoidStruts $ smartBorders $
            hintedTile Wide 
            ||| hintedTile XMonad.Layout.HintedTile.Tall 
            ||| Full 
            ||| simpleTabbed 
            ||| Accordion 
            ||| Grid 
            ||| myBatsVolumeLayout
  where
    hintedTile = HintedTile nmaster delta ratio TopLeft
    nmaster    = 1
    delta      = 3/100
    ratio      = 1/2
    toggle     = toggleLayouts (noBorders Full) -- allows toggling to fullscreen view

myXPConfig = defaultXPConfig { font = "xft:Inconsolata-10" }

myTabConfig = defaultTheme { fontName = "xft:Inconsolata-10", decoHeight = 14 }

myManageHook = composeAll [ className =? "Dia" --> doFloat ]

-- Custom layout for the BATS Volume Summary dashboard widget + large web browser
myBatsVolumeLayout = withIM size volumeSummary Grid
    where 
      -- Ratio of screen volume summary will occupy
      size = 1%5
      -- Match volume summary 
      volumeSummary = Title "Volume - Google Chrome"
