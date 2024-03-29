"{{{ Private functions

" Create a new sauce file with the given name
function! sauce#SauceNew(name)
	let names=sauce#SauceNames()
	if index(names,a:name) >= 0
		echohl Error | echo "A sauce with this name already exists" | echohl None
		return
	endif
	let fname = g:sauce_path.a:name.".vimrc"
	exec "silent e ".fname." | silent r ".g:sauce_skel_file
endfunction

" Edit a sauce file with the given name
function! sauce#SauceEdit(name)
	let fname = g:sauce_path.a:name.".vimrc"
	if filereadable(fname)	
		exec "silent e ".fname
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction

" Delete a sauce file with the given name
function! sauce#SauceDelete(name)
	let fname = g:sauce_path.a:name.".vimrc"
	if filereadable(fname)
		let response = confirm("Are you sure you want to delete the sauce '".a:name."'? ","&Yes\n&No",2)
		if response == 1
			let delret = delete(fname)
			if 0 == delret
				echohl Error | echo "Deleted sauce file: ".fname | echohl None
			else
				echohl Error | echo "Failed to delete sauce file: ".fname | echohl None
			endif
		else
			echom "Cancelled delete"
		endif
	else
		echohl Error | echo "Invalid sauce file: ".fname | echohl None
	endif
endfunction

" Get all sauces as a list
function! sauce#SauceNames()
	let l:findop=system("find ".g:sauce_path." -name \"*.vimrc\" |awk -F/ '{print $NF}'")
	let l:sourcefiles=split(l:findop,"\n")
	let l:sources = []
	let l:sourcename = ""
	for fname in l:sourcefiles
		let l:sourcename = substitute(fname,".vimrc","","")
		call add(l:sources,l:sourcename)
	endfor
	return l:sources
endfunction

" Load a source file
function sauce#LoadSauce(source)
	let saucefile = g:sauce_path.a:source.".vimrc"
	if filereadable(saucefile)	
		if 1 == g:sauce_output
			echo "Loading sauce file ".saucefile
		endif
		exec "source ".saucefile
	else
		echohl Error | echo "Invalid sauce file: ".saucefile | echohl None
	endif
endfunction
"}}}
