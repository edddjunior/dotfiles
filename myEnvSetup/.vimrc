""
"" SETTINGS
""

"Disable mouse
nnoremap <ScrollWheelUp> <nop>
nnoremap <S-ScrollWheelUp> <nop>
nnoremap <C-ScrollWheelUp> <nop>
nnoremap <ScrollWheelDown> <nop>
nnoremap <S-ScrollWheelDown> <nop>
nnoremap <C-ScrollWheelDown> <nop>
nnoremap <ScrollWheelLeft> <nop>
nnoremap <S-ScrollWheelLeft> <nop>
nnoremap <C-ScrollWheelLeft> <nop>
nnoremap <ScrollWheelRight> <nop>
nnoremap <S-ScrollWheelRight> <nop>
nnoremap <C-ScrollWheelRight> <nop>
set mouse-=a

" Disable arrows
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" Defines the external ack-like program which CtrlSF uses as source
" If nothing is specified, CtrlSF will try ag first and fallback to ack if ag is not available
let g:ctrlsf_ackprg = 'ag'

""
"" APPEARANCE
""

" Keeps right color scheme in vim with tmux
set background=dark

" Relative line numbers
set relativenumber

" Ident line conf
let g:indentLine_char = '▏'

" Highlights current line for easy reading
set cursorline
hi cursorline cterm=none term=none
hi CursorLine ctermbg=237

" Autocomplete (added because of css syntax)
filetype plugin on
set omnifunc=syntaxcomplete#Complete

""
"" ALIASES
""

" Maps 'ctrl + l' to clean find highlights
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" Maps <leader + p> to toggle NerdTree
silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>
