import XMonad
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ResizableTile
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
         mouseBindings = myMouseBindings,
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

	       -- Resizable tile bindings
	       ++
  	       [((modMask, xK_x), sendMessage MirrorExpand),
	        ((modMask, xK_c), sendMessage MirrorShrink)] 	
       
myLayout = tabbed shrinkText myTabConfig ||| ResizableTall nmaster delta ratio [] ||| Mirror tiled ||| Full
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

button6     =  6 :: Button
button7     =  7 :: Button

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    -- cycle focus
    , ((modMask, button4), (\_ -> windows W.focusUp))
    , ((modMask, button5), (\_ -> windows W.focusDown))
    -- cycle through workspaces
    , ((0, button6), prevNonEmptyWS)
    , ((0, button7), nextNonEmptyWS)
    ]
    where 
      nextNonEmptyWS = \_ -> moveTo Next NonEmptyWS
      prevNonEmptyWS = \_ -> moveTo Prev NonEmptyWS



