fun! CheckNodejs()
    let set_flag = 0
    let first_line = getline(1)

	if expand("%:e") == "js" && search("require(.*)", "n") != 0
		let set_flag = 1
    elseif first_line =~"^#!.*node"
        let set_flag = 1
    endif

    if set_flag == 1
        setlocal filetype=node
    endif
endf

autocmd! BufRead,BufWrite,BufNewFile * call CheckNodejs()

