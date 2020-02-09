" Author: liuchengxu <xuliuchengxlc@gmail.com>
" Description: RPC-based grep.

scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:grep = {}

function! s:process_result(result) abort
  let result = a:result

  if has_key(result, 'lines')
    call g:clap.display.set_lines(result.lines)
    if !has_key(result, 'total')
      call g:clap#display_win.shrink_if_undersize()
      return
    endif
  endif

  if result.total == 0
    return
  endif

  call clap#indicator#refresh(result.total)
  let s:total = str2nr(result.total)
  call g:clap#display_win.shrink_if_undersize()
endfunction

function! s:handle_round_message(message) abort
  try
    let decoded = json_decode(a:message)
  catch
    " FIXME this is not robust.
    " call clap#helper#echo_error('Failed to decode message:'.a:message.', exception:'.v:exception)
    return
  endtry

  " Only process the latest request, drop the outdated responses.
  if s:last_request_id != decoded.id
    return
  endif

  if has_key(decoded, 'error')
    let error = decoded.error
    call g:clap.display.set_lines([error.message])
    call clap#indicator#set_matches('[??]')

  elseif has_key(decoded, 'result')
    call s:process_result(decoded.result)
  else
    call clap#helper#echo_error('This should not happen, neither error nor result is found.')
  endif
endfunction

function! s:send_message() abort
  let s:last_request_id += 1

  let query = g:clap.input.get()

  let msg = json_encode({
        \ 'method': 'grep',
        \ 'params': {
        \   'query': query,
        \   'enable_icon': s:enable_icon,
        \   'dir': clap#rooter#working_dir()
        \ },
        \ 'id': s:last_request_id
        \ })

  call clap#rpc#send_message(msg)

  if query !=# ''
    " Consistent with --smart-case of rg
    " Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise.
    let ignore_case = query =~# '\u' ? '\C' : '\c'
    let hl_pattern = ignore_case.'^.*\d\+:\d\+:.*\zs'.query
    call g:clap.display.add_highlight(hl_pattern)
  endif
endfunction

function! s:grep_sink(selected) abort
  if g:clap_enable_icon
    let curline = a:selected[4:]
  else
    let curline = a:selected
  endif
  echom 'selected:'.a:selected
endfunction

function! s:grep_on_typed() abort
  call clap#rpc#stop()
  call g:clap.display.clear_highlight()
  call s:start_rpc_service()
  return ''
endfunction

function! s:on_exit() abort
  if g:clap.display.winid != -1
    if s:total == 0
      if g:clap.display.get_lines() == [g:clap_no_matches_msg]
        return
      else
        call g:clap.display.set_lines([g:clap_no_matches_msg])
        call clap#indicator#refresh('0')
        call clap#sign#reset_to_first_line()
        call g:clap#display_win.shrink_if_undersize()
      endif
    else
      call clap#indicator#refresh(string(s:total))
    endif
  endif
endfunction

function! s:start_rpc_service() abort
  let s:last_request_id = 0
  let s:total = 0
  call clap#rpc#start_grep(function('s:handle_round_message'), function('s:on_exit'))
  call s:send_message()
endfunction

function! s:grep.init() abort
  let s:enable_icon = g:clap_enable_icon ? v:true : v:false
  call clap#rooter#try_set_cwd()
  call s:start_rpc_service()
endfunction

function! s:grep.on_exit() abort
  call clap#rpc#stop()
endfunction

let s:grep.sink = function('s:grep_sink')
let s:grep.syntax = 'clap_grep'
let s:grep.on_typed = function('s:grep_on_typed')
let s:grep.source_type = g:__t_rpc
let g:clap#provider#grep2# = s:grep

let &cpoptions = s:save_cpo
unlet s:save_cpo