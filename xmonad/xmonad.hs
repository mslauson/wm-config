import Colors.Nord
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig
import XMonad.Util.Run

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "kitty" -- Sets default terminal

myBrowser :: String
myBrowser = "firefox-developer-edition" -- Sets qutebrowser as browser

myEditor :: String
myEditor = "nvim"

myBorderWidth :: Dimension
myBorderWidth = 2 -- Sets border width for windows

myNormColor :: String -- Border color of normal windows
myNormColor = colorBack -- This variable is imported from Colors.THEME

myFocusColor :: String -- Border color of focused windows
myFocusColor = color15 -- This variable is imported from Colors.THEME

mySoundPlayer :: String
mySoundPlayer = "ffplay -nodisp -autoexit " -- The program that will play system sounds

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
  spawnOnce (mySoundPlayer ++ startupSound)
  spawn "killall conky" -- kill current conky on each restart
  spawn "killall xmobar" -- adding this in case of switching between xmobar and polybar.
  spawn "killall trayer" -- adding this in case of switching between xmobar and polybar.
  spawnOnce "lxsession"
  spawnOnce "picom"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawnOnce "notify-log $HOME/.log/notify.log"
  spawn "/usr/bin/emacs --daemon" -- emacs daemon for the emacsclient
  spawn "polybar-xmonad"
  spawnOnce "sleep 2 && xmonad --restart"
  spawn ("sleep 3 && conky -c $HOME/.config/conky/xmonad/" ++ colorScheme ++ "-01.conkyrc")

  -- spawnOnce "xargs xwallpaper --stretch < ~/.cache/wall"
  -- spawnOnce "~/.fehbg &" -- set last saved feh wallpaper
  -- spawnOnce "feh --randomize --bg-fill /usr/share/backgrounds/dtos-backgrounds/*"  -- feh set random wallpaper
  -- spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
  setWMName "LG3D"

myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
  where
    navKeyMap =
      M.fromList
        [ ((0, xK_Escape), cancel),
          ((0, xK_Return), select),
          ((0, xK_slash), substringSearch myNavigation),
          ((0, xK_Left), move (-1, 0) >> myNavigation),
          ((0, xK_h), move (-1, 0) >> myNavigation),
          ((0, xK_Right), move (1, 0) >> myNavigation),
          ((0, xK_l), move (1, 0) >> myNavigation),
          ((0, xK_Down), move (0, 1) >> myNavigation),
          ((0, xK_j), move (0, 1) >> myNavigation),
          ((0, xK_Up), move (0, -1) >> myNavigation),
          ((0, xK_k), move (0, -1) >> myNavigation),
          ((0, xK_y), move (-1, -1) >> myNavigation),
          ((0, xK_i), move (1, -1) >> myNavigation),
          ((0, xK_n), move (-1, 1) >> myNavigation),
          ((0, xK_m), move (1, -1) >> myNavigation),
          ((0, xK_space), setPos (0, 0) >> myNavigation)
        ]
    navDefaultHandler = const myNavigation

myColorizer :: Window -> Bool -> X (String, String)
myColorizer =
  colorRangeFromClassName
    (0x28, 0x2c, 0x34) -- lowest inactive bg
    (0x28, 0x2c, 0x34) -- highest inactive bg
    (0xc7, 0x92, 0xea) -- active bg
    (0xc0, 0xa7, 0x9a) -- inactive fg
    (0x28, 0x2c, 0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer =
  (buildDefaultGSConfig myColorizer)
    { gs_cellheight = 40,
      gs_cellwidth = 200,
      gs_cellpadding = 6,
      gs_navigate = myNavigation,
      gs_originFractX = 0.5,
      gs_originFractY = 0.5,
      gs_font = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
  where
    conf =
      def
        { gs_cellheight = 40,
          gs_cellwidth = 180,
          gs_cellpadding = 6,
          gs_originFractX = 0.5,
          gs_originFractY = 0.5,
          gs_font = myFont
        }

runSelectedAction' :: GSConfig (X ()) -> [(String, X ())] -> X ()
runSelectedAction' conf actions = do
  selectedActionM <- gridselect conf actions
  case selectedActionM of
    Just selectedAction -> selectedAction
    Nothing -> return ()


lh = avoidStruts $
  spacing 10 $
 gaps [(U, 10), (D, 10), (L, 10), (R, 10)] $
 smartBorders $
 layoutHook defaultConfig ||| tabbed shrinkText
--  ws-icon-0 = 1;%{F#d8dee9}
-- ws-icon-1 = 2;%{F#EBCB8B}
-- ws-icon-2 = 3;%{F#BF616A}
-- ws-icon-3 = 4;%{F#A3BE8C}󰵅
-- ws-icon-4 = 5;%{F#7CB6F5}
-- ws-icon-5 = 6;%{F#88C0D0}
-- ws-icon-6 = 7;%{F#c394b4}
-- ws-icon-7 = 8;%{F#967bb6}        

workspaceNames =
  [ "",
    "",
    "",
    "󰵅",
    "",
    "",
    "",
    "",
    "♟"
  ]

  gsCategories =
  [ ("Games", "xdotool key super+alt+1"),
    ("Education", "xdotool key super+alt+2"),
    ("Internet", "xdotool key super+alt+3"),
    ("Multimedia", "xdotool key super+alt+4"),
    ("Office", "xdotool key super+alt+5"),
    ("Settings", "xdotool key super+alt+6"),
    ("System", "xdotool key super+alt+7"),
    ("Utilities", "xdotool key super+alt+8")
  ]

gsGames =
  [ 
    ("Steam", "steam"),
  ]

gsEducation =
  [ 
  ]

gsInternet =
 [ 
    ("Discord", "discord"),
    ("Firefox", "firefox"),
    ("Firefox Developer Edition", "firefox-developer-edition"),
    ("Zoom", "zoom")
    ("Signal", "signal")
  ]

gsMultimedia =
  [
    ("VLC", "vlc")
  ]

gsOffice =
  [ ("Document Viewer", "evince"),
    ("LibreOffice", "libreoffice"),
    ("LO Base", "lobase"),
    ("LO Calc", "localc"),
    ("LO Draw", "lodraw"),
    ("LO Impress", "loimpress"),
    ("LO Math", "lomath"),
    ("LO Writer", "lowriter")
  ]

gsSettings =
  [ ("ARandR", "arandr"),
    ("Customize Look and Feel", "lxappearance"),
    ("Firewall Configuration", "sudo gufw")
  ]

gsSystem =
  [ ("Alacritty", "alacritty"),
    ("Kitty", "kitty"),
    ("Bash", (myTerminal ++ " -e bash")),
    ("Htop", (myTerminal ++ " -e htop")),
    ("VirtualBox", "virtualbox"),
    ("Virt-Manager", "virt-manager"),
  ]

gsUtilities =
  [ ("Nitrogen", "nitrogen"),
    ("NeoVim", (myTerminal ++ " -e nvim"))
  ]



main :: IO ()
main =
  do
    xmonad $
      defaultConfig
        { terminal = "kitty",
          modMask = mod4Mask,
          borderWidth = 1,
          layoutHook = lh,
          manageHook =
            composeAll
              [ className =? "insomnia" --> doShift "1",
                className =? "Thunar" --> doShift "3",
                className =? "bitwarden" --> doShift "3",
                className =? "thunderbird" --> doShift "4",
                className =? "Signal" --> doShift "4",
                className =? "discord" --> doShift "4",
                className =? "zoom" --> doShift "4",
                className =? "Steam" --> doShift "5",
                className =? "net-runelite-client-RuneLite" --> doShift "5"
                -- Add more rules here...
              ],
          startupHook = do
            spawn "xbacklight -set 50"
        }
        `additionalKeysP` [ ("M-S-r", spawn "xmonad --recompile; xmonad --restart"),
                            ("M-q", kill),
                            ("M-<Return>", spawn "kitty")
                              ("M-w", spawn "firefox-developer-edition")
                              ("M-n", spawn "thunar")
                          ]

-- \^++^ subKeys
--   "Dmenu scripts"
--   [ ("M-p h", addName "List all dmscripts" $ spawn "dm-hub"),
--     ("M-p a", addName "Choose ambient sound" $ spawn "dm-sounds"),
--     ("M-p b", addName "Set background" $ spawn "dm-setbg"),
--     ("M-p c", addName "Choose color scheme" $ spawn "~/.local/bin/dtos-colorscheme"),
--     ("M-p C", addName "Pick color from scheme" $ spawn "dm-colpick"),
--     ("M-p e", addName "Edit config files" $ spawn "dm-confedit"),
--     ("M-p i", addName "Take a screenshot" $ spawn "dm-maim"),
--     ("M-p k", addName "Kill processes" $ spawn "dm-kill"),
--     ("M-p m", addName "View manpages" $ spawn "dm-man"),
--     ("M-p n", addName "Store and copy notes" $ spawn "dm-note"),
--     ("M-p o", addName "Browser bookmarks" $ spawn "dm-bookman"),
--     ("M-p p", addName "Passmenu" $ spawn "passmenu -p \"Pass: \""),
--     ("M-p q", addName "Logout Menu" $ spawn "dm-logout"),
--     ("M-p r", addName "Listen to online radio" $ spawn "dm-radio"),
--     ("M-p s", addName "Search various engines" $ spawn "dm-websearch"),
--     ("M-p t", addName "Translate text" $ spawn "dm-translate")
--   ]
-- \^++^ subKeys
--   "Favorite programs"
--   [ ("M-<Return>", addName "Launch terminal" $ spawn (myTerminal)),
--     ("M-b", addName "Launch web browser" $ spawn (myBrowser)),
--     ("M-M1-h", addName "Launch htop" $ spawn (myTerminal ++ " -e htop"))
--   ]
-- \^++^ subKeys
--   "Monitors"
--   [ ("M-.", addName "Switch focus to next monitor" $ nextScreen),
--     ("M-,", addName "Switch focus to prev monitor" $ prevScreen)
--   ]
-- -- Switch layouts
-- \^++^ subKeys
--   "Switch layouts"
--   [ ("M-<Tab>", addName "Switch to next layout" $ sendMessage NextLayout),
--     ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
--   ]
-- -- Window resizing
-- \^++^ subKeys
--   "Window resizing"
--   [ ("M-h", addName "Shrink window" $ sendMessage Shrink),
--     ("M-l", addName "Expand window" $ sendMessage Expand),
--     ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink),
--     ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)
--   ]
-- -- Floating windows
-- \^++^ subKeys
--   "Floating windows"
--   [ ("M-f", addName "Toggle float layout" $ sendMessage (T.Toggle "floats")),
--     ("M-t", addName "Sink a floating window" $ withFocused $ windows . W.sink),
--     ("M-S-t", addName "Sink all floated windows" $ sinkAll)
--   ]
-- -- Increase/decrease spacing (gaps)
-- \^++^ subKeys
--   "Window spacing (gaps)"
--   [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4),
--     ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4),
--     ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4),
--     ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)
--   ]
-- -- Increase/decrease windows in the master pane or the stack
-- \^++^ subKeys
--   "Increase/decrease windows in master pane or the stack"
--   [ ("M-S-<Up>", addName "Increase clients in master pane" $ sendMessage (IncMasterN 1)),
--     ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1))),
--     ("M-=", addName "Increase max # of windows for layout" $ increaseLimit),
--     ("M--", addName "Decrease max # of windows for layout" $ decreaseLimit)
--   ]
-- -- Sublayouts
-- -- This is used to push windows to tabbed sublayouts, or pull them out of it.
-- \^++^ subKeys
--   "Sublayouts"
--   [ ("M-C-h", addName "pullGroup L" $ sendMessage $ pullGroup L),
--     ("M-C-l", addName "pullGroup R" $ sendMessage $ pullGroup R),
--     ("M-C-k", addName "pullGroup U" $ sendMessage $ pullGroup U),
--     ("M-C-j", addName "pullGroup D" $ sendMessage $ pullGroup D),
--     ("M-C-m", addName "MergeAll" $ withFocused (sendMessage . MergeAll)),
--     -- , ("M-C-u", addName "UnMerge"               $ withFocused (sendMessage . UnMerge))
--     ("M-C-/", addName "UnMergeAll" $ withFocused (sendMessage . UnMergeAll)),
--     ("M-C-.", addName "Switch focus next tab" $ onGroup W.focusUp'),
--     ("M-C-,", addName "Switch focus prev tab" $ onGroup W.focusDown')
--   ]
-- \^++^ subKeys
--   "Multimedia keys"
--   [ ("<XF86AudioPlay>", addName "mocp play" $ spawn "mocp --play"),
--     ("<XF86AudioPrev>", addName "mocp next" $ spawn "mocp --previous"),
--     ("<XF86AudioNext>", addName "mocp prev" $ spawn "mocp --next"),
--     ("<XF86AudioMute>", addName "Toggle audio mute" $ spawn "amixer set Master toggle"),
--     ("<XF86AudioLowerVolume>", addName "Lower vol" $ spawn "amixer set Master 5%- unmute"),
--     ("<XF86AudioRaiseVolume>", addName "Raise vol" $ spawn "amixer set Master 5%+ unmute"),
--     ("<XF86HomePage>", addName "Open home page" $ spawn (myBrowser ++ " https://www.youtube.com/c/DistroTube")),
--     ("<XF86Search>", addName "Web search (dmscripts)" $ spawn "dm-websearch"),
--     ("<XF86Mail>", addName "Email client" $ runOrRaise "thunderbird" (resource =? "thunderbird")),
--     ("<XF86Calculator>", addName "Calculator" $ runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk")),
--     ("<XF86Eject>", addName "Eject /dev/cdrom" $ spawn "eject /dev/cdrom"),
--     ("<Print>", addName "Take screenshot (dmscripts)" $ spawn "dm-maim")
--   ]
