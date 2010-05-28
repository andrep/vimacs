"""
"" TabIndent (1.0)
"
" Overloads <Tab> to either insert a tab, or perform indentation
"

"
" Copyright (C) 2002  Andre Pang <ozone@vimacs.cx>
"
" Please see the documentation (tab-indent.txt) for installation and usage
" notes.
"

if exists("loaded_TabIndent")
  finish
endif

if !exists("g:TabIndentStyle")
  let g:TabIndentStyle = 1
endif

inoremap <silent> <Tab> <C-r>=<SID>TabOrIndent()<CR>

function! <SID>TabOrIndent()

  let saved_cpoptions = &cpoptions
  set cpoptions-=<,C,k
  set cpoptions+=B

  let indent_blank_line = "\<End>x\<C-o>==\<End>\<Left>\<Del>"
  let indent = "\<C-o>=="
  let real_tab = "\<Tab>"

  let &cpoptions = saved_cpoptions

  if &cindent || &indentexpr != ""

    if g:TabIndentStyle == 1 || g:TabIndentStyle == "emacs" || g:TabIndentStyle == "always"
      if getline('.') =~ '^\s*$'
	return indent_blank_line
      else
	return indent
      endif

    elseif g:TabIndentStyle == 2 || g:TabIndentStyle == "whitespace"
      if virtcol('.') <= indent(line('.'))
	return indent 
      else
	return real_tab
      endif

    elseif g:TabIndentStyle == 3 || g:TabIndentStyle == "startofline"
      if virtcol('.') <= indent(line('.')) || virtcol('.') == 1
	return indent 
      else
	return real_tab
      endif
      
    endif

  else
    return real_tab
  endif

endfunction

let loaded_TabIndent = 1

