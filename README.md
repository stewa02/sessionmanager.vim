# sessionmanager.vim

## Introduction
sessionmanager.vim is a simple session management plugin for vim. It saves one,
and only one session into your `~/.vim` directory when you close the editor and 
loads the previous session in once you open vim again.

When I searched for a simple vim session management solution, I didn't find a 
plugin simple enough, but was inspired by some simpler solutions in a few lines
of code that I found online, fixed some bugs and extended the solution to work 
across different platforms and to better suit my preferences.

## Usage
After copying the plugin file into the plugin folder, the plugin will 
automatically start managing your session. The `.vim` or the `vimfiles` folder
has to exist, because the plugin saves the session into this directory. It 
saves you session when you leave the editor into `$VIMDIR/session.vim` and 
reloads that session on start-up. All new files from the command line will be 
opened into a new tab.

If you want to save the session manually you can use the command `SaveSession`
and if you want to set an autocommand to another event you can do that as well
(by default the session is only saved when the leave event is triggered, this 
can be a problem if vim closes unexpectedly).

That could look something like:
```vim
augroup AddedSessionEvents
    autocmd!
    autocmd BufEnter * SaveSession
augroup END
```

If you for some reason want to load a session manually you can set up a mapping
to the `RestoreSession` command, even if I don't see why you should want to do
that.

That could look something like:
```vim
nnoremap <leader>r :RestoreSession<CR>
```

At the moment the plugin is not configurable. Maybe this will change with my 
personal usage or preferences.

## TODO
 - ~~Show which session (last modified timestamp) was loaded after startup~~
 - ~~Automatically create necessary folders, if they do not already exist~~

