" Vim plugin for automatically sharing registers between vim instances.
" Last Change: Sep 19 2013
" Maintainer: James Kolb
"
" Copyright (C) 2013, James Kolb. All rights reserved.
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU Affero General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
" 
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU Affero General Public License for more details.
" 
" You should have received a copy of the GNU Affero General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

let g:save_cpo = &cpo
set cpo&vim
if exists("g:loaded_unitedFront")
  finish
endif
let g:loaded_unitedFront = 1

"Updates pretty much as soon as we stop typing.
"Note that this saves our registers, but it also saves the swp
set updatetime=200

augroup UnitedFront
  autocmd! CursorHold
  autocmd! VimEnter
  autocmd! FocusLost
  autocmd FocusLost * call s:SwitchToFocusMode()
  autocmd CursorHold * call s:SendVimInfo()
  autocmd VimEnter * call s:SendVimInfo()
augroup END

"If this version of vim supports focus detection, use that instead so we don't need to
"send updates as often.
function! s:SwitchToFocusMode(gained)
  augroup UnitedFront
    autocmd! CursorHold
    autocmd! FocusLost
    autocmd FocusLost * call s:SendVimInfo()
  augroup END
endfunction

function! s:SendVimInfo()
  let differences=[]
  for r in keys(s:savedRegs)
    if s:UpdateSavedReg(r)
      let differences+=[r]
    endif
  endfor
  if len(differences)
    call s:WriteFrontFile()
    for x in split(serverlist(),"\n")
      if x !=? v:servername && v:servername !=""
        exec 'silent !vim --servername '.x.' --remote-send "<C-\\><C-N>:call UnitedFront_ReadFrontFile()<CR>:echo \"\"<CR>"'
      endif
    endfor
  endif
endfunction

function! s:WriteFrontFile()
  call writefile(s:PackRegs(s:savedRegs), '/home/gandalf/.unitedfront')
endfunction

"This can't be script local because it is called over the server
function! UnitedFront_ReadFrontFile()
  let reglines = readfile('/home/gandalf/.unitedfront')
  let s:savedRegs = s:UnpackRegs(join(reglines, "\n"))
  for r in keys(s:savedRegs)
    call setreg(r, s:savedRegs[r][1], s:savedRegs[r][0])
  endfor
endfunction

function! s:PackRegs(regs)
  let outputlist=[]
  for r in items(a:regs)
    let outputlist+=[s:EscapePercents(r[0])]
    let outputlist+=['%']
    let outputlist+=[s:EscapePercents(r[1][0])]
    let outputlist+=['%']
    let outputlist+=[s:EscapePercents(r[1][1])]
    let outputlist+=['%']
  endfor
  return outputlist
endfunction

function! s:UnpackRegs(regs)
  let returnVal={}
  let regInfoList=split(a:regs,"\n%\n")
  let index=0
  while index < len(regInfoList)
      let returnVal[s:UnescapePercents(regInfoList[index])] =
            \ [s:UnescapePercents(regInfoList[index+1]),
            \  s:UnescapePercents(regInfoList[index+2])]
      let index+=3
  endwhile
  return returnVal
endfunction

function! s:EscapePercents(string)
  return substitute(a:string,'%','\\%',"g")
endfunction

function! s:UnescapePercents(string)
  return substitute(a:string,'\\%','%',"g")
endfunction

function! s:UpdateSavedReg(regName)
  let tempReg=getreg(a:regName,1)
  let tempType=getregtype(a:regName)
  let ret = (tempReg!=s:savedRegs[a:regName][1] || tempType!=s:savedRegs[a:regName][0])
  let s:savedRegs[a:regName][0] = tempType
  let s:savedRegs[a:regName][1] = tempReg
  return ret
endfunction

let s:savedRegs=
      \ {
      \ '"': ['', ''],
      \ '0': ['', ''],
      \ '1': ['', ''],
      \ '2': ['', ''],
      \ '3': ['', ''],
      \ '4': ['', ''],
      \ '5': ['', ''],
      \ '6': ['', ''],
      \ '7': ['', ''],
      \ '8': ['', ''],
      \ '9': ['', ''],
      \ 'a': ['', ''],
      \ 'b': ['', ''],
      \ 'c': ['', ''],
      \ 'd': ['', ''],
      \ 'e': ['', ''],
      \ 'f': ['', ''],
      \ 'g': ['', ''],
      \ 'h': ['', ''],
      \ 'i': ['', ''],
      \ 'j': ['', ''],
      \ 'k': ['', ''],
      \ 'l': ['', ''],
      \ 'm': ['', ''],
      \ 'n': ['', ''],
      \ 'o': ['', ''],
      \ 'p': ['', ''],
      \ 'q': ['', ''],
      \ 'r': ['', ''],
      \ 's': ['', ''],
      \ 't': ['', ''],
      \ 'u': ['', ''],
      \ 'v': ['', ''],
      \ 'w': ['', ''],
      \ 'x': ['', ''],
      \ 'y': ['', ''],
      \ 'z': ['', ''],
      \ '/': ['', '']
      \ }

      "these would be silly
      "\ '=': ['', ''],
      "\ '_': ['', ''],
      
      "these should already be synced
      "\ '*': ['', ''],
      "\ '+': ['', ''],

      "it won't let me do these
      "\ '#': ['', ''],
      "\ ':': ['', ''],
      "\ '.': ['', ''],
      "\ '%': ['', ''],
      "\ '~': ['', ''],


let &cpo = g:save_cpo
unlet g:save_cpo
