let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.dotfiles/awesome/dot-config/awesome
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +107 ~/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/habit_tracker.lua
badd +8 ~/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/ui.lua
badd +12 ~/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/habits.json
badd +52 ~/.dotfiles/awesome/dot-config/awesome/themes/neon/theme.lua
badd +27 ~/.dotfiles/awesome/dot-config/awesome/rc.lua
badd +54 ~/.dotfiles/awesome/dot-config/awesome/modules/network/network-widget.lua
badd +15 ~/.dotfiles/awesome/dot-config/awesome/modules/network/get_network_status.sh
badd +55 ~/.dotfiles/awesome/dot-config/awesome/modules/todo/todo_panel.lua
badd +13 ~/.dotfiles/awesome/dot-config/awesome/modules/productivity_center/productivity_panel.lua
badd +72 ~/.dotfiles/awesome/dot-config/awesome/modules/core/topbar.lua
badd +97 ~/.dotfiles/awesome/dot-config/awesome/modules/todo/task.lua
badd +58 ~/.dotfiles/awesome/dot-config/awesome/modules/core/taglist.lua
badd +32 ~/.config/nvim/lua/config/plugins/mini-base16.lua
badd +14 ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua
badd +21 health://
argglobal
%argdel
edit ~/.dotfiles/awesome/dot-config/awesome/modules/productivity_center/productivity_panel.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 117 + 118) / 236)
exe 'vert 2resize ' . ((&columns * 118 + 118) / 236)
argglobal
balt ~/.dotfiles/awesome/dot-config/awesome/modules/network/network-widget.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 26) / 52)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua", ":p")) | buffer ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua | else | edit ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua | endif
if &buftype ==# 'terminal'
  silent file ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua
endif
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 14 - ((13 * winheight(0) + 26) / 52)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 14
normal! 03|
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 117 + 118) / 236)
exe 'vert 2resize ' . ((&columns * 118 + 118) / 236)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
