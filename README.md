# sessionmanager.vim

## Introduction
sessionmanager.vim is a simple session management plugin for vim. It saves one,
and only one session into your `~/.vim` directory when you close the editor and 
loads the previous session in once you open vim again.

When I searched for a simple vim session management solution, I didn't find a 
plugin simple enough, but was inspired by some simpler solutions in a few lines
of code that I found online (*> Inspiration*), fixed some bugs and extended the 
solution to work across different platforms and to better suit my preferences.

## Usage
After copying the plugin file into the plugin folder, the plugin will 
automatically start managing your session. The `.vim` or the `vimfiles` folder
has to exist, because the plugin saves the session into this directory.

If you want to save the session manually you can use the command `SaveSession`
and if you want to set an autocommand to another event you can do that as well
(by default the session is only saved when the leave event is triggered, this 
can be a problem if vim closes unexpectedly).

## Inspiration
Heavy inspiration was taken from:

 - [markw on StackOverflow](https://stackoverflow.com/questions/5142099/how-to-auto-save-vim-session-on-quit-and-auto-reload-on-start-including-split-wi/6052704)
 - [LCD 47 on vim Google Group](https://groups.google.com/forum/#!topic/vim_use/0jaFyy5LR7A)

## TODO
 - Not open empty buffers in new tabs on startup

