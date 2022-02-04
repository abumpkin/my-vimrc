set nocompatible              " 去除VI一致性,必须
filetype off                  " 必须

" 设置包括vundle和初始化相关的runtime path
set rtp+=$HOME/.vim/bundle/Vundle.vim
" call vundle#begin()
" 另一种选择, 指定一个vundle安装插件的路径
call vundle#begin('$HOME/.vim/bundle/plugs')

" 让vundle管理插件版本,必须
Plugin 'VundleVim/Vundle.vim'

" 以下范例用来支持不同格式的插件安装.
" 请将安装插件的命令放在vundle#begin和vundle#end之间.
" Github上的插件
" 格式为 Plugin '用户名/插件仓库名'
" Plugin 'tpope/vim-fugitive'

" 来自 http://vim-scripts.org/vim/scripts.html 的插件
" Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
" Plugin 'L9'
" 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
" Plugin 'git://git.wincent.com/command-t.git'
" 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
" Plugin 'file:///home/gmarik/path/to/plugin'
" 插件在仓库的子目录中.
" 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
" Plugin 'ascenator/L9', {'name': 'newL9'}
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'

" 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
"filetype plugin on
"
" 简要帮助文档
" :PluginList       - 列出所有已配置的插件
" :PluginInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PluginClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件
"
" 查阅 :h vundle 获取更多细节和wiki以及FAQ
" 将你自己对非插件片段放在这行之后

" 设置退格可换行
set backspace=indent,eol,start
" gui " 初始化颜色默认值:background,foreground...
" syntax语法高亮，可简写为sy
" 这个命令实际执行的是：
" :source $VIMRUNTIME/syntax/syntax.vim
syntax enable
" 映射F7键用来开关语法高亮,<Bar>对应‘|’,<CR>对应‘\n’即回车
function ToggleSyntax()
    :if exists("g:syntax_on")
        :syntax off
    :else
        :syntax enable
    :endif
endfunction
map <F7> :silent :call ToggleSyntax()<CR> 
" 显示行号
set number
"设置文件编码
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
set termencoding=utf-8
"解决菜单乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
""解决consle输出乱码
language messages zh_CN.utf-8
" 调整默认配色
so $VIMRUNTIME/colors/evening.vim
" 设置字体
set guifont=Source_Code_Pro:h10:cANSI:qDRAFT
"设置窗口大小
set lines=35
set columns=126

" airline插件配置
set t_Co=256      "在windows中用xshell连接打开vim可以显示色彩
let g:airline#extensions#tabline#enabled = 1   " 是否打开tabline
"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1
set laststatus=2  "永远显示状态栏
let g:airline_theme='bubblegum' "选择主题
let g:airline#extensions#tabline#enabled=1    "Smarter tab line: 显示窗口tab和buffer
"let g:airline#extensions#tabline#left_sep = ' '  "separater
"let g:airline#extensions#tabline#left_alt_sep = '|'  "separater
"let g:airline#extensions#tabline#formatter = 'default'  "formater
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '>'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '<'

" 设置NERDtree箭头
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

" 设置Tagbar箭头和标识
let g:tagbar_iconchars = ['▶', '▼']
let g:tagbar_visibility_symbols = {
            \ 'public'    : '🔓',
            \ 'protected' : '🔐',
            \ 'private'   : '🔒'
            \ }

"设置外部格式化程序
function ReadStyleText(path)
    let l:li = readfile(expand(a:path))
    let l:i = len(l:li)
    let l:c = 0
    let l:text = ''
    while l:i > 0
        let l:i = l:i - 1
        if match(l:li->get(l:c), "^ *#.*") < 0
            let l:text .= l:li->get(l:c)
        endif
        let l:c = l:c + 1
    endwhile
    let l:text = substitute(l:text, " ", "", "g")
    let l:text = substitute(l:text, ":", ":\\\\ ", "g")
    let l:text = substitute(l:text, "\t", "", "g")
    let l:text = substitute(l:text, ",", "\\,", "g")
    let l:text = substitute(l:text, "|", "\\|", "g")
    return l:text
endfunction

let g:formaterPath = "C:/TDM-GCC-64/bin/clang-format.exe"
execute printf("set formatprg=%s\\ -style=\\\"%s\\\"", g:formaterPath, 
    \ReadStyleText("~/.clang-format"))

function FormatDocument()
    :let l:lineNumber = line(".")
    :normal gggqG 
    :startinsert
    :call cursor(l:lineNumber, 0)
    :normal ^
endfunction
:imap <C-S-F> <C-c>:call FormatDocument()<CR><Esc>
nmap <C-S-F> <Ins><C-S-F>
"设置缩进宽度
set tabstop=4
set shiftwidth=4
set expandtab
"设置缩进快捷键
map <C-[><C-[> <C-c>:<<CR><Ins>
imap <C-]> <C-c>:><CR><Ins>

" 设置保存并关闭当前tab快捷键
map <F1> :w <Bar> :confirm bd<CR>

"根据bufname找bufnr
function FindBufferNr(expr)
    if empty(a:expr)
        return -1
    endif
    for i in getbufinfo({'bufloaded': 1})
        if bufname(i.bufnr) =~ a:expr
            return i.bufnr
        endif
    endfor
    return -1
endfunction

" 初始化全局变量TreeNavBufnr表示默认nerdtree的buf
" 初始化全局变量TreeNavStatus表示默认nerdtree是否在显示状态
" 初始化全局变量TagbarBufnr表示tagbar的buf
" 初始化全局变量TagbarStatus表示tagbar是否在显示状态
let g:TreeNavBufnr = -1
let g:TreeNavStatus = 0
let g:TagbarBufnr = -1
let g:TagbarStatus = 0

" 启动时自动加载nerd树，加载tagbar
autocmd VimEnter * call feedkeys("\<F6>", 'm') 



" 实现tagbar放在NERDTree的下边，如果没显示NERDtree则放最左
function CorrectTagbarPos()
    let specWinid = win_findbuf(g:TreeNavBufnr) 
    let tagbarWinid = win_findbuf(g:TagbarBufnr) 
    if !empty(specWinid) && !empty(tagbarWinid)
        call win_splitmove(tagbarWinid[0], specWinid[0], {'rightbelow': 1}) 
    else 
        if !empty(tagbarWinid)
            call win_execute(tagbarWinid[0], "wincmd H")
        endif
    endif 
endfunction

" 设置tagbar快捷键
map <F8> :call execute(":TagbarToggle") <Bar>
    \if !bufexists(g:TagbarBufnr) <Bar>
    \   let g:TagbarBufnr = FindBufferNr('__Tagbar__\.\d\+') <Bar>
    \endif <Bar>
    \if g:TagbarStatus <Bar>
    \   let g:TagbarStatus = 0 <Bar>
    \else <Bar>
    \   let g:TagbarStatus = 1 <Bar>
    \   call CorrectTagbarPos() <Bar>
    \   wincmd p <Bar>
    \endif<CR><Space>
    
" 设置NERDtree快捷键
" feedkeys的目的是放止异常声响，因为在关闭nerdtree时会停住pause，
" 需要按任意键恢复
map <F6> :call execute(":NERDTreeToggle", "silent!") <Bar>
    \if !bufexists(g:TreeNavBufnr) <Bar>
    \   let g:TreeNavBufnr = FindBufferNr('NERD_tree_\d\+') <Bar>
    \endif <Bar>
    \if g:TreeNavStatus <Bar>
    \   let g:TreeNavStatus = 0 <Bar>
    \   let g:f6#colnum = col('.') <Bar>
    \   call feedkeys(string(g:f6#colnum).'<Bar>') <Bar>
    \   unlet g:f6#colnum <Bar>
    \else <Bar>
    \   let g:TreeNavStatus = 1 <Bar>
    \   wincmd p <Bar>
    \endif<CR>

" 每个新tab打开NERDTree.
autocmd BufWinEnter * if getcmdwintype() == '' | 
    \silent NERDTreeMirror |
    \endif

"找到Nerdtree侧栏的正确位置
function GetCorrectNerdTreeWinid(...)
    if a:0 == 0
        let layout = [winlayout()]
    else
        let layout = a:1
    endif
    for i in layout
        if i[0] == 'leaf'
            if a:0 > 1
                return i[1]
            endif
        endif
        if i[0] == 'col'
            if a:0 > 1
                return GetCorrectNerdTreeWinid(i[1], 1)
            endif
            return GetCorrectNerdTreeWinid(i[1])
        endif
        if i[0] == 'row'
            return GetCorrectNerdTreeWinid(i[1], 1)
        endif
    endfor
    return 0
endfunction
" 在当前tabpage里找当前buf为{bufname}的窗口id，没找到返回0
function BufInCurTabPage(bufname)
    silent! unlet g:BufInCurTabPage#bufInTab
    windo execute printf("if bufname('%%') =~ '%s' | let g:BufInCurTabPage#bufInTab = win_getid() | endif", a:bufname)
    if exists("g:BufInCurTabPage#bufInTab")
        let winid = g:BufInCurTabPage#bufInTab
        unlet g:BufInCurTabPage#bufInTab
        return winid
    endif
    return 0
endfunction
" 在当前tabpage里找之前的buf为{bufname}的窗口id，没找到返回0
function BufPreInTabPage(bufname)
    silent! unlet g:BufPreInTabPage#bufInTab
    windo execute printf("if bufname('#') =~ '%s' | let g:BufPreInTabPage#bufInTab = win_getid() | endif", a:bufname)
    if exists("g:BufPreInTabPage#bufInTab")
        let winid = g:BufPreInTabPage#bufInTab
        unlet g:BufPreInTabPage#bufInTab
        return winid
    endif
    return 0
endfunction

" 实现固定NERDTree在屏幕最左
" 如果另一个buffer试图替代NERDTree，则把它放到另外的窗口并换回NERDTree
" 如果窗口发生变换则重新矫正Tagbar的位置
autocmd BufWinEnter * if winnr('$') > 1 &&
    \bufexists(g:TreeNavBufnr) &&
    \g:TreeNavStatus &&
    \bufname(winbufnr(GetCorrectNerdTreeWinid())) !~ 'NERD_tree_\d\+' |
    \let cor_winid = GetCorrectNerdTreeWinid() |
    \let wro_winid = BufInCurTabPage('NERD_tree_\d\+') |
    \let wro_bufnr = winbufnr(cor_winid) | 
    \let cor_bufnr = g:TreeNavBufnr |
    \if cor_winid != 0 && cor_bufnr != 0 |
        \call win_execute(cor_winid, printf("buffer%d", cor_bufnr)) |
        \if wro_winid == 0 |
            \execute(printf("tabnew +buffer%d", wro_bufnr)) |
            \silent NERDTreeMirror |
        \else |
            \call win_execute(wro_winid, printf("buffer%d", wro_bufnr)) |
        \endif |
    \endif |
\endif |
\if g:TagbarStatus |
    \call CorrectTagbarPos() |
\endif


" call win_splitmove()


