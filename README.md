united-front
============

Automatically share registers between vim instances.

> Buffer separately, but yank together!
> -Leon Robotsky

This plugin will automatically share the registers of any and/or all vim instances.

All vim instances that you want sharing a terminal need to be started in server mode. GVim does this automatically, but all other versions of vim must be told to start in server mode.
    vim --servername whateveryouwant

If you alias the vim command to always use a server everything will be automatic and you can spend more time editing with your awesome new sharable buffers.
    alias vim="vim --servername robotsky"


<H5>Installation</H5>
Use pathogen.
    cd ~/.vim/bundles
    git clone https://github.com/ardagnir/united-front

<H5>License</H5>
united-front is licensed under the AGPL v3
