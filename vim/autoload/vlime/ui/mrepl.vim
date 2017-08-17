function! vlime#ui#mrepl#InitMREPLBuf(conn, chan_obj)
    let mrepl_buf = bufnr(vlime#ui#MREPLBufName(a:conn, a:chan_obj), v:true)
    if !vlime#ui#VlimeBufferInitialized(mrepl_buf)
        call vlime#ui#SetVlimeBufferOpts(mrepl_buf, a:conn)
        call setbufvar(mrepl_buf, 'vlime_mrepl_channel', a:chan_obj)
        call setbufvar(mrepl_buf, '&filetype', 'vlime_mrepl')
        call vlime#ui#WithBuffer(mrepl_buf, function('s:InitMREPLBuf'))
    endif
    return mrepl_buf
endfunction

function! vlime#ui#mrepl#ShowPrompt(buf, prompt)
    call vlime#ui#WithBuffer(a:buf, function('s:ShowPromptOrResult', [a:prompt]))
endfunction

function! vlime#ui#mrepl#ShowResult(buf, result)
    call vlime#ui#WithBuffer(a:buf, function('s:ShowPromptOrResult', [a:result]))
endfunction

function! s:ShowPromptOrResult(content)
    let last_line = getline('$')
    if len(last_line) > 0
        call vlime#ui#AppendString("\n" . a:content)
    else
        call vlime#ui#AppendString(a:content)
    endif
endfunction

function! s:InitMREPLBuf()
    setlocal nocindent
    call vlime#ui#MapBufferKeys('mrepl')
endfunction

function! vlime#ui#mrepl#Submit()
    let read_mode = b:vlime_mrepl_channel['mrepl']['mode']
    if read_mode == 'EVAL'
        let prompt = vlime#contrib#mrepl#BuildPrompt(b:vlime_mrepl_channel)
        let old_pos = getcurpos()
        try
            normal! G$
            let eof_pos = getcurpos()
            let last_prompt_pos = searchpos('\V' . prompt, 'bcenW')
        finally
            call setpos('.', old_pos)
        endtry

        let last_prompt_pos[1] += 1
        let to_send = vlime#ui#GetText(last_prompt_pos, eof_pos[1:2])
    elseif read_mode == 'READ'
        let last_line = getline('$')
        if len(last_line) <= 0
            let last_line = getline(line('$') - 1)
        endif
        let to_send = last_line . "\n"
    endif

    let msg = b:vlime_conn.EmacsChannelSend(
                \ b:vlime_mrepl_channel['mrepl']['peer'],
                \ [vlime#KW('PROCESS'), to_send])
    call b:vlime_conn.Send(msg)

    return ''
endfunction