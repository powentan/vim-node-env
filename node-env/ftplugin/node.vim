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
    if line =~ pattern
        let filename = default_file . ".js"
    else
        let filename = default_file
    endif

    " get all possible paths
    let path_str = system("node -e 'console.log(require(\"module\").globalPaths)'")
    let module_paths = eval(substitute(path_str, nr2char(10), '', 'g'))
    " add current directory
    call add(module_paths, expand("%:p:h"))

    let abs_path = globpath(join(module_paths, ","), filename)
    if abs_path != ""
        exec "edit " . abs_path
    endif
endf

" override default function
map gf :call g:GotoFile()<CR>
