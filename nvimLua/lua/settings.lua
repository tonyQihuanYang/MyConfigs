vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.autoindent = true
opt.tabstop= 2
opt.shiftwidth= 2
opt.smarttab = true
opt.softtabstop= 2
opt.mouse= "a"
opt.hidden = true
-- Allow the use the system clipboard
opt.clipboard = "unnamedplus"