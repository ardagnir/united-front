united-front
============

Automatically sync registers between vim instances.

> "Buffer separately, but yank together!"<br/>
> -- <i>Leon Robotsky</i>

This plugin will automatically share the registers of any and/or all vim instances.

All vim instances that you want to share registers need to be started in server mode.
GVim does this automatically, but terminal vim must be told to do this.

    vim --servername whateveryouwant

If you alias the vim command to always use a server, everything will be automatic and you can spend more time editing with your awesome new shared registers.

    alias vim="vim --servername robotsky"


##Installation
Use pathogen.

    cd ~/.vim/bundle
    git clone https://github.com/ardagnir/united-front

##License
united-front is licensed under the AGPL v3
