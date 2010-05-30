"""
"" Vimacs (0.96)
"
" Vim-Improved eMACS
"
" (Oh dear, what have I got myself into?)
"

"
" Copyright (C) 2002  Andre Pang <ozone@vimacs.cx>
"
" Please see the documentation (vimacs.txt) for the README, installation
" notes, and the ChangeLog.
"

"
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
" 
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software
" Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
"
" This General Public License does not permit incorporating your program into
" proprietary programs.  If your program is a subroutine library, you may
" consider it more useful to permit linking proprietary applications with the
" library.  If this is what you want to do, use the GNU Library General
" Public License instead of this License.
"

" TODO: :h map-script
"       :h cpoptions
"       :h mapleader
"       :h map-<SID> <SID>
"       :h <Plug>
"       :h undo?
"       :h write-plugin

" Have <unique> for all maps?

" Load Vimacs?
if v:progname =~ '^vi$'
  " Never load Vimacs if user wants true Vi!  (We're not _that_ evil 8)
  finish
elseif v:progname =~ 'vimacs'
  let g:VM_Enabled = 1
elseif v:progname =~ 'vemacs' || v:progname == 'vm'
  let g:VM_Enabled = 1
  set insertmode
elseif !exists("g:VM_Enabled") || g:VM_Enabled == 0
  " A vim user should explicitly enable Vimacs
  finish
endif


if version < 600
  " We require Vim 6 to work :(
  echoerr 'Vimacs requires Vim 6 to run :('
  finish
endif

" We want to be able to remap <> key codes and do line continuation
let s:saved_cpoptions = &cpoptions
set cpoptions-=<,C


" Set a default value for a variable only if it doesn't exist
" (like "$foo |= 'bar'" in Perl)
"
" Thanks to Piet Delport for this solution, and Benji Fisher for
" additional comments :)
"

function! <SID>LetDefault(var_name, value)
  if !exists(a:var_name)
    execute 'let ' . a:var_name . '=' . a:value
  endif
endfunction

command! -nargs=+ LetDefault call s:LetDefault(<f-args>)


" Developers may want to turn this on, to always load the file
LetDefault g:VM_Dev 0

if (exists("loaded_vimacs") && g:VM_Dev == 0) || &cp
  finish
endif


"
" Function to mark a cursor position and restore it afterward -- used in a few
" functions, like FillParagraph().  Blatantly stolen from foo.vim by Benji
" Fisher :)
"

function! <SID>Mark(...)
  if a:0 == 0
    let mark = line(".") . "G" . virtcol(".") . "|"
    normal! H
    let mark = "normal!" . line(".") . "Gzt" . mark
    execute mark
    return mark
  elseif a:0 == 1
    return "normal!" . a:1 . "G1|"
  else
    return "normal!" . a:1 . "G" . a:2 . "|"
  endif
endfun


"
" set virtualedit=all (or onemore in Vim 7) is necessary
" for consistent word movement
"

function! <SID>SetVirtualedit()
  let s:saved_virtualedit = &virtualedit
  set virtualedit=all
endfunction

function! <SID>RestoreVirtualedit()
  let &virtualedit = s:saved_virtualedit
endfunction


"
" It's a good idea to have a command height of at least 2 if showmode is on,
" because many important messages will be overwritten by the mode display.
" e.g. <C-x><C-s>, which saves the file, will display that the file has been
" saved, but the notice will be immediately overwritten by the modeline when
" this happens.
"

" Don't fork around with cmdheight?
LetDefault g:VM_CmdHeightAdj 1

if &cmdheight == 1 && &showmode == 1 && g:VM_CmdHeightAdj
  set cmdheight=2
endif


"
" Vim options essential for emulating Emacs-ish behaviour
"

" Turn off <Alt>/<Meta> pulling down GUI menu
set winaltkeys=no
" Emacs normally wraps everything
set whichwrap=b,s,<,>,h,l,[,],~
" Emacs always has 'hidden buffers'
set hidden
" Backspace in Emacs normally backspaces anything :)
set backspace=indent,eol,start
" Want to be able to use <Tab> within our mappings
" (This has got to be the coolest option name ever, btw)
set wildcharm=<Tab>
" Recognise key sequences that start with <Esc> in Insert Mode
set esckeys


"
" For the UNIX console -- make <Esc>x == <M-x>
"

" Pressing <M-x> sends <Esc>x?  (As Unix terminals often do)
LetDefault g:VM_UnixConsoleMetaSendsEsc 1

" One or two <Esc>s required to go back to Normal mode?
LetDefault g:VM_SingleEscToNormal 1

if has("unix") && !has("gui_running") && g:VM_UnixConsoleMetaSendsEsc
  " <Esc>x maps to <M-x>
  "let charCode = 65
  "while charCode <= 122
  "  exec "set <Char-" . charCode . ">=\<Esc>" . nr2char(charCode)
  "  let charCode = charCode + 1
  "endwhile
  "unlet charCode
 set <M-1>=1
 set <M-2>=2
 set <M-3>=3
 set <M-4>=4
 set <M-5>=5
 set <M-6>=6
 set <M-7>=7
 set <M-8>=8
 set <M-9>=9
 set <M-0>=0
 set <M-a>=a
 set <M-b>=b
 set <M-c>=c
 set <M-d>=d
 set <M-e>=e
 set <M-f>=f
 set <M-g>=g
 set <M-h>=h
 set <M-i>=i
 set <M-j>=j
 set <M-k>=k
 set <M-l>=l
 set <M-m>=m
 set <M-n>=n
 set <M-o>=o
 set <M-p>=p
 set <M-q>=q
 set <M-r>=r
 set <M-s>=s
 set <M-t>=t
 set <M-u>=u
 set <M-v>=v
 set <M-w>=w
 set <M-x>=x
 set <M-y>=y
 set <M-z>=z
 set <M->=
 set <M-/>=/
 " Doing "set <M->>=^[>" throws up an error, so we be dodgey and use Char-190
 " instead, which is ASCII 62 ('>' + 128).
 set <Char-190>=>
 " Probably don't need both of these ;)
 set <Char-188>=<
 set <M-<>=<
 set <M-0>=0

 set <M-%>=%
 set <M-*>=*
 set <M-.>=.
 set <M-^>=^
 " Can't set <M-Space> right now :(
 "set <M-Space>=<Space>
" 
endif


"
" One or two <Esc>s to get back to Normal mode?
"

" on CmdwinLeave?
if g:VM_SingleEscToNormal == 1
  if &insertmode
    if has('unix') && !has('gui_running') && g:VM_UnixConsoleMetaSendsEsc
      inoremap <Esc><Esc> <C-o>:UseF1ForNormal<CR>
    else
      inoremap <Esc> <C-l>
    endif
  endif

  set notimeout
  set ttimeout
  set timeoutlen=50
else
  inoremap <Esc><Esc> <C-l>
  vnoremap <Esc><Esc> <Esc>
  set notimeout
  set nottimeout
endif

command! UseF1ForNormal echoerr "Use F1 or <C-z> to return to Normal mode.  :help vimacs-unix-esc-key"


"
" Insert mode <-> Normal mode <-> Command mode
" 

inoremap <M-x> <C-o>:
inoremap <M-:> <C-o>:
inoremap <F1> <C-l>
inoremap <F2> <C-o>
inoremap <M-`> <C-o>
inoremap <silent> <C-z> <C-l>:echo "Returning to Normal mode; press <C-z> again to suspend Vimacs"<CR>
nnoremap <C-z> :call <SID>Suspend()<CR>
" M-` isn't defined in Emacs
inoremap <C-c> <C-l>

inoremap <M-1> <C-o>1
inoremap <M-2> <C-o>2
inoremap <M-3> <C-o>3
inoremap <M-4> <C-o>4
inoremap <M-5> <C-o>5
inoremap <M-6> <C-o>6
inoremap <M-7> <C-o>7
inoremap <M-8> <C-o>8
inoremap <M-9> <C-o>9

LetDefault g:VM_NormalMetaXRemap 1

if g:VM_NormalMetaXRemap == 1
  nnoremap <M-x> :
endif

function! <SID>Suspend()
  suspend!
  if &insertmode
    startinsert
  endif
endfunction


"
" Leaving Vim
"

inoremap <C-x><C-c> <C-o>:confirm qall<CR>


"
" Files & Buffers
"

inoremap <C-x><C-f> <C-o>:hide edit<Space>
inoremap <C-x><C-s> <C-o>:update<CR>
inoremap <C-x>s <C-o>:wall<CR>
inoremap <C-x>i <C-o>:read<Space>
"what does C-x C-v do?
inoremap <C-x><C-w> <C-o>:write<Space>
inoremap <C-x><C-q> <C-o>:set invreadonly<CR>
inoremap <C-x><C-r> <C-o>:hide view<Space>


"
" Help Sistemmii (hi Finns)
"
"inoremap <C-h> <C-o>:help


"
" Error Recovery
" 

inoremap <C-_> <C-o>u
inoremap <C-x><C-u> <C-o>u
"lots of other stuff :(


"
" Incremental Searching and Query Replace
"

inoremap <C-s> <C-o>:call <SID>StartSearch('/')<CR><C-o>/
inoremap <C-r> <C-o>:call <SID>StartSearch('?')<CR><C-o>?
inoremap <M-n> <C-o>:cnext<CR>
" <M-n> not in Emacs: next in QuickFix
inoremap <M-p> <C-o>:cprevious<CR>
" <M-p> not in Emacs: previous in QuickFix
inoremap <C-M-s> <C-o>:call <SID>StartSearch('/')<CR><C-o>/
inoremap <C-M-r> <C-o>:call <SID>StartSearch('?')<CR><C-o>?
inoremap <M-s> <C-o>:set invhls<CR>
inoremap <M-%> <C-o>:call <SID>QueryReplace()<CR>
inoremap <C-M-%> <C-o>:call <SID>QueryReplaceRegexp()<CR>
cnoremap <C-r> <CR><C-o>?<Up>

command! QueryReplace :call <SID>QueryReplace()<CR>
command! QueryReplaceRegexp :call <SID>QueryReplaceRegexp()<CR>

" Searching is a bit tricky because we have to emulate Emacs's behaviour of
" searching again when <C-s> or <C-r> is pressed _inside_ the search
" commandline.  Vim has no equivalent to this, so we must use a bit of
" on-the-fly remap trickery (popular in Quake-style games) to provide
" different functionality for <C-s>, depending on whether you're in 'search
" mode' or not.
"
" We must map <C-g> and <CR> because we have to undo the map trickery that we
" set up when we abort/finish the search.  All in all, it's not too complex
" when you actually look at what the code does.
"
" Note that <C-c> in Emacs is functionally the same as <CR>.

LetDefault g:VM_SearchRepeatHighlight 0

function! <SID>StartSearch(search_dir)
  let s:incsearch_status = &incsearch
  let s:lazyredraw_status = &lazyredraw
  let s:hit_boundary = 0
  set nowrapscan
  set incsearch
  set lazyredraw
  cmap <C-c> <CR>
  cnoremap <C-s> <C-c><C-o>:call <SID>SearchAgain()<CR><C-o>/<Up>
  cnoremap <C-r> <C-c><C-o>:call <SID>SearchAgain()<CR><C-o>?<Up>
  cnoremap <silent> <CR> <CR><C-o>:call <SID>StopSearch()<CR>
  cnoremap <silent> <C-g> <C-c><C-o>:call <SID>AbortSearch()<CR>
  cnoremap <silent> <Esc> <C-c><C-o>:call <SID>AbortSearch()<CR>
  if a:search_dir == '/'
    cnoremap <M-s> <CR><C-o>:set invhls<CR><Left><C-o>/<Up>
  else
    cnoremap <M-s> <CR><C-o>:set invhls<CR><Left><C-o>?<Up>
  endif
  let s:before_search_mark = <SID>Mark()
endfunction

function! <SID>StopSearch()
  cunmap <C-c>
  cunmap <C-s>
  cunmap <C-r>
  cunmap <CR>
  cunmap <C-g>
  cnoremap <C-g> <C-c>
  if exists("s:incsearch_status")
    let &incsearch = s:incsearch_status
    unlet s:incsearch_status
  endif
  if g:VM_SearchRepeatHighlight == 1
    if exists("s:hls_status")
      let &hls = s:hls_status
      unlet s:hls_status
    endif
  endif
endfunction

function! <SID>AbortSearch()
  call <SID>StopSearch()
  if exists("s:before_search_mark")
    execute s:before_search_mark
    unlet s:before_search_mark
  endif
endfunction

function! <SID>SearchAgain()
  
  "if (winline() <= 2)
  "  normal zb
  "elseif (( winheight(0) - winline() ) <= 2)
  "  normal zt
  "endif

  let current_pos = <SID>Mark()
  if search(@/, 'W') == 0
    " FIXME
    set wrapscan
    if s:hit_boundary == 1
      let s:hit_boundary = 2
    endif
    let s:hit_boundary = 1
  else
    if s:hit_boundary == 2
      let s:hit_boundary = 0
    endif
    execute current_pos
  endif
  
  cnoremap <C-s> <CR><C-o>:call <SID>SearchAgain()<CR><C-o>/<Up>
  cnoremap <C-r> <CR><C-o>:call <SID>SearchAgain()<CR><C-o>?<Up>
  
  if g:VM_SearchRepeatHighlight == 1
    if !exists("s:hls_status")
      let s:hls_status = &hls
    endif
    set hls
  endif

endfunction

" Emacs' `query-replace' functions

function! <SID>QueryReplace()
  let magic_status = &magic
  set nomagic
  let searchtext = input("Query replace: ")
  if searchtext == ""
    echo "(no text entered): exiting to Insert mode"
    return
  endif
  let replacetext = input("Query replace " . searchtext . " with: ")
  let searchtext_esc = escape(searchtext,'/\^$')
  let replacetext_esc = escape(replacetext,'/\')
  execute ".,$s/" . searchtext_esc . "/" . replacetext_esc . "/cg"
  let &magic = magic_status
endfunction

function! <SID>QueryReplaceRegexp()
  let searchtext = input("Query replace regexp: ")
  if searchtext == ""
    echo "(no text entered): exiting to Insert mode"
    return
  endif
  let replacetext = input("Query replace regexp " . searchtext . " with: ")
  let searchtext_esc = escape(searchtext,'/')
  let replacetext_esc = escape(replacetext,'/')
  execute ".,$s/" . searchtext_esc . "/" . replacetext_esc . "/cg"
endfunction


"
" Command line editing
"

" Navigation
cmap <C-b> <Left>
cmap <C-f> <Right>
cnoremap <M-f> <S-Right>
cnoremap <M-b> <S-Left>
cmap <C-a> <Home>
cmap <C-e> <End>

" Editing
cmap <M-p> <Up>
cmap <M-n> <Down>
cmap <C-d> <Del>
cnoremap <C-y> <C-r><C-o>"
cnoremap <M-w> <C-y>
cnoremap <M-BS> <C-w>
cnoremap <C-k> <C-f>d$<C-c><End>
"Should really use &cedit, not just <C-f> -- but how?


"
" Navigation
"

function! <SID>ForwardWord()
  if col('.')>1 || line('.')>1
    return "normal! hel"
  else
    return "normal! el"
  endif
endfunction

inoremap <silent> <SID>ForwardWord <C-o>:call <SID>SetVirtualedit()<CR>
  \<C-o>:execute <SID>ForwardWord()<CR>
  \<C-o>:call <SID>RestoreVirtualedit()<CR>

onoremap <silent> <SID>OForwardWord :call <SID>SetVirtualedit()<Bar>
  \execute <SID>ForwardWord()<Bar>
  \call <SID>RestoreVirtualedit()<CR>

" Weird.  In Vim 7, if insertmode is on, if you exit visual mode in a mapping,
" things get weird unless you do some normal command, even a no-op
nmap <SID>Nop <Nop>
function! <SID>ExitVisual()
  if ! &insertmode
    startinsert
  else
    normal! <SID>Nop
  endif
endfunction

function <SID>VForwardWord1()
  if col('.')>=col('$')
    let s:vforward_fix = 1
  else
    let s:vforward_fix = 0
  endif
endfunction

function <SID>VForwardWord2()
  if s:vforward_fix
    return "\<C-o>gv``\<Right>"
  else
    return "\<C-o>gv``"
  endif
endfunction

function <SID>AdjustVisualModeExitPosition(backwards)
  if line('.')==line("'>") && col('.')+1 == col("'>")
    if !a:backwards || line('.')!=line("'<") || col('.') != col("'<")
      return "\<Right>"
    endif
  elseif line('.')==line("'<") && col('.')+1 == col("'<")
    return "\<Right>"
  endif
  return ""
endfunction

if version >= 700
  vnoremap <silent> <SID>VForwardWord <C-c>
    \:call <SID>ExitVisual()<CR>
    \<C-r>=<SID>AdjustVisualModeExitPosition(0)<CR>
    \<C-o>:call <SID>SetVirtualedit()<CR>
    \<C-o>:execute <SID>ForwardWord()<CR>
    \<C-o>:call <SID>VForwardWord1()<CR>
    \<C-o>m`
    \<C-o>:call <SID>RestoreVirtualedit()<CR>
    \<C-r>=<SID>VForwardWord2()<CR>
else
  vnoremap <silent> <SID>VForwardWord <C-c>
    \i
    \<C-r>=<SID>AdjustVisualModeExitPosition(0)<CR>
    \<C-o>:call <SID>SetVirtualedit()<CR>
    \<C-o>:execute <SID>ForwardWord()<CR>
    \<C-o>:call <SID>VForwardWord1()<CR>
    \<C-o>m`
    \<C-o>:call <SID>RestoreVirtualedit()<CR>
    \<C-r>=<SID>VForwardWord2()<CR>
endif

function! <SID>BackwardWord()
  let l:line = line('.')
  let l:getline = getline(l:line)
  if col('.')==1 || strpart(l:getline,0,col('.')-1) =~ '^\s*$'
    let l:count = l:line-1 - prevnonblank(l:line-1)
    if l:count > 0
      return "normal! " . l:count . "kb"
    endif
  endif
  if col('.')>=col('$') && line('.')<line('$')
    return "normal! lb"
  else
    return "normal! b"
  endif
endfunction

inoremap <silent> <SID>BackwardWord <C-o>:call <SID>SetVirtualedit()<CR>
  \<C-o>:execute <SID>BackwardWord()<CR>
  \<C-o>:call <SID>RestoreVirtualedit()<CR>

onoremap <silent> <SID>OBackwardWord :call <SID>SetVirtualedit()<Bar>
  \execute <SID>BackwardWord()<Bar>
  \call <SID>RestoreVirtualedit()<CR>

if version >= 700
  vnoremap <silent> <SID>VBackwardWord <C-c>
    \:call <SID>ExitVisual()<CR>
    \<C-r>=<SID>AdjustVisualModeExitPosition(1)<CR>
    \<C-o>:call <SID>SetVirtualedit()<CR>
    \<C-o>:execute <SID>BackwardWord()<CR>
    \<C-o>m`
    \<C-o>:call <SID>RestoreVirtualedit()<CR>
    \<C-o>gv
    \``
else
  vnoremap <silent> <SID>VBackwardWord <C-c>
    \i
    \<C-r>=<SID>AdjustVisualModeExitPosition(1)<CR>
    \<C-o>:call <SID>SetVirtualedit()<CR>
    \<C-o>:execute <SID>BackwardWord()<CR>
    \<C-o>m`
    \<C-o>:call <SID>RestoreVirtualedit()<CR>
    \<C-o>gv
    \``
endif

" Insert/Visual/Operator mode maps
imap <C-b> <Left>
vmap <C-b> <Left>
omap <C-b> <Left>
imap <C-f> <Right>
vmap <C-f> <Right>
omap <C-f> <Right>
imap <C-p> <Up>
vmap <C-p> <Up>
omap <C-p> <Up>
imap <C-n> <Down>
vmap <C-n> <Down>
omap <C-n> <Down>
inoremap <script> <M-f> <SID>ForwardWord
vnoremap <script> <M-f> <SID>VForwardWord
onoremap <script> <M-f> <SID>OForwardWord
inoremap <script> <M-b> <SID>BackwardWord
vnoremap <script> <M-b> <SID>VBackwardWord
onoremap <script> <M-b> <SID>OBackwardWord
imap <C-a> <Home>
vmap <C-a> <Home>
omap <C-a> <Home>
imap <C-e> <End>
vmap <C-e> <End>
omap <C-e> <End>
inoremap <M-a> <C-o>(
vnoremap <M-a> (
onoremap <M-a> (
inoremap <M-e> <C-o>)
vnoremap <M-e> )
onoremap <M-e> )
inoremap <C-d> <Del>
vnoremap <C-d> <Del>
onoremap <C-d> <Del>
inoremap <M-<> <C-o>1G<C-o>0
vnoremap <M-<> 1G0
onoremap <M-<> 1G0
inoremap <M->> <C-o>G<C-o>$
vnoremap <M->> G$
onoremap <M->> G$
inoremap <C-v> <PageDown>
vnoremap <C-v> <PageDown>
onoremap <C-v> <PageDown>
inoremap <M-v> <PageUp>
vnoremap <M-v> <PageUp>
onoremap <M-v> <PageUp>
inoremap <M-m> <C-o>^
vnoremap <M-m> ^
onoremap <M-m> ^
inoremap <C-x>= <C-g>
vnoremap <C-x>= <C-g>
onoremap <C-x>= <C-g>
inoremap <silent> <M-g> <C-o>:call <SID>GotoLine()<CR>
vnoremap <silent> <M-g> :<C-u>call <SID>GotoLine()<CR>
onoremap <silent> <M-g> :call <SID>GotoLine()<CR>
inoremap <silent> <C-x>g <C-o>:call <SID>GotoLine()<CR>
vnoremap <silent> <C-x>g :<C-u>call <SID>GotoLine()<CR>
onoremap <silent> <C-x>g :call <SID>GotoLine()<CR>
" Phear, <M-g> works properly even in Visual/Operator-Pending
" modes :)  (It's rather dangerous with the latter, though ...)
inoremap <script> <M-Left> <SID>BackwardWord
vnoremap <script> <M-Left> <SID>VBackwardWord
onoremap <script> <M-Left> <SID>OBackwardWord
inoremap <script> <M-Right> <SID>ForwardWord
vnoremap <script> <M-Right> <SID>VForwardWord
onoremap <script> <M-Right> <SID>OForwardWord
inoremap <script> <C-Left> <SID>BackwardWord
vnoremap <script> <C-Left> <SID>VBackwardWord
onoremap <script> <C-Left> <SID>OBackwardWord
inoremap <script> <C-Right> <SID>ForwardWord
vnoremap <script> <C-Right> <SID>VForwardWord
onoremap <script> <C-Right> <SID>OForwardWord
inoremap <C-Up> <C-o>{
vnoremap <C-Up> {
onoremap <C-Up> {
inoremap <C-Down> <C-o>}
vnoremap <C-Down> }
onoremap <C-Down> }

command! GotoLine :call <SID>GotoLine()

function! <SID>GotoLine()
  let targetline = input("Goto line: ")
  if targetline =~ "^\\d\\+$"
    execute "normal! " . targetline . "G0"
  elseif targetline =~ "^\\d\\+%$"
    execute "normal! " . targetline . "%"
  elseif targetline == ""
    echo "(cancelled)"
  else
    echo " <- Not a Number"
  endif
endfunction

command! GotoLine :call <SID>GotoLine()


"
" General Editing
"

inoremap <C-u> <C-o>d0
inoremap <C-q> <C-v>
inoremap <C-^> <C-y>
inoremap <M-r> <C-r>=

"" Aborting
cnoremap <C-g> <C-c>
onoremap <C-g> <C-c>


"
" Killing and Deleting
"

inoremap <C-d> <Del>
inoremap <silent> <M-d> <C-r>=<SID>KillWord()<CR>
inoremap <M-> <C-w>
inoremap <M-BS> <C-w>
inoremap <C-BS> <C-w>
inoremap <silent> <C-k> <C-r>=<SID>KillLine()<CR>
" Thanks to Benji Fisher for helping me with getting <C-k> to work!
inoremap <M-0><C-k> <C-o>d0
inoremap <M-k> <C-o>d)
inoremap <C-x><BS> <C-o>d(
inoremap <M-z> <C-o>dt
inoremap <M-\> <Esc>beldwi

function! <SID>KillWord()
  if col('.') > strlen(getline('.'))
    return "\<Del>\<C-o>dw"
  else
    return "\<C-o>dw"
  endif
endfunction

function! <SID>KillLine()
  if col('.') > strlen(getline('.'))
    " At EOL; join with next line
    return "\<Del>"
  else
    " Not at EOL; kill until end of line
    return "\<C-o>d$"
  endif
endfunction


"
" Abbreviations
" 

inoremap <M-/> <C-p>
inoremap <C-M-/> <C-x>
inoremap <C-M-x> <C-x>
inoremap <C-]> <C-x>


"
" Visual stuff (aka 'marking' aka 'region' aka 'block' etc etc)
"

set sel=exclusive
" Visual mode
inoremap <silent> <C-Space> <C-r>=<SID>StartVisualMode()<CR>
" Unix terminals produce <C-@>, not <C-Space>
imap <C-@> <C-Space>
vnoremap <C-x><C-Space> <Esc>
vnoremap <C-g> <Esc>
vnoremap <C-x><C-@> <Esc>
vnoremap <M-w> "1y
vnoremap <C-Ins> "+y
vnoremap <S-Del> "+d
"May have to change to "1d and paste ...

" Marking blocks
inoremap <silent> <M-Space> <C-o>:call <SID>StartMarkSel()<CR><C-o>viw
inoremap <silent> <M-h> <C-o>:call <SID>StartMarkSel()<CR><C-o>vap
inoremap <silent> <C-<> <C-o>:call <SID>StartMarkSel()<CR><C-o>v1G0o
inoremap <silent> <C->> <C-o>:call <SID>StartMarkSel()<CR><C-o>vG$o
inoremap <silent> <C-x>h <C-o>:call <SID>StartMarkSel()<CR><Esc>1G0vGo

" Block operations
vnoremap <C-w> "1d
vnoremap <S-Del> "_d
vnoremap <C-x><C-x> o
vnoremap <C-x><C-u> U
vnoremap <M-x> :

" Pasting
inoremap <silent> <C-y> <C-o>:call <SID>ResetKillRing()<CR><C-r><C-o>"
inoremap <S-Ins> <C-r><C-o>+
"inoremap <M-y> <C-o>:echoerr "Sorry, yank-pop is not yet implemented!"<CR>
inoremap <M-y> <C-o>:call <SID>YankPop()<CR>

function! <SID>YankPop()
  undo
  if !exists("s:kill_ring_position")
    call <SID>ResetKillRing()
  endif
  execute "normal! i\<C-r>\<C-o>" . s:kill_ring_position . "\<Esc>"
  call <SID>IncrKillRing()
endfunction

function! <SID>ResetKillRing()
  let s:kill_ring_position = 3
endfunction

function! <SID>IncrKillRing()
  if s:kill_ring_position >= 9
    let s:kill_ring_position = 2
  else
    let s:kill_ring_position = s:kill_ring_position + 1
  endif
endfunction

function! <SID>StartMarkSel()
  if &selectmode =~ 'key'
    set keymodel-=stopsel
  endif
endfunction

function! <SID>StartVisualMode()
  call <SID>StartMarkSel()
  if col('.') > strlen(getline('.'))
    " At EOL
    return "\<Right>\<C-o>v\<Left>"
  else
    return "\<C-o>v"
  endif
endfunction


"
" Use <Shift> to select text, ala Windows.
" (XEmacs supports this)
"

" We need to make sure that the 'keymodel' option has stopsel before we
" start the actual marking, so that the user can cancel it with any
" navigational key as she normally would.  This is in contrast to the
" <C-Space> style of marking, where navigational keys do _not_ cancel
" marking.
"
" Note that this doesn't work properly if the user remaps 

inoremap <silent> <S-Up>       <C-o>:call <SID>StartShiftSel()<CR><S-Up>
inoremap <silent> <S-Down>     <C-o>:call <SID>StartShiftSel()<CR><S-Down>
inoremap <silent> <S-Left>     <C-o>:call <SID>StartShiftSel()<CR><S-Left>
inoremap <silent> <S-Right>    <C-o>:call <SID>StartShiftSel()<CR><S-Right>
inoremap <silent> <S-End>      <C-o>:call <SID>StartShiftSel()<CR><S-End>
inoremap <silent> <S-Home>     <C-o>:call <SID>StartShiftSel()<CR><S-Home>
inoremap <silent> <S-PageUp>   <C-o>:call <SID>StartShiftSel()<CR><S-PageUp>
inoremap <silent> <S-PageDown> <C-o>:call <SID>StartShiftSel()<CR><S-PageDown>

function! <SID>StartShiftSel()
  if &selectmode =~ "key"
    set keymodel+=stopsel
  endif
endfunction


"
" Window Operations
"

inoremap <C-x>2 <C-o><C-w>s
inoremap <C-x>3 <C-o><C-w>v
inoremap <C-x>0 <C-o><C-w>c
inoremap <C-x>1 <C-o><C-w>o
inoremap <silent> <C-x>o <Esc><C-w>w:if &insertmode \| startinsert \| endif \| redraw<CR>
" <C-x>O is not defined in Emacs ...
inoremap <C-x>O <C-o><C-w>W
inoremap <silent> <C-Tab> <Esc><C-w>w:if &insertmode \| startinsert \| endif \| redraw<CR>
inoremap <silent> <C-S-Tab> <Esc><C-w>W:if &insertmode \| startinsert \| endif \| redraw<CR>
inoremap <C-x>+ <C-o><C-w>=
inoremap <silent> <C-M-v> <C-o>:ScrollOtherWindow<CR>

inoremap <C-x>4<C-f> <C-o>:FindFileOtherWindow<Space>
inoremap <C-x>4f <C-o>:FindFileOtherWindow<Space>

function! <SID>number_of_windows()
  let i = 1
  while winbufnr(i) != -1
    let i = i + 1
  endwhile
  return i - 1
endfunction

function! <SID>FindFileOtherWindow(filename)
  let num_windows = <SID>number_of_windows()
  if num_windows <= 1
    wincmd s
  endif
  wincmd w
  execute "edit " . a:filename
  wincmd W
endfunction

command! -nargs=1 -complete=file FindFileOtherWindow :call <SID>FindFileOtherWindow(<f-args>)

command! ScrollOtherWindow silent! execute "normal! \<C-w>w\<PageDown>\<C-w>W"


"
" Formatting
"

inoremap <silent> <M-=> <C-o>:call <SID>IndentParagraph()<CR>
inoremap <silent> <M-q> <C-o>:call <SID>FillParagraph()<CR>
inoremap <script> <C-o> <CR><Left>
inoremap <C-M-o> <C-o>:echoerr "<C-M-o> not supported yet; sorry!"<CR>
inoremap <C-x><C-o> <C-o>:call <SID>DeleteBlankLines()<CR>
" Try GoZ<Esc>:g/^$/.,/./-j<CR>Gdd
inoremap <M-^> <Up><End><C-o>J
vnoremap <C-M-\> =
vnoremap <C-x><Tab> =

command! FillParagraph :call <SID>FillParagraph()

function! <SID>FillParagraph()
  let old_cursor_pos = <SID>Mark()
  normal! gqip
  execute old_cursor_pos
endfunction

function! <SID>IndentParagraph()
  let old_cursor_pos = <SID>Mark()
  normal! =ip
  execute old_cursor_pos
endfunction

function! <SID>DeleteBlankLines()
  if getline(".") == "" || getline(". + 1") == "" || getline(". - 1") == ""
    ?^.\+$?+1,/^.\+$/-2d"_"
  endif
  normal j
endfunction



"
" Case Change
" 

inoremap <M-l> <C-o>gul<C-o>w
inoremap <M-u> <C-o>gUe<C-o>w
inoremap <M-c> <C-o>gUl<C-o>w


"
" Buffers
"

inoremap <C-x>b <C-r>=<SID>BufExplorerOrBufferList()<CR>
inoremap <C-x><C-b> <C-o>:buffers<CR>
inoremap <C-x>k <C-o>:bdelete<Space>

"" Integration with the BufExplorer plugin.  Phear :)  (I so love <C-r>=)
function! <SID>BufExplorerOrBufferList()
  if exists(":BufExplorer")
    if !exists("g:bufExplorerSortBy")
      " If user hasn't specified a sort order, default to MRU because that's
      " the default in Emacs, and also select the last viewed file.
      let g:bufExplorerSortBy = "mru"
    endif
"   echo bufexplorer_initial_keys
    return "\<C-o>:BufExplorer\<CR>"
  else
    return "\<C-o>:buffer \<Tab>"
  endif
endfunction

"" Integration with a.vim (Alternate File) plugin
if exists("*AlternateFile")
  inoremap <C-x><C-a> <C-o>:A<CR>
  inoremap <C-x>a <C-o>:A<CR>
  inoremap <C-x>b <C-r>=<SID>BufExplorerOrBufferList()<CR>
endif


"
" Marks (a.k.a. "Registers" in Emacs)
"

inoremap <C-x>/ <C-o>:call <SID>PointToRegister()<CR>
inoremap <C-x>r<Space> <C-o>:call <SID>PointToRegister()<CR>
inoremap <C-x>r<C-Space> <C-o>:call <SID>PointToRegister()<CR>
inoremap <C-x>r<C-@> <C-o>:call <SID>PointToRegister()<CR>

inoremap <C-x>rj <C-o>:call <SID>JumpToRegister()<CR>
inoremap <C-x>p <C-o><C-o>
" <C-x>p not in Emacs -- goes to Previous entry in jump list

command! PointToRegister :call PointToRegister()
command! JumpToRegister :call JumpToRegister()

function! <SID>PointToRegister()
  echo "Point to mark: "
  let c = nr2char(getchar())
  execute "normal! m" . c
endfunction

function! <SID>JumpToRegister()
  echo "Jump to mark: "
  let c = nr2char(getchar())
  execute "normal! `" . c
endfunction



"
" Transposing
"

"" for testing -- foo bar baz quux

inoremap <C-t> <Left><C-o>x<C-o>p
" M-t behaviour is not exactly the same as Emacs; live with it or send me
" a patch :)  (Personally, I find Emacs's M-t behaviour not very
" Do-What-I-Mean'ish anyway)
inoremap <M-t> <Esc>dawbhpi
inoremap <C-x><C-t> <Up><C-o>dd<End><C-o>p<Down>
inoremap <C-M-t> <C-o>:echoerr "C-M-t is not implemented yet; sorry!"<CR>


"
" Tags
"

inoremap <M-.> <C-o><C-]>
inoremap <M-*> <C-o><C-t>
inoremap <C-x>4. <C-o><C-w>}


"
" Shells
"

vnoremap <M-!> !
inoremap <M-!> <C-o>:!


"
" Rectangles
"

vnoremap <C-x>r <C-v>


"
" Abbreviations?
"


"
" GNU Info Reader?
"


"
" Keyboard Macros
"


"
" Redraw
"

inoremap <C-l> <C-o>zz<C-o><C-l>


"
" Folding
"

" I've changed the folding prefix <C-x>@to <C-x><C-x>, because <C-x>@ sucks
" <C-x><C-x><C-r> does the folding operation recursively
inoremap <C-x><C-x><C-w> <C-o>zM
inoremap <C-x><C-x><C-x> <C-o>zc
inoremap <C-x><C-x><C-r><C-x> <C-o>zC
inoremap <C-x><C-x><C-s> <C-o>zo
inoremap <C-x><C-x><C-r><C-s> <C-o>zO
inoremap <C-x><C-x>s <C-o>zR
inoremap <C-x><C-x>1s <C-o>zr
inoremap <C-x><C-x><C-q> <C-o>za
inoremap <C-x><C-x><C-r><C-q> <C-o>zA
inoremap <C-x><C-x>q <C-o>zM
inoremap <C-x><C-x>1q <C-o>zm


"
" Enable menus in the console (like GNU Emacs)
" Thanks to Piet Delport for this great idea!
" 

LetDefault g:VM_F10Menu 1

if g:VM_F10Menu == 1
  runtime menu.vim
  inoremap <F10> <C-o>:emenu <Tab>
endif


"
" We're done :)
"

delcommand LetDefault
delfunction s:LetDefault

" Restore cpoptions
let &cpoptions = s:saved_cpoptions

let loaded_vimacs = 1

" vim:sw=2

