-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = {
  
  -- This is where you actually apply your config choices
  
  -- For example, changing the color scheme:
  font_size = 16.0,
  font = wezterm.font 'Cica',
  window_background_opacity = 0.8,
  keys = {
    { key = "-", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
    { key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },
  },
}

-- and finally, return the configuration to wezterm
return config

