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
badd +10 ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/redshift_control_button.lua
badd +18 ~/.dotfiles/awesome/dot-config/awesome/modules/utils/test_box.lua
badd +26 ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua
argglobal
%argdel
edit ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/redshift_control_button.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
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
exe '1resize ' . ((&lines * 26 + 27) / 54)
exe 'vert 1resize ' . ((&columns * 117 + 118) / 236)
exe '2resize ' . ((&lines * 25 + 27) / 54)
exe 'vert 2resize ' . ((&columns * 117 + 118) / 236)
exe 'vert 3resize ' . ((&columns * 118 + 118) / 236)
argglobal
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
let s:l = 13 - ((6 * winheight(0) + 13) / 26)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 13
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua", ":p")) | buffer ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua | else | edit ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua | endif
if &buftype ==# 'terminal'
  silent file ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/control_button.lua
endif
balt ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/redshift_control_button.lua
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
let s:l = 61 - ((-1 * winheight(0) + 12) / 25)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 61
normal! 056|
wincmd w
argglobal
if bufexists(fnamemodify("~/.dotfiles/awesome/dot-config/awesome/modules/utils/test_box.lua", ":p")) | buffer ~/.dotfiles/awesome/dot-config/awesome/modules/utils/test_box.lua | else | edit ~/.dotfiles/awesome/dot-config/awesome/modules/utils/test_box.lua | endif
if &buftype ==# 'terminal'
  silent file ~/.dotfiles/awesome/dot-config/awesome/modules/utils/test_box.lua
endif
balt ~/.dotfiles/awesome/dot-config/awesome/modules/control_center/redshift_control_button.lua
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
let s:l = 18 - ((11 * winheight(0) + 26) / 52)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 18
normal! 011|
wincmd w
3wincmd w
exe '1resize ' . ((&lines * 26 + 27) / 54)
exe 'vert 1resize ' . ((&columns * 117 + 118) / 236)
exe '2resize ' . ((&lines * 25 + 27) / 54)
exe 'vert 2resize ' . ((&columns * 117 + 118) / 236)
exe 'vert 3resize ' . ((&columns * 118 + 118) / 236)
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
