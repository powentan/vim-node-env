" customize utilities for nodejs
if exists("g:nodejs_utilities")
    finish
endif
let g:nodejs_utilities = 1

" debug flag
let s:debug = 0

fun Debug(msg)
    if !s:debug 
        return
    endif
    echo a:msg
endf


fun g:GotoFile()
    let line = getline(".")
    let default_file = expand("<cfile>")
    let pattern = "require(\\s*['\"]" . default_file . "['\"]\\s*"
    
    let filename = ""
    if line =~ pattern && fnamemodify(expand("<cfile>"), ":e") != "js"
        let filename = default_file . ".js"
    else
        let filename = default_file
    endif

    " switch current directory to the path of open file(follows symbolic link)
    let open_file_dir = fnamemodify(resolve(expand('%')), ':p:h')
    call Debug('file path = ' . open_file_dir)
    exec 'lcd ' . open_file_dir

    if has('win32')
      " FIXME: workaround for windows
      let module_paths = ['./node_modules']
    else
      let path_str = system("node -e 'console.log(module.paths)'")
      let module_paths = eval(substitute(path_str, nr2char(10), '', 'g'))
    endif

    call Debug(module_paths)

    call Debug("filename = " . filename)
    let filename = resolve(expand(filename))
    call Debug("expand filename = " . filename)
    let abs_path = globpath(join(module_paths, ","), filename)
    call Debug("abs_path = " . abs_path)

    if abs_path != ""
        if isdirectory(abs_path)
            exec "edit " . abs_path . "/index.js"
        else
            exec "edit " . abs_path
        endif
    else
        let abs_path = globpath(join(module_paths, ","), default_file . "/index.js")
        if abs_path == ""
            let abs_path = globpath(join(module_paths, ","), default_file . "/" . default_file . ".js")
        endif
        let abs_path = resolve(abs_path)
        call Debug("abs_path = " . abs_path)
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
