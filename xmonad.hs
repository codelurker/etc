import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed
import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map as M

main = do
  xmproc <- spawnPipe "/home/mburrows/.cabal/bin/xmobar /home/mburrows/.xmobarrc"
  xmonad $ defaultConfig {
         terminal    = "urxvt",
         numlockMask = 0,
         modMask     = mod4Mask,
         manageHook  = manageDocks <+> manageHook defaultConfig,
         layoutHook  = avoidStruts $ myLayout,
         logHook     = dynamicLogWithPP $ xmobarPP { 
                         ppOutput = hPutStrLn xmproc,
                         ppTitle = xmobarColor "green" "" . shorten 50
                       },
         keys        =  \c -> myKeys c `M.union` keys defaultConfig c
         } where 
             myKeys conf@(XConfig {XMonad.modMask = modMask, workspaces = ws}) = M.fromList $
               -- Program launching
               [((modMask, xK_s), spawn "sshmenu")]

               -- Cycle workspaces setup
               ++
               [((modMask,               xK_Down),  nextWS),
                ((modMask,               xK_Up),    prevWS),
                ((modMask .|. shiftMask, xK_Down),  shiftToNext),
                ((modMask .|. shiftMask, xK_Up),    shiftToPrev),
                ((modMask,               xK_z),     toggleWS),
                ((modMask,               xK_f),     moveTo Next EmptyWS),
                ((modMask .|. shiftMask, xK_f),     shiftTo Next EmptyWS)]
       
myLayout = tabbed shrinkText myTabConfig ||| tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
myTabConfig = defaultTheme { decoHeight = 14 }
