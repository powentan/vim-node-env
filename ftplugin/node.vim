" customize utilities for nodejs
if exists("g:nodejs_utilities")
    finish
endif
let g:nodejs_utilities = 1


fun g:GotoFile()
    let line = getline(".")
    let default_file = expand("<cfile>")
    let pattern = "require(['\"]" . default_file . "['\"]"
    
    let filename = ""
    if line =~ pattern && fnamemodify(expand("<cfile>"), ":e") != "js"
        let filename = default_file . ".js"
    else
        let filename = default_file
    endif

    " get all possible paths
    let path_str = system("node -e 'console.log(require(\"module\").globalPaths)'")
    let module_paths = eval(substitute(path_str, nr2char(10), '', 'g'))
    " add current directory
    call add(module_paths, expand("%:p:h"))

	" echo filename
    let abs_path = globpath(join(module_paths, ","), filename)
    if abs_path != ""
        exec "edit " . abs_path
	else
		let abs_path = globpath(join(module_paths, ","), default_file . "/index.js")
		" echo abs_path
        exec "edit " . abs_path
    endif
endf

" override default function
map gf :call g:GotoFile()<CR>

function! EnhCommentifyCallback(ft)
    if a:ft == 'node'
        let b:ECcommentOpen = '//'
        let b:ECcommentClose = ''
    elseif a:ft == 'jade'
        let b:ECcommentOpen = '//'
        let b:ECcommentClose = ''
    endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'

