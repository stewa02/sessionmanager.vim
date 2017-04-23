" Small session management plugin.
" Last change:   23.04.2017
" Version:       V1.2.1
" Maintainer:    stewa02 <stewatwo@cpan.org>
" License:       This plugin is distributed under the Vim-license.

" Do not load, if loaded already
if exists("g:loaded_sessionmanager") || v:version < 703
    finish
endif
let g:loaded_sessionmanager = 1

" Save configuration and replace them with defaults (line-continuation)
let s:save_cpo = &cpo
set cpo&vim

" This option makes session files compatible between MS Windows and *nix based
" systems that use the forward slash "/" instead of the backslash "\". This
" option uses the forward slash on all systems inside the session files.
set sessionoptions+=unix,slash

" Here we define two new plugin specific highlight groups, one for the "loaded
" session successfully" (green font colour) and one for the "no session"
" message (red font colour).
highlight SessionmanagerNoSession ctermfg=red guifg=#B40404 cterm=bold gui=bold
highlight SessionmanagerLoaded ctermfg=green guifg=#04B404 cterm=bold gui=bold

" Creates a personal directory for your vim files. It creates the folder 
" ~/.vim on *nix and ~/vimfiles on Microsoft Windows. 
" Reference: http://vimdoc.sourceforge.net/htmldoc/options.html#vimfiles
if has("win32") || has("win16")
    if !isdirectory($HOME."/vimfiles")
        call mkdir($HOME."/vimfiles", "p")
    endif
elseif has("unix") || has("linux") || has("mac") || has("macunix")
    if !isdirectory($HOME."/.vim")
        call mkdir($HOME."/.vim", "p")
    endif
endif

" Function that determines if a certain buffer is active in any of the open
" tabs. This is necessary, because bufwinnr() only returns the correct answer
" if you are in the corresponding tab.
" Reference: https://groups.google.com/forum/#!topic/vim_use/0jaFyy5LR7A
function! s:BufInTab(bufnr)
    for l:tabnr in range(1,tabpagenr("$"))
        if index(tabpagebuflist(l:tabnr), a:bufnr) != -1
            return 0
        endif
    endfor
    return 1
endfunction

" Simply saves the current session into the personal .vim directory
function! s:SaveSess()
    if has("win32") || has("win16")
        execute "mksession! ~/vimfiles/session.vim"
    elseif has("unix") || has("linux") || has("mac") || has("macunix")
        execute "mksession! ~/.vim/session.vim"
    else
        echoerr "Operating system is not supported!"
    endif
endfunction

" Simply loads in the saved session. Is called by a autocommand at VimEnter.
" The magic after the source command is necessary to open all new files with
" which vim was called from the command line.
function! s:RestoreSess()
    if !empty(glob("~/.vim/session.vim")) ||
     \ !empty(glob("~/vimfiles/session.vim"))
        " Get argument list before loading session
        let l:arglist = []
        argdo call add(l:arglist, expand("%:p"))
        if has("win32") || has("win16")
            let l:time = strftime("%Y %b %d %X",getftime($HOME."/vimfiles/session.vim"))
            execute "source ~/vimfiles/session.vim"
        elseif has("unix") || has("linux") || has("mac") || has("macunix")
            let l:time = strftime("%Y %b %d %X",getftime($HOME."/.vim/session.vim"))
            execute "source ~/.vim/session.vim"
        else
            echoerr "Operating system is not supported!"
            return
        endif

        if !exists("g:sessionmanager_loadall")
            " Load arglist into seperate tabs
            for l:args in l:arglist
                tabnew
                execute ":buffer ".l:args
            endfor
        else
            " Load all hidden buffers into seperate tabs
            if bufexists(1)
                for l:bufnr in range(1, bufnr("$"))
                    if s:BufInTab(l:bufnr)
                        tabnew
                        execute ":b".l:bufnr
                    endif
                endfor
            endif
        endif
    endif

    if exists("l:time")
        " If there was a session file loaded, inform the user about the age of
        " the session (last modified time of the file).
        let l:message = "Session from ".l:time." loaded successfully!"
        echohl SessionmanagerLoaded
    else
        " If there is no session file do nothing and inform the user using 
        " ErrorMsg highlighting without requiring the user to press enter at
        " startup (making the error less special).
        let l:message = "No session file to load!"
        echohl SessionmanagerNoSession
    endif
    " Calling redraw *before* echoing the message ensures, that the message is
    " not wiped off the screen immediately afterwards.
    " Reference: http://vimdoc.sourceforge.net/htmldoc/eval.html#:echo-redraw
    redraw
    echomsg l:message
    echohl None
endfunction

" Create command if they don't exist
if !exists(":SaveSession") && !exists(":RestoreSession")
    command! SaveSession    call <SID>SaveSess()
    command! RestoreSession call <SID>RestoreSess()
else
    echoerr "No command created, because they already exist!"
endif

" Set up autocommands for autosave and autoload
augroup session
autocmd!
autocmd VimLeave * SaveSession
autocmd VimEnter * RestoreSession
augroup END

" Restore user settings
let &cpo = s:save_cpo

