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

main =
  do
    xmonad $
      defaultConfig
        { terminal = "kitty",
          modMask = mod4Mask,
          borderWidth = 1,
          layoutHook = avoidStruts $ spacing 10 $ gaps [(U, 10), (D, 10), (L, 10), (R, 10)] $ smartBorders $ layoutHook defaultConfig ||| tabbed shrinkText defaultTheme,
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
    ^++^ subKeys
      "Dmenu scripts"
      [ ("M-p h", addName "List all dmscripts" $ spawn "dm-hub"),
        ("M-p a", addName "Choose ambient sound" $ spawn "dm-sounds"),
        ("M-p b", addName "Set background" $ spawn "dm-setbg"),
        ("M-p c", addName "Choose color scheme" $ spawn "~/.local/bin/dtos-colorscheme"),
        ("M-p C", addName "Pick color from scheme" $ spawn "dm-colpick"),
        ("M-p e", addName "Edit config files" $ spawn "dm-confedit"),
        ("M-p i", addName "Take a screenshot" $ spawn "dm-maim"),
        ("M-p k", addName "Kill processes" $ spawn "dm-kill"),
        ("M-p m", addName "View manpages" $ spawn "dm-man"),
        ("M-p n", addName "Store and copy notes" $ spawn "dm-note"),
        ("M-p o", addName "Browser bookmarks" $ spawn "dm-bookman"),
        ("M-p p", addName "Passmenu" $ spawn "passmenu -p \"Pass: \""),
        ("M-p q", addName "Logout Menu" $ spawn "dm-logout"),
        ("M-p r", addName "Listen to online radio" $ spawn "dm-radio"),
        ("M-p s", addName "Search various engines" $ spawn "dm-websearch"),
        ("M-p t", addName "Translate text" $ spawn "dm-translate")
      ]
    ^++^ subKeys
      "Favorite programs"
      [ ("M-<Return>", addName "Launch terminal" $ spawn (myTerminal)),
        ("M-b", addName "Launch web browser" $ spawn (myBrowser)),
        ("M-M1-h", addName "Launch htop" $ spawn (myTerminal ++ " -e htop"))
      ]
    ^++^ subKeys
      "Monitors"
      [ ("M-.", addName "Switch focus to next monitor" $ nextScreen),
        ("M-,", addName "Switch focus to prev monitor" $ prevScreen)
      ]
    -- Switch layouts
    ^++^ subKeys
      "Switch layouts"
      [ ("M-<Tab>", addName "Switch to next layout" $ sendMessage NextLayout),
        ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
      ]
    -- Window resizing
    ^++^ subKeys
      "Window resizing"
      [ ("M-h", addName "Shrink window" $ sendMessage Shrink),
        ("M-l", addName "Expand window" $ sendMessage Expand),
        ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink),
        ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)
      ]
    -- Floating windows
    ^++^ subKeys
      "Floating windows"
      [ ("M-f", addName "Toggle float layout" $ sendMessage (T.Toggle "floats")),
        ("M-t", addName "Sink a floating window" $ withFocused $ windows . W.sink),
        ("M-S-t", addName "Sink all floated windows" $ sinkAll)
      ]
    -- Increase/decrease spacing (gaps)
    ^++^ subKeys
      "Window spacing (gaps)"
      [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4),
        ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4),
        ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4),
        ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)
      ]
    -- Increase/decrease windows in the master pane or the stack
    ^++^ subKeys
      "Increase/decrease windows in master pane or the stack"
      [ ("M-S-<Up>", addName "Increase clients in master pane" $ sendMessage (IncMasterN 1)),
        ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1))),
        ("M-=", addName "Increase max # of windows for layout" $ increaseLimit),
        ("M--", addName "Decrease max # of windows for layout" $ decreaseLimit)
      ]
    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
    ^++^ subKeys
      "Sublayouts"
      [ ("M-C-h", addName "pullGroup L" $ sendMessage $ pullGroup L),
        ("M-C-l", addName "pullGroup R" $ sendMessage $ pullGroup R),
        ("M-C-k", addName "pullGroup U" $ sendMessage $ pullGroup U),
        ("M-C-j", addName "pullGroup D" $ sendMessage $ pullGroup D),
        ("M-C-m", addName "MergeAll" $ withFocused (sendMessage . MergeAll)),
        -- , ("M-C-u", addName "UnMerge"               $ withFocused (sendMessage . UnMerge))
        ("M-C-/", addName "UnMergeAll" $ withFocused (sendMessage . UnMergeAll)),
        ("M-C-.", addName "Switch focus next tab" $ onGroup W.focusUp'),
        ("M-C-,", addName "Switch focus prev tab" $ onGroup W.focusDown')
      ]
    ^++^ subKeys
      "Multimedia keys"
      [ ("<XF86AudioPlay>", addName "mocp play" $ spawn "mocp --play"),
        ("<XF86AudioPrev>", addName "mocp next" $ spawn "mocp --previous"),
        ("<XF86AudioNext>", addName "mocp prev" $ spawn "mocp --next"),
        ("<XF86AudioMute>", addName "Toggle audio mute" $ spawn "amixer set Master toggle"),
        ("<XF86AudioLowerVolume>", addName "Lower vol" $ spawn "amixer set Master 5%- unmute"),
        ("<XF86AudioRaiseVolume>", addName "Raise vol" $ spawn "amixer set Master 5%+ unmute"),
        ("<XF86HomePage>", addName "Open home page" $ spawn (myBrowser ++ " https://www.youtube.com/c/DistroTube")),
        ("<XF86Search>", addName "Web search (dmscripts)" $ spawn "dm-websearch"),
        ("<XF86Mail>", addName "Email client" $ runOrRaise "thunderbird" (resource =? "thunderbird")),
        ("<XF86Calculator>", addName "Calculator" $ runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk")),
        ("<XF86Eject>", addName "Eject /dev/cdrom" $ spawn "eject /dev/cdrom"),
        ("<Print>", addName "Take screenshot (dmscripts)" $ spawn "dm-maim")
      ]
