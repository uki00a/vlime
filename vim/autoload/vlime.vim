function! vlime#New()
    let obj = {
                \ 'channel': v:null,
                \ 'repl_package': v:null,
                \ 'repl_prompt': v:null,
                \ 'Connect': function('vlime#Connect'),
                \ 'Close': function('vlime#Close'),
                \ 'Call': function('vlime#Call'),
                \ 'Send': function('vlime#Send'),
                \ 'ConnectionInfo': function('vlime#ConnectionInfo'),
                \ 'SwankRequire': function('vlime#SwankRequire'),
                \ 'CreateREPL': function('vlime#CreateREPL'),
                \ 'ListenerEval': function('vlime#ListenerEval'),
                \ 'Interrupt': function('vlime#Interrupt'),
                \ 'SLDBAbort': function('vlime#SLDBAbort'),
                \ 'SLDBContinue': function('vlime#SLDBContinue'),
                \ 'OnServerEvent': function('vlime#OnServerEvent'),
                \ 'server_event_handlers': {
                    \ 'NEW-PACKAGE': function('vlime#OnNewPackage')
                    \ }
                \ }
    return obj
endfunction

" ================== methods for vlime connections ==================

function! vlime#Connect(host, port) dict
    let self.channel = ch_open(
                \ a:host . ':' . string(a:port),
                \ {'mode': 'json',
                \  'callback': {chan, msg -> self.OnServerEvent(chan, msg)}})
    if ch_status(self.channel) != 'open'
        call self.Close()
        throw 'vlime#Connect: failed to open channel'
    endif
    return self
endfunction

function! vlime#Close() dict
    if type(self.channel) == v:t_channel
        try
            call ch_close(self.channel)
        catch /^Vim\%((\a\+)\)\=:E906/  " Not an open channel
        endtry
        let self.channel = v:null
    endif
    return self
endfunction

function! vlime#Call(msg) dict
    return ch_evalexpr(self.channel, a:msg)
endfunction

" vlime#Send(msg[, callback])
function! vlime#Send(msg, ...) dict
    let options = {}
    if a:0 == 1
        let options['callback'] = a:1
    elseif a:0 != 0
        throw 'vlime#Send: wrong # of arguments'
    endif

    if len(options) > 0
        call ch_sendexpr(self.channel, a:msg, options)
    else
        call ch_sendexpr(self.channel, a:msg)
    endif
endfunction

" vlime#ConnectionInfo([return_dict])
function! vlime#ConnectionInfo(...) dict
    let raw = self.Call(s:EmacsRex(
                \ [s:SYM('SWANK', 'CONNECTION-INFO')], v:null, v:true))
    call s:CheckReturnStatus(raw, 'vlime#ConnectionInfo')

    let return_dict = v:true
    if a:0 == 1
        let return_dict = a:1
    elseif a:0 != 0
        throw 'vlime#ConnectionInfo: wrong # of arguments'
    endif

    if return_dict
        return s:PListToDict(raw[1][1])
    else
        return raw[1][1]
    endif
endfunction

function! vlime#SwankRequire(contrib) dict
    let raw = self.Call(s:EmacsRex(
                \ [s:SYM('SWANK', 'SWANK-REQUIRE'), s:KW(a:contrib)],
                \ v:null, v:true))
    call s:CheckReturnStatus(raw, 'vlime#SwankRequire')
    return raw
endfunction

" vlime#CreateREPL([coding_system])
function! vlime#CreateREPL(...) dict
    let cmd = [s:SYM('SWANK-REPL', 'CREATE-REPL'), v:null]
    if a:0 == 1
        let cmd += [s:KW('CODING-SYSTEM'), a:1]
    elseif a:0 != 0
        throw 'vlime#CreateREPL: wrong # of arguments'
    endif
    let raw = self.Call(s:EmacsRex(cmd, v:null, v:true))
    call s:CheckReturnStatus(raw, 'vlime#CreateREPL')
    let self.repl_package = raw[1][1][0]
    let self.repl_prompt = raw[1][1][1]
    return raw[1][1]    " [PACKAGE_NAME, PROMPT]
endfunction

function! vlime#ListenerEval(expr) dict
    let raw = self.Call(s:EmacsRex(
                \ [s:SYM('SWANK-REPL', 'LISTENER-EVAL'), a:expr],
                \ self.repl_package, v:true))
    call s:CheckReturnStatus(raw, 'vlime#ListenerEval')
    return raw[1][1]
endfunction

function! vlime#Interrupt(thread) dict
    call self.Send([s:KW('EMACS-INTERRUPT'), a:thread])
endfunction

function! vlime#SLDBAbort(thread) dict
    return self.Call(s:EmacsRex(
                \ [s:SYM('SWANK', 'SLDB-ABORT')], v:null, a:thread))
endfunction

function! vlime#SLDBContinue(thread) dict
    return self.Call(s:EmacsRex(
                \ [s:SYM('SWANK', 'SLDB-CONTINUE')], v:null, a:thread))
endfunction

" ------------------ server event handlers ------------------

function! vlime#OnNewPackage(conn, msg)
    let a:conn.repl_package = a:msg[1]
    let a:conn.repl_prompt = a:msg[2]
endfunction

" ------------------ end of server event handlers ------------------

function! vlime#OnServerEvent(chan, msg) dict
    let chan_info = ch_info(self.channel)
    echom chan_info['hostname'] . ':' . chan_info['port'] .
                \ ' -> ' . string(a:msg)
    let msg_type = a:msg[0]
    let Handler = get(self.server_event_handlers, msg_type['name'], v:null)
    if type(Handler) == v:t_func
        call Handler(self, a:msg)
    endif
endfunction

" ================== end of methods for vlime connections ==================

function! s:PListToDict(plist)
    let d = {}
    let i = 0
    while i < len(a:plist)
        let d[a:plist[i]['name']] = a:plist[i+1]
        let i += 2
    endwhile
    return d
endfunction

function! s:SearchPList(plist, name)
    let i = 0
    while i < len(a:plist)
        if a:plist[i]['name'] == a:name
            return a:plist[i+1]
        endif
        let i += 2
endfunction

function! s:CheckReturnStatus(return_msg, caller)
    let status = a:return_msg[1][0]
    if status['name'] != 'OK'
        throw a:caller . ' returned: ' . a:return_msg[1]
    endif
endfunction

function! s:SYM(package, name)
    return {'name': a:name, 'package': a:package}
endfunction

function! s:KW(name)
    return s:SYM('KEYWORD', a:name)
endfunction

function! s:CL(name)
    return s:SYM('COMMON-LISP', a:name)
endfunction

function! s:EmacsRex(cmd, pkg, thread)
    return [s:KW('EMACS-REX'), a:cmd, a:pkg, a:thread]
endfunction
