" Searching word with sdcv at Vim.

function! SearchWord(mode)
    let search_str = ''

    if a:mode == 'v'
        let search_str = s:get_visual_selection()
    else
        let search_str = expand('<cword>')
    endif

    let cmd = 'sdcv --utf8-output -n "' . search_str . '"'

	let expl=system(cmd)

	windo if
				\ expand("%")=="diCt-tmp" |
				\ q!|endif
    set splitbelow
	10sp diCt-tmp
    set rightleft
	setlocal buftype=nofile bufhidden=hide noswapfile
	1s/^/\=expl/
	1
endfunction

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
