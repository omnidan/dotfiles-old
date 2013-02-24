" gitdiff.vim: make a git diff command in vim editor
" Author: KarlZheng (zhengkarl at gmail dot com)
" Last Change: 10-Jan-2012 @ 18:30
" Created:     11-Oct-2011
" Requires:    Vim-7.1
" Version:     0.0.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org//script.php?script_id=
" Usage:
"     See :help gitdiff.txt

function! GitDiffLog()
	 let l:curline = line('.')
	 let l:maxline = line('$')
	 "find the firsttag
	 let l:line = l:curline + 1
	 while l:line <= l:maxline
		 let l:linetext = getline(l:line)
		 if matchstr(l:linetext, "^commit ") != ""
			 let l:firsttag= strpart(l:linetext, 7, 40)
			 break
		 endif
		 let l:line = l:line + 1
	 endwhile
	 
	 "find the second tag (new tag)
	 let l:line = l:curline
	 while l:line >= 0
		 let l:linetext = getline(l:line)
		 if matchstr(l:linetext, "^commit ") != ""
			 let l:secondtag = strpart(l:linetext, 7, 40)
			 break
		 endif
		 let l:line = l:line - 1
	 endwhile
	 let l:gitdiff_filename = ""
	 let l:gitdiff_filename = "/dev/shm/gitdiff.c"
	 if l:curline == 1
		 let l:_cmd_ = 'git diff > ' . l:gitdiff_filename
	 else
		 "let l:gitdiff_filename = 'gitdiff_'.l:firsttag.'_'.l:secondtag.'.c'
		 "let l:gitdiff_filename = '/dev/shm/gitdiff_'.l:firsttag.'_'.l:secondtag.'.c'
		 "let l:_cmd_ = 'git diff '.l:firsttag.' '.l:secondtag.' > ' .  l:gitdiff_filename
		 let l:_cmd_ = 'git diff '.l:secondtag.'^ '.l:secondtag.' > ' .  l:gitdiff_filename
	 endif
	 let _resp = system(l:_cmd_)
	 "exec ":e ".'gitdiff_'.l:firsttag.'_'.l:secondtag.'.c'

	let l:dict = {}
	let l:gitdiffbuf = 0 
	let l:gitdiffwnd = 0 
	redir => g:mymsg
	"echo range(1, bufnr("$"))                                        
	for i in range(1, bufnr("$"))                                        
		let l:buffilename = bufname(i)
		let l:wn = bufwinnr(l:buffilename)
		if l:wn != -1
			let l:dict[l:wn] = l:buffilename
			if matchstr(l:buffilename, "gitdiff") != ""
				echo "match"
				let l:gitdiffbuf = i
				let l:gitdiffwnd = l:wn
			endif
		endif
	endfor
	"echo l:dict
	"echo "len:" len(l:dict)
	"echo "git:" l:gitdiffbuf 
	if l:gitdiffbuf != 0 
		if l:gitdiffwnd != 0
			exe l:gitdiffwnd . "wincmd w"
		endif
		"exe "buffer " . l:gitdiffbuf
		exe "e " . l:gitdiff_filename
	else
		"new
		exe "vs"
		exe "wincmd L"
		exe "e " . l:gitdiff_filename
	endif
	" go to the line start with "---a/" that contains a filename
	 let l:maxline = line('$')
	 let l:line = 1
	 while l:line <= l:maxline
		 let l:linetext = getline(l:line)
		 if matchstr(l:linetext, "--- a/") != ""
			 break
		 endif
		 let l:line = l:line + 1
	 endwhile
	exe "normal ".l:line."gg"
	"go back to git diff log window"
	exe "wincmd h"
	redir END
	"echo g:mymsg
endfunc

nnoremap <leader>gd :call GitDiffLog()<cr>


function! <SID>GitEditFileInLine()
	let l:linetext = getline('.')
	if matchstr(l:linetext, "^--- a/") != ""
		let l:linetext = "sp ".substitute(l:linetext, "--- a/", "", "")
		let l:nextlinetext = getline(line('.') + 2)
		let l:linenu = substitute(nextlinetext, "@@.*-\\d*,\\d*\\s\+\\(\\d*\\).*", "\\1", "g")
		exec l:linetext
		exec "normal ".l:linenu."gg"
		"exe "wincmd J"
	elseif matchstr(l:linetext, "^+++ b/") != ""
		let l:linetext = "sp ".substitute(l:linetext, "^+++ b/", "", "")
		let l:nextlinetext = getline(line('.') + 1)
		let l:linenu = substitute(nextlinetext, "@@.*-\\d*,\\d*\\s\+\\(\\d*\\).*", "\\1", "g")
		exec l:linetext
		exec "normal ".l:linenu."gg"
		"exe "wincmd J"
	endif
endfunction
command! GitEditFileInLine call <SID>GitEditFileInLine()
map <leader>gf :GitEditFileInLine<cr>

