" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif


" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif

" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" Vundle工具安装方法为在终端输入如下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
else
    set rtp+=~/.vim/bundle/vundle/
    "set rtp+=$VIM/vimfiles/bundle/vundle/
    call vundle#rc('~/.vim/bundle/vundle/')
endif

" 使用Vundle来管理插件，这个必须要有。
Bundle 'gmarik/vundle'

""""""""vim scripts""""""""""""""""""
Bundle 'a.vim'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'taglist.vim'
Bundle 'ronakg/quickr-cscope.vim'

""""""""git repo"""""""""""""""
Bundle 'cSyntaxAfter'
Bundle 'Mark--Karkat'
Bundle 'scrooloose/syntastic'
Bundle 'Shougo/neocomplcache'
Bundle 'wesleyche/SrcExpl'
Bundle 'scrooloose/nerdtree'
Bundle 'Xuyuanp/nerdtree-git-plugin'
Bundle 'airblade/vim-gitgutter'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'jlanzarotta/bufexplorer'

" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式

set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set expandtab                                         "将Tab键转换为空格
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度

set foldenable                                        "启用折叠
set foldmethod=indent                                 "indent 折叠方式
set foldlevel=2                                       " 设置折叠层数

" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

set autoread                                          " 当文件在外部被修改，自动更新该文件

set nobackup                                          "取消备份文件
set noundofile                                        "取消undo文件

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用

" -----------------------------------------------------------------------------
"  < 界面配置 >
" -----------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
set cursorline                                        "突出显示当前行
set nowrap                                            "设置不自动换行

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " au GUIEnter * simalt ~x                         "窗口启动时自动最大化
    winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=50 columns=170                          "指定窗口大小，lines为高度，columns为宽度
endif

if (g:iswindows)
    colorscheme evening"                              "设置代码配色方案
else
    colorscheme darkblue"                             "设置代码配色方案
endif

noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l

" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================
" -----------------------------------------------------------------------------
"  < a.vim 插件配置 >
" -----------------------------------------------------------------------------
" 用于切换C/C++头文件
" 常规模式下输入 F2 调用插件
nmap <F2> :A<CR>
" :A     ---切换头文件并独占整个窗口
" :AV    ---切换头文件并垂直分割窗口
" :AS    ---切换头文件并水平分割窗口

" -----------------------------------------------------------------------------
"  < Mark--Karkat（也就是 Mark） 插件配置 >
" -----------------------------------------------------------------------------
" 给不同的单词不同颜色高亮

" -----------------------------------------------------------------------------
"  < ctrlp.vim 插件配置 >
" -----------------------------------------------------------------------------
" 一个全路径模糊文件，缓冲区，最近最多使用，... 检索插件；详细帮助见 :h ctrlp
" 常规模式下输入：Ctrl + p 调用插件

" -----------------------------------------------------------------------------
"  < cSyntaxAfter 插件配置 >
" -----------------------------------------------------------------------------
" 高亮括号与运算符等
autocmd! BufRead,BufNewFile,BufEnter *.{c,cpp,h,javascript} call CSyntaxAfter()

" -----------------------------------------------------------------------------
"  < Syntastic 插件配置 >
" -----------------------------------------------------------------------------
" 用于保存文件时显示详细错误描述

" -----------------------------------------------------------------------------
"  < neocomplcache 插件配置 >
" -----------------------------------------------------------------------------
" 代码自动补全
let g:neocomplcache_enable_at_startup = 1   "打开vim时自动打开

" -----------------------------------------------------------------------------
"  < SrcExpl 插件配置 >
" -----------------------------------------------------------------------------
" 增强源代码浏览，其功能就像Windows中的"Source Insight"
" 常规模式下输入 F9 调用插件
nmap <F9> :SrcExplToggle<CR>                "打开/关闭浏览窗口

"避免冲突
let g:SrcExpl_pluginList = [ 
            \ "__Tag_List__", 
            \ "_NERD_tree_" 
            \ ] 


let g:SrcExpl_isUpdateTags = 0              "不要在打开的时候更新tag文件

"let g:SrcExpl_jumpKey = "<ENTER>"          "ENTER键跳转到定义	使用ctags ctrl+]

"let g:SrcExpl_gobackKey = "<BACKSPACE>"    "BACKSpace键跳回代码文件	使用ctags ctrl+t

" -----------------------------------------------------------------------------
"  < TagList 插件配置 >
" -----------------------------------------------------------------------------
" 高效地浏览源码, 其功能就像vc中的workpace
" 那里面列出了当前文件中的所有宏,全局变量, 函数名等

" 常规模式下输入 F11 调用插件
nmap <F11> :TlistToggle<CR>

let Tlist_Show_One_File=1                   "只显示当前文件的tags
"let Tlist_Enable_Fold_Column=0              "使taglist插件不显示左边的折叠行
let Tlist_Exit_OnlyWindow=1                 "如果Taglist窗口是最后一个窗口则退出Vim
"let Tlist_File_Fold_Auto_Close=1            "自动折叠
let Tlist_WinWidth=30                       "设置窗口宽度
let Tlist_Use_Right_Window=1                "在右侧窗口中显示
let Tlist_Auto_Open = 1                     "默认开启

" -----------------------------------------------------------------------------
"  < cscope 工具配置 >
" -----------------------------------------------------------------------------
" 用Cscope自己的话说 - "你可以把它当做是超过频的ctags"
if has("cscope")
    "设定可以使用 quickfix 窗口来查看 cscope 结果
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    "使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转
    set cscopetag
    "如果你想反向搜索顺序设置为1
    set csto=0
    "在当前目录中添加任何数据库
    if filereadable("cscope.out")            "cscope -Rbq 生成 cscope.out 文件
        cs add cscope.out
        "否则添加数据库环境中所指出的
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose
    "快捷键设置
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" -----------------------------------------------------------------------------
"  < nerdtree 插件配置 >
" -----------------------------------------------------------------------------
" 有目录村结构的文件浏览插件

" 常规模式下输入 F10 调用插件
nmap <F10> :NERDTreeToggle<CR>
"默认是水平编辑，s是垂直编辑


" -----------------------------------------------------------------------------
"  < CTags 插件配置 >
" -----------------------------------------------------------------------------
" 常规模式下输入 F12 更新tag文件
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>	"更新tag文件
set tags=tags;                              "设置tag文件的搜索路径
"set tags+=/usr/tags                        "增加tag文件的搜索路径
"set autochdir                              "自动改变vim的当前目录为打开的文件所在目录

" -----------------------------------------------------------------------------
"  < vim-gitgutter 插件配置 >
" -----------------------------------------------------------------------------
let g:gitgutter_enabled = 1                 "自动启动

let g:gitgutter_highlight_lines = 1         "默认高亮


" -----------------------------------------------------------------------------
"  < vim-airline 插件配置 >
" -----------------------------------------------------------------------------
"炫酷的状态栏
set laststatus=2


" -----------------------------------------------------------------------------
"  < bufexplorer 插件配置 >
" -----------------------------------------------------------------------------
"切换同时打开多个文件
" 常规模式下输入 F3 调用插件
nmap <F3> \be
"\bs	水平窗口打开列表
"\bv　　垂直窗口打开列表。


" =============================================================================
"                          << 以下为配置命令查询>>
" =============================================================================
"<F2>	切换头文件
"<F3>	切换同时打开多个文件

"<F9>	打开/关闭定义窗口
"<F10>	打开/关闭目录窗口
"<F11>	打开/关函元素列表窗口
"<F12>	更新tag文件

"切换窗口 Ctrl + w 按一次加上下键可以自己选择切换方向(默认)
"ctrl + hjkl 四个方向窗口切换

"ctrl + p	搜索文件打开

"空格	开关折叠

"=== 高亮命令 ===
"\m 	高亮当前词
"\r 	高亮输入词
"*		向后跳转高亮
"#		向前跳转高亮
":MarkClear	清除所有高亮

":nohl	取消搜索高亮

"=== 格式化 ===
"=: 	一行
"gg=G 	整个文件

"=== 光标行移动 ===
"zt	光标行置顶
"zz	光标行置中
"zb 光标行置底

"=== ctags 命令 ===
"ctrl+]	执行跳转
"ctrl+t 跳转回来

