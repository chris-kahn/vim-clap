" Author: Jesse Cooke <clap@relativepath.io>
" Description: Clap theme based on the Solarized Light theme.

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:base03  = { 'hex': '#282828', 'xterm': '235' }
let s:base02  = { 'hex': '#3c3836', 'xterm': '235' }
let s:base01  = { 'hex': '#504945', 'xterm': '240' }
let s:base00  = { 'hex': '#7c6f64', 'xterm': '241' }
let s:base0   = { 'hex': '#bdae93', 'xterm': '248' }
let s:base1   = { 'hex': '#d5c4a1', 'xterm': '250' }
let s:base2   = { 'hex': '#ebdbb2', 'xterm': '223' }
let s:base3   = { 'hex': '#fbf1c7', 'xterm': '229' }
let s:yellow  = { 'hex': '#d79921', 'xterm': '136' }
let s:orange  = { 'hex': '#d65d0e', 'xterm': '166' }
let s:red     = { 'hex': '#cc241d', 'xterm': '160' }
let s:magenta = { 'hex': '#b16286', 'xterm': '125' }
let s:violet  = { 'hex': '#b16286', 'xterm':  '61' }
let s:blue    = { 'hex': '#458588', 'xterm':  '33' }
let s:cyan    = { 'hex': '#689d6a', 'xterm':  '37' }
let s:green   = { 'hex': '#98971a', 'xterm':  '64' }

let s:palette = {}

let s:palette.display = {
  \'ctermbg': s:base3.xterm,
  \'guibg':   s:base3.hex,
  \'ctermfg': s:base03.xterm,
  \'guifg':   s:base03.hex,
\}

" Let ClapInput, ClapSpinner and ClapSearchText use the same backgound.
let s:bg0 = {
  \'guibg': s:base2.hex,
  \'ctermbg': s:base2.xterm,
\}
let s:palette.input = s:bg0
let s:palette.spinner = extend({
  \'guifg': s:base01.hex,
  \'ctermfg': s:base01.xterm,
  \'cterm': 'bold',
  \'gui': 'bold',
\}, s:bg0)


let s:palette.preview = s:bg0

let s:selected = {
  \'guifg': s:base02.hex,
  \'ctermfg': s:base02.xterm,
  \'cterm': 'bold',
  \'gui': 'bold',
\}
let s:palette.search_text = extend(s:selected, s:bg0)
let s:palette.selected = s:selected
let s:palette.selected_sign = s:selected

let s:palette.current_selection = {
  \'guibg': s:base2.hex,
  \'ctermbg': s:base2.xterm,
  \'guifg': s:base02.hex,
  \'ctermfg': s:base02.xterm,
  \'cterm': 'bold',
  \'gui': 'bold',
\}

let s:palette.current_selection_sign = extend({
  \'guifg': s:red.hex,
  \'ctermfg': s:red.xterm,
\}, s:palette.current_selection)

let s:fuzzy = [
  \ [s:base03.xterm, s:base03.hex],
  \ [s:base02.xterm, s:base02.hex],
  \ [s:base01.xterm, s:base01.hex],
  \ [s:base00.xterm, s:base00.hex],
  \ [s:base0.xterm, s:base0.hex],
  \ [s:base1.xterm, s:base1.hex],
\ ]
let g:clap_fuzzy_match_hl_groups = s:fuzzy

let g:clap#themes#gruvbox_light#palette = s:palette

let &cpoptions = s:save_cpo
unlet s:save_cpo
