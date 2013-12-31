united-front
============

United-front will automatically share the registers of any and/or all vim instances.

> "Buffer separately, but yank together!"<br/>
> -- <i>Leon Robotsky</i>

All vim instances that you want to share registers need to be started in server mode.
GVim does this automatically, but terminal vim must be told to do this.

    vim --servername whateveryouwant

If you alias the vim command to always use a server, everything will be automatic and you can spend more time editing with your awesome new shared registers.

    alias vim="vim --servername robotsky"

If you only want some of your vim servers united, only source united-front for those vim servers.

##Installation
From your shell, with [pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/ardagnir/united-front
    
Or from within vim, using [vizardry](https://github.com/ardagnir/vizardry)</a>:

    :Invoke united-front

##Notes
- United-front will create a file $HOME/.unitedfront that is used to sync registers.
- United-front will lower vim's updatetime. Updatetime is also used for vim's swap files, so this has the side effect of increasing how often your swap files are saved.

##License
United-front is licensed under the AGPL v3
