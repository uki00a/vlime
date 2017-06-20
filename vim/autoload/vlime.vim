""
" @dict VlimeConnection
" Vlime uses connection objects (dictionaries) to represent connections to the
" servers. You can create such an object by calling
" @function(vlime#plugin#ConnectREPL) or @function(vlime#New).
"
" Most of the connection object's methods are asynchronous. All async methods
" have an optional callback argument, to allow a function be registered for
" handling the result returned by the server. These callback functions should
" accept two arguments:
"
"     function! SomeCallbackFunc({conn_obj}, {result}) ...
"
" {conn_obj} is the connection object in question, and {result} is the
" returned value.
"
" See below for a detailed list of methods for connection objects.
"

""
" @usage [cb_data] [ui]
" @public
"
" Create a connection object.
"
" [cb_data] is arbitrary data, accessible from the connection callbacks.
" [ui] is an instance of the UI object, see @function(vlime#ui#New).
"
" This function is seldom used directly. To connect to a server, call
" @function(vlime#plugin#ConnectREPL).
function! vlime#New(...)
    let cb_data = get(a:000, 0, v:null)
    let ui = get(a:000, 1, v:null)
    let obj = {
                \ 'cb_data': cb_data,
                \ 'channel': v:null,
                \ 'remote_prefix': '',
                \ 'ping_tag': 1,
                \ 'ui': ui,
                \ 'Connect': function('vlime#Connect'),
                \ 'IsConnected': function('vlime#IsConnected'),
                \ 'Close': function('vlime#Close'),
                \ 'Call': function('vlime#Call'),
                \ 'Send': function('vlime#Send'),
                \ 'FixRemotePath': function('vlime#FixRemotePath'),
                \ 'FixLocalPath': function('vlime#FixLocalPath'),
                \ 'GetCurrentPackage': function('vlime#GetCurrentPackage'),
                \ 'SetCurrentPackage': function('vlime#SetCurrentPackage'),
                \ 'GetCurrentThread': function('vlime#GetCurrentThread'),
                \ 'SetCurrentThread': function('vlime#SetCurrentThread'),
                \ 'WithPackage': function('vlime#WithPackage'),
                \ 'WithThread': function('vlime#WithThread'),
                \ 'EmacsRex': function('vlime#EmacsRex'),
                \ 'Ping': function('vlime#Ping'),
                \ 'Pong': function('vlime#Pong'),
                \ 'ConnectionInfo': function('vlime#ConnectionInfo'),
                \ 'SwankRequire': function('vlime#SwankRequire'),
                \ 'CreateREPL': function('vlime#CreateREPL'),
                \ 'ListenerEval': function('vlime#ListenerEval'),
                \ 'SetPackage': function('vlime#SetPackage'),
                \ 'DescribeSymbol': function('vlime#DescribeSymbol'),
                \ 'OperatorArgList': function('vlime#OperatorArgList'),
                \ 'SimpleCompletions': function('vlime#SimpleCompletions'),
                \ 'FuzzyCompletions': function('vlime#FuzzyCompletions'),
                \ 'ReturnString': function('vlime#ReturnString'),
                \ 'Return': function('vlime#Return'),
                \ 'SwankMacroExpandOne': function('vlime#SwankMacroExpandOne'),
                \ 'SwankMacroExpand': function('vlime#SwankMacroExpand'),
                \ 'SwankMacroExpandAll': function('vlime#SwankMacroExpandAll'),
                \ 'DisassembleForm': function('vlime#DisassembleForm'),
                \ 'CompileStringForEmacs': function('vlime#CompileStringForEmacs'),
                \ 'CompileFileForEmacs': function('vlime#CompileFileForEmacs'),
                \ 'LoadFile': function('vlime#LoadFile'),
                \ 'XRef': function('vlime#XRef'),
                \ 'FindDefinitionsForEmacs': function('vlime#FindDefinitionsForEmacs'),
                \ 'AproposListForEmacs': function('vlime#AproposListForEmacs'),
                \ 'DocumentationSymbol': function('vlime#DocumentationSymbol'),
                \ 'Interrupt': function('vlime#Interrupt'),
                \ 'SLDBAbort': function('vlime#SLDBAbort'),
                \ 'SLDBBreak': function('vlime#SLDBBreak'),
                \ 'SLDBContinue': function('vlime#SLDBContinue'),
                \ 'SLDBStep': function('vlime#SLDBStep'),
                \ 'SLDBNext': function('vlime#SLDBNext'),
                \ 'SLDBOut': function('vlime#SLDBOut'),
                \ 'SLDBReturnFromFrame': function('vlime#SLDBReturnFromFrame'),
                \ 'SLDBDisassemble': function('vlime#SLDBDisassemble'),
                \ 'InvokeNthRestartForEmacs': function('vlime#InvokeNthRestartForEmacs'),
                \ 'RestartFrame': function('vlime#RestartFrame'),
                \ 'FrameLocalsAndCatchTags': function('vlime#FrameLocalsAndCatchTags'),
                \ 'FrameSourceLocation': function('vlime#FrameSourceLocation'),
                \ 'EvalStringInFrame': function('vlime#EvalStringInFrame'),
                \ 'InitInspector': function('vlime#InitInspector'),
                \ 'InspectorReinspect': function('vlime#InspectorReinspect'),
                \ 'InspectorRange': function('vlime#InspectorRange'),
                \ 'InspectNthPart': function('vlime#InspectNthPart'),
                \ 'InspectorCallNthAction': function('vlime#InspectorCallNthAction'),
                \ 'InspectorPop': function('vlime#InspectorPop'),
                \ 'InspectorNext': function('vlime#InspectorNext'),
                \ 'InspectCurrentCondition': function('vlime#InspectCurrentCondition'),
                \ 'InspectInFrame': function('vlime#InspectInFrame'),
                \ 'InspectPresentation': function('vlime#InspectPresentation'),
                \ 'ListThreads': function('vlime#ListThreads'),
                \ 'KillNthThread': function('vlime#KillNthThread'),
                \ 'DebugNthThread': function('vlime#DebugNthThread'),
                \ 'UndefineFunction': function('vlime#UndefineFunction'),
                \ 'UninternSymbol': function('vlime#UninternSymbol'),
                \ 'OnServerEvent': function('vlime#OnServerEvent'),
                \ 'server_event_handlers': {
                    \ 'PING': function('vlime#OnPing'),
                    \ 'NEW-PACKAGE': function('vlime#OnNewPackage'),
                    \ 'DEBUG': function('vlime#OnDebug'),
                    \ 'DEBUG-ACTIVATE': function('vlime#OnDebugActivate'),
                    \ 'DEBUG-RETURN': function('vlime#OnDebugReturn'),
                    \ 'WRITE-STRING': function('vlime#OnWriteString'),
                    \ 'READ-STRING': function('vlime#OnReadString'),
                    \ 'READ-FROM-MINIBUFFER': function('vlime#OnReadFromMiniBuffer'),
                    \ 'INDENTATION-UPDATE': function('vlime#OnIndentationUpdate'),
                    \ 'INVALID-RPC': function('vlime#OnInvalidRPC'),
                    \ 'INSPECT': function('vlime#OnInspect'),
                    \ }
                \ }
    return obj
endfunction

" ================== methods for vlime connections ==================

""
" @dict VlimeConnection.Connect
" @usage {host} {port} [remote_prefix] [timeout]
" @public
"
" Connect to a server.
"
" {host} and {port} specify the server to connect to.
" [remote_prefix], if specified, is an SFTP URL prefix, to tell Vlime to open
" remote files via SFTP (see |vlime-remote-server|).
" [timeout] is the time to wait for the connection to be made, in
" milliseconds.
function! vlime#Connect(host, port, ...) dict
    let remote_prefix = get(a:000, 0, '')
    let timeout = get(a:000, 1, v:null)

    let self.channel = vlime#compat#ch_open(a:host, a:port,
                \ {chan, msg -> self.OnServerEvent(chan, msg)},
                \ timeout)
    if vlime#compat#ch_status(self.channel) != 'open'
        call self.Close()
        throw 'vlime#Connect: failed to open channel'
    endif

    let self['remote_prefix'] = remote_prefix

    return self
endfunction

""
" @dict VlimeConnection.IsConnected
" @public
"
" Return |TRUE| for a connected connection, |FALSE| otherwise.
function! vlime#IsConnected() dict
    return type(self.channel) == vlime#compat#ch_type() &&
                \ vlime#compat#ch_status(self.channel) == 'open'
endfunction

""
" @dict VlimeConnection.Close
" @public
"
" Close this connection.
function! vlime#Close() dict
    if type(self.channel) == vlime#compat#ch_type()
        try
            call vlime#compat#ch_close(self.channel)
        catch /^vlime#compat#.*not an open channel.*/
        endtry
        let self.channel = v:null
    endif
    return self
endfunction

""
" @dict VlimeConnection.Call
" @public
"
" Send a raw message {msg} to the server, and wait for a reply.
function! vlime#Call(msg) dict
    return vlime#compat#ch_evalexpr(self.channel, a:msg)
endfunction

""
" @dict VlimeConnection.Send
" @usage {msg} [callback]
" @public
"
" Send a raw message {msg} to the server, and optionally register an async
" [callback] function to handle the reply.
function! vlime#Send(msg, ...) dict
    let Callback = get(a:000, 0, v:null)
    if type(Callback) != type(v:null)
        call vlime#compat#ch_sendexpr(self.channel, a:msg, Callback)
    else
        call vlime#compat#ch_sendexpr(self.channel, a:msg)
    endif
endfunction

""
" @dict VlimeConnection.FixRemotePath
" @public
"
" Fix the remote file paths after they are received from the server, so that
" Vim can open the files via SFTP.
" {path} can be a plain string or a Swank source location object.
function! vlime#FixRemotePath(path) dict
    if type(a:path) == v:t_string
        return self['remote_prefix'] . a:path
    elseif type(a:path) == v:t_list && type(a:path[0]) == v:t_dict
                \ && a:path[0]['name'] == 'LOCATION'
        if a:path[1][0]['name'] == 'FILE'
            let a:path[1][1] = self['remote_prefix'] . a:path[1][1]
        elseif a:path[1][0]['name'] == 'BUFFER-AND-FILE'
            let a:path[1][2] = self['remote_prefix'] . a:path[1][2]
        endif
        return a:path
    else
        throw 'vlime#FixRemotePath: unknown path: ' . string(a:path)
    endif
endfunction

""
" @dict VlimeConnection.FixLocalPath
" @public
"
" Fix the local file paths before sending them to the server, so that the
" server can see the correct files.
" {path} should be a plain string or v:null.
function! vlime#FixLocalPath(path) dict
    if type(a:path) != v:t_string
        return a:path
    endif

    let prefix_len = len(self['remote_prefix'])
    if prefix_len > 0 && a:path[0:prefix_len-1] == self['remote_prefix']
        return a:path[prefix_len:]
    else
        return a:path
    endif
endfunction

""
" @dict VlimeConnection.GetCurrentPackage
" @public
"
" Return the Common Lisp package bound to the current buffer. See
" |vlime-current-package|.
function! vlime#GetCurrentPackage() dict
    if type(self.ui) != type(v:null)
        return self.ui.GetCurrentPackage()
    else
        return v:null
    endif
endfunction

""
" @dict VlimeConnection.SetCurrentPackage
" @public
"
" Bind a Common Lisp package to the current buffer. See
" |vlime-current-package|. This method does NOT check whether the argument is
" a valid package. See @function(VlimeConnection.SetPackage) for a safer
" alternative.
function! vlime#SetCurrentPackage(package) dict
    if type(self.ui) != type(v:null)
        call self.ui.SetCurrentPackage(a:package)
    endif
endfunction

""
" @dict VlimeConnection.GetCurrentThread
" @public
"
" Return the thread bound to the current buffer. Currently this method only
" makes sense in the debugger buffer.
function! vlime#GetCurrentThread() dict
    if type(self.ui) != type(v:null)
        return self.ui.GetCurrentThread()
    else
        return v:true
    endif
endfunction

""
" @dict VlimeConnection.SetCurrentThread
" @public
"
" Bind a thread to the current buffer. Don't call this method directly, unless
" you know what you're doing.
function! vlime#SetCurrentThread(thread) dict
    if type(self.ui) != type(v:null)
        call self.ui.SetCurrentThread(a:thread)
    endif
endfunction

""
" @dict VlimeConnection.WithThread
" @public
"
" Call {Func} with {thread} set as the current thread. The current thread will
" be reset once this method returns. This is useful when you want to e.g.
" evaluate something in certain threads.
function! vlime#WithThread(thread, Func) dict
    let old_thread = self.GetCurrentThread()
    try
        call self.SetCurrentThread(a:thread)
        return a:Func()
    finally
        call self.SetCurrentThread(old_thread)
    endtry
endfunction

""
" @dict VlimeConnection.WithPackage
" @public
"
" Call {Func} with {package} set as the current package. The current package
" will be reset once this method returns.
function! vlime#WithPackage(package, Func) dict
    let old_package = self.GetCurrentPackage()
    try
        call self.SetCurrentPackage([a:package, a:package])
        return a:Func()
    finally
        call self.SetCurrentPackage(old_package)
    endtry
endfunction

""
" @dict VlimeConnection.EmacsRex
" @public
"
" Construct an :EMACS-REX message, with the current package and the current
" thread.
" {cmd} should be a raw :EMACS-REX command.
function! vlime#EmacsRex(cmd) dict
    let pkg_info = self.GetCurrentPackage()
    if type(pkg_info) != v:t_list
        let pkg = v:null
    else
        let pkg = pkg_info[0]
    endif
    return s:EmacsRex(a:cmd, pkg, self.GetCurrentThread())
endfunction

""
" @dict VlimeConnection.Ping
" @public
"
" Send a PING request to the server, and wait for the reply.
function! vlime#Ping() dict
    let cur_tag = self.ping_tag
    let self.ping_tag = (self.ping_tag >= 65536) ? 1 : (self.ping_tag + 1)

    let result = self.Call(self.EmacsRex([s:SYM('SWANK', 'PING'), cur_tag]))
    if type(result) == v:t_string && len(result) == 0
        " Error or timeout
        throw 'vlime#Ping: failed'
    endif

    call s:CheckReturnStatus(result, 'vlime#Ping')
    if result[1][1] != cur_tag
        throw 'vlime#Ping: bad tag'
    endif
endfunction

""
" @dict VlimeConnection.Pong
" @public
"
" Reply to server PING messages.
" {thread} and {ttag} are parameters received in the PING message from the
" server.
function! vlime#Pong(thread, ttag) dict
    call self.Send([s:KW('EMACS-PONG'), a:thread, a:ttag])
endfunction

""
" @dict VlimeConnection.ConnectionInfo
" @usage [return_dict] [callback]
" @public
"
" Ask the server for some info regarding this connection, and optionally
" register a [callback] function to handle the result.
"
" If [return_dict] is specified and |TRUE|, this method will convert the
" result to a dictionary before passing it to the [callback] function.
function! vlime#ConnectionInfo(...) dict
    " We pass local variables as extra arguments instead of
    " using the 'closure' flag on inner functions, to prevent
    " messed-up variable values caused by calling the outer
    " function more than once.
    function! s:ConnectionInfoCB(conn, Callback, return_dict, chan, msg) abort
        call s:CheckReturnStatus(a:msg, 'vlime#ConnectionInfo')
        if a:return_dict
            call s:TryToCall(a:Callback, [a:conn, vlime#PListToDict(a:msg[1][1])])
        else
            call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
        endif
    endfunction

    let return_dict = get(a:000, 0, v:true)
    let Callback = get(a:000, 1, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'CONNECTION-INFO')]),
                \ function('s:ConnectionInfoCB', [self, Callback, return_dict]))
endfunction

""
" @dict VlimeConnection.SwankRequire
" @usage {contrib} [callback]
" @public
"
" Require Swank contrib modules, and optionally register a [callback] function
" to handle the result.
"
" {contrib} can be a string or a list of strings. Each string is a contrib
" module name. These names are case-sensitive. Normally you should use
" uppercase.
function! vlime#SwankRequire(contrib, ...) dict
    let Callback = get(a:000, 0, v:null)
    if type(a:contrib) == v:t_list
        let required = [s:CL('QUOTE'), map(a:contrib, {k, v -> s:KW(v)})]
    else
        let required = s:KW(a:contrib)
    endif

    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SWANK-REQUIRE'), required]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#SwankRequire']))
endfunction

""
" @dict VlimeConnection.CreateREPL
" @usage [coding_system] [callback]
" @public
"
" Create the REPL thread, and optionally register a [callback] function to
" handle the result.
"
" [coding_system] is implementation-dependent. Omit this argument or pass
" v:null to let the server choose it for you.
function! vlime#CreateREPL(...) dict
    function! s:CreateREPL_CB(conn, Callback, chan, msg) abort
        call s:CheckReturnStatus(a:msg, 'vlime#CreateREPL')
        " The package for the REPL defaults to ['COMMON-LISP-USER', 'CL-USER'],
        " so SetCurrentPackage(...) is not necessary.
        "call a:conn.SetCurrentPackage(a:msg[1][1])
        call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
    endfunction

    let cmd = [s:SYM('SWANK-REPL', 'CREATE-REPL'), v:null]
    let coding_system = get(a:000, 0, v:null)
    if coding_system != v:null
        let cmd += [s:KW('CODING-SYSTEM'), coding_system]
    endif
    let Callback = get(a:000, 1, v:null)
    call self.Send(self.EmacsRex(cmd),
                \ function('s:CreateREPL_CB', [self, Callback]))
endfunction

""
" @dict VlimeConnection.ListenerEval
" @usage {expr} [callback]
" @public
"
" Evaluate {expr} in the current package and thread, and optionally register a
" [callback] function to handle the result.
" {expr} should be a plain string containing the lisp expression to be
" evaluated.
function! vlime#ListenerEval(expr, ...) dict
    function! s:ListenerEvalCB(conn, Callback, chan, msg) abort
        let stat = s:CheckAndReportReturnStatus(a:conn, a:msg, 'vlime#ListenerEval')
        if stat
            call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
        endif
    endfunction

    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK-REPL', 'LISTENER-EVAL'), a:expr]),
                \ function('s:ListenerEvalCB', [self, Callback]))
endfunction

""
" @dict VlimeConnection.Interrupt
" @public
"
" Interrupt {thread}.
" {thread} should be a numeric thread ID, or {"package": "KEYWORD", "name":
" "REPL-THREAD"} for the REPL thread.
function! vlime#Interrupt(thread) dict
    call self.Send([s:KW('EMACS-INTERRUPT'), a:thread])
endfunction

""
" @dict VlimeConnection.SLDBAbort
" @usage [callback]
" @public
"
" When the debugger is active, invoke the ABORT restart.
function! vlime#SLDBAbort(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-ABORT')]),
                \ function('s:SLDBSendCB', [self, Callback, 'vlime#SLDBAbort']))
endfunction

""
" @dict VlimeConnection.SLDBBreak
" @usage {func_name} [callback]
" @public
"
" Set a breakpoint at entry to a function with the name {func_name}.
function! vlime#SLDBBreak(func_name, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-BREAK'), a:func_name]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#SLDBBreak']))
endfunction

""
" @dict VlimeConnection.SLDBContinue
" @usage [callback]
" @public
"
" When the debugger is active, invoke the CONTINUE restart.
function! vlime#SLDBContinue(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-CONTINUE')]),
                \ function('s:SLDBSendCB', [self, Callback, 'vlime#SLDBContinue']))
endfunction

""
" @dict VlimeConnection.SLDBStep
" @usage {frame} [callback]
" @public
"
" When the debugger is active, enter stepping mode in {frame}.
" {frame} should be a valid frame number presented by the debugger.
function! vlime#SLDBStep(frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-STEP'), a:frame]),
                \ function('s:SLDBSendCB', [self, Callback, 'vlime#SLDBStep']))
endfunction

""
" @dict VlimeConnection.SLDBNext
" @usage {frame} [callback]
" @public
"
" When the debugger is active, step over the current function call in {frame}.
function! vlime#SLDBNext(frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-NEXT'), a:frame]),
                \ function('s:SLDBSendCB', [self, Callback, 'vlime#SLDBNext']))
endfunction

""
" @dict VlimeConnection.SLDBOut
" @usage {frame} [callback]
" @public
"
" When the debugger is active, step out of the current function in {frame}.
function! vlime#SLDBOut(frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-OUT'), a:frame]),
                \ function('s:SLDBSendCB', [self, Callback, 'vlime#SLDBOut']))
endfunction

""
" @dict VlimeConnection.SLDBReturnFromFrame
" @usage {frame} {str} [callback]
" @public
"
" When the debugger is active, evaluate {str} and return from {frame} with the
" evaluation result.
" {str} should be a plain string containing the lisp expression to be
" evaluated.
function! vlime#SLDBReturnFromFrame(frame, str, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-RETURN-FROM-FRAME'), a:frame, a:str]),
                \ function('s:SLDBSendCB',
                    \ [self, Callback, 'vlime#SLDBReturnFromFrame']))
endfunction

""
" @dict VlimeConnection.SLDBDisassemble
" @usage {frame} [callback]
" @public
"
" Disassemble the code for {frame}.
function! vlime#SLDBDisassemble(frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SLDB-DISASSEMBLE'), a:frame]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#SLDBDisassemble']))
endfunction

""
" @dict VlimeConnection.InvokeNthRestartForEmacs
" @usage {level} {restart} [callback]
" @public
"
" When the debugger is active, invoke a {restart} at {level}.
" {restart} should be a valid restart number, and {level} a valid debugger
" level.
function! vlime#InvokeNthRestartForEmacs(level, restart, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INVOKE-NTH-RESTART-FOR-EMACS'), a:level, a:restart]),
                \ function('s:SLDBSendCB', [self, Callback, 'vlime#InvokeNthRestartForEmacs']))
endfunction

""
" @dict VlimeConnection.RestartFrame
" @usage {frame} [callback]
" @public
"
" When the debugger is active, restart a {frame}.
function! vlime#RestartFrame(frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'RESTART-FRAME'), a:frame]),
                \ function('s:SLDBSendCB',
                    \ [self, Callback, 'vlime#RestartFrame']))
endfunction

""
" @dict VlimeConnection.FrameLocalsAndCatchTags
" @usage {frame} [callback]
" @public
"
" When the debugger is active, get info about local variables and catch tags
" for {frame}.
function! vlime#FrameLocalsAndCatchTags(frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'FRAME-LOCALS-AND-CATCH-TAGS'), a:frame]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#FrameLocalsAndCatchTags']))
endfunction

""
" @dict VlimeConnection.FrameSourceLocation
" @usage {frame} [callback]
" @public
"
" When the debugger is active, get the source location for {frame}.
function! vlime#FrameSourceLocation(frame, ...) dict
    function! s:FrameSourceLocationCB(conn, Callback, chan, msg)
        call s:CheckReturnStatus(a:msg,  'vlime#FrameSourceLocation')
        if a:msg[1][1][0]['name'] == 'LOCATION'
            let fixed_loc = a:conn.FixRemotePath(a:msg[1][1])
        else
            let fixed_loc = a:msg[1][1]
        endif
        call s:TryToCall(a:Callback, [a:conn, fixed_loc])
    endfunction

    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'FRAME-SOURCE-LOCATION'), a:frame]),
                \ function('s:FrameSourceLocationCB', [self, Callback]))
endfunction

""
" @dict VlimeConnection.EvalStringInFrame
" @usage {str} {frame} {package} [callback]
" @public
"
" When the debugger is active, evaluate {str} in {package}, and within the
" context of {frame}.
function! vlime#EvalStringInFrame(str, frame, package, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'EVAL-STRING-IN-FRAME'),
                        \ a:str, a:frame, a:package]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#EvalStringInFrame']))
endfunction

""
" @dict VlimeConnection.InitInspector
" @usage {thing} [callback]
" @public
"
" Evaluate {thing} and start inspecting the evaluation result with the
" inspector.
" {thing} should be a plain string containing the lisp expression to be
" evaluated.
function! vlime#InitInspector(thing, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INIT-INSPECTOR'), a:thing]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InitInspector']))
endfunction

""
" @dict VlimeConnection.InspectorReinspect
" @usage [callback]
" @public
"
" Reload the object being inspected, and update inspector states.
function! vlime#InspectorReinspect(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECTOR-REINSPECT')]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectorReinspect']))
endfunction

""
" @dict VlimeConnection.InspectorRange
" @usage {r_start} {r_end} [callback]
" @public
"
" Pagination for inspector content.
" {r_start} is the first index to retrieve in the inspector content list.
" {r_end} is the last index plus one.
function! vlime#InspectorRange(r_start, r_end, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECTOR-RANGE'), a:r_start, a:r_end]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectorRange']))
endfunction

""
" @dict VlimeConnection.InspectNthPart
" @usage {nth} [callback]
" @public
"
" Inspect an object presented by the inspector.
" {nth} should be a valid part number presented by the inspector.
function! vlime#InspectNthPart(nth, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECT-NTH-PART'), a:nth]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectNthPart']))
endfunction

""
" @dict VlimeConnection.InspectorCallNthAction
" @usage {nth} [callback]
" @public
"
" Perform an action in the inspector.
" {nth} should be a valid action number presented by the inspector.
function! vlime#InspectorCallNthAction(nth, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECTOR-CALL-NTH-ACTION'), a:nth]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectorCallNthAction']))
endfunction

""
" @dict VlimeConnection.InspectorPop
" @usage [callback]
" @public
"
" Inspect the previous object in the stack of inspected objects.
function! vlime#InspectorPop(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECTOR-POP')]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectorPop']))
endfunction

""
" @dict VlimeConnection.InspectorNext
" @usage [callback]
" @public
"
" Inspect the next object in the stack of inspected objects.
function! vlime#InspectorNext(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECTOR-NEXT')]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectorNext']))
endfunction

""
" @dict VlimeConnection.InspectCurrentCondition
" @usage [callback]
" @public
"
" When the debugger is active, inspect the current condition.
function! vlime#InspectCurrentCondition(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECT-CURRENT-CONDITION')]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectCurrentCondition']))
endfunction

""
" @dict VlimeConnection.InspectInFrame
" @usage {thing} {frame} [callback]
" @public
"
" When the debugger is active, evaluate {thing} in the context of {frame}, and
" start inspecting the evaluation result.
function! vlime#InspectInFrame(thing, frame, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECT-IN-FRAME'), a:thing, a:frame]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectInFrame']))
endfunction

""
" @dict VlimeConnection.InspectPresentation
" @usage {pres_id} {reset} [callback]
" @public
"
" Start inspecting an object saved by SWANK-PRESENTATIONS.
" {pres_id} should be a valid ID presented by PRESENTATION-START messages.
" If {reset} is |TRUE|, the inspector will be reset first.
function! vlime#InspectPresentation(pres_id, reset, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'INSPECT-PRESENTATION'), a:pres_id, a:reset]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#InspectPresentation']))
endfunction

""
" @dict VlimeConnection.ListThreads
" @usage [callback]
" @public
"
" Get a list of running threads.
function! vlime#ListThreads(...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'LIST-THREADS')]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#ListThreads']))
endfunction

""
" @dict VlimeConnection.KillNthThread
" @usage {nth} [callback]
" @public
"
" Kill a thread presented in the thread list.
" {nth} should be a valid index in the thread list, instead of a thread ID.
function! vlime#KillNthThread(nth, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'KILL-NTH-THREAD'), a:nth]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#KillNthThread']))
endfunction

""
" @dict VlimeConnection.DebugNthThread
" @usage {nth} [callback]
" @public
"
" Activate the debugger in a thread presented in the thread list.
" {nth} should be a valid index in the thread list, instead of a thread ID.
function! vlime#DebugNthThread(nth, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'DEBUG-NTH-THREAD'), a:nth]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#DebugNthThread']))
endfunction

""
" @dict VlimeConnection.UndefineFunction
" @usage {func_name} [callback]
" @public
"
" Undefine a function with the name {func_name}.
function! vlime#UndefineFunction(func_name, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'UNDEFINE-FUNCTION'), a:func_name]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#UndefineFunction']))
endfunction

""
" @dict VlimeConnection.UninternSymbol
" @usage {sym_name} [package] [callback]
" @public
"
" Unintern a symbol with the name {sym_name}.
" {sym_name} should be a plain string containing the name of the symbol to be
" uninterned.
function! vlime#UninternSymbol(sym_name, ...) dict
    let pkg = get(a:000, 0, v:null)
    let Callback = get(a:000, 1, v:null)
    if type(pkg) == type(v:null)
        let pkg_info = self.GetCurrentPackage()
        if type(pkg_info) == v:t_list
            let pkg = pkg_info[0]
        endif
    endif

    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'UNINTERN-SYMBOL'), a:sym_name, pkg]),
                \ function('vlime#SimpleSendCB',
                    \ [self, Callback, 'vlime#UninternSymbol']))
endfunction

""
" @dict VlimeConnection.SetPackage
" @usage {package} [callback]
" @public
"
" Bind a Common Lisp package to the current buffer. See
" |vlime-current-package|.
function! vlime#SetPackage(package, ...) dict
    function! s:SetPackageCB(conn, buf, Callback, chan, msg) abort
        call s:CheckReturnStatus(a:msg, 'vlime#SetPackage')
        call vlime#ui#WithBuffer(a:buf, function(a:conn.SetCurrentPackage, [a:msg[1][1]]))
        call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
    endfunction

    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'SET-PACKAGE'), a:package]),
                \ function('s:SetPackageCB', [self, bufnr('%'), Callback]))
endfunction

""
" @dict VlimeConnection.DescribeSymbol
" @usage {symbol} [callback]
" @public
"
" Get a description for {symbol}.
" {symbol} should be a plain string containing the symbol name.
function! vlime#DescribeSymbol(symbol, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'DESCRIBE-SYMBOL'), a:symbol]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#DescribeSymbol']))
endfunction

""
" @dict VlimeConnection.OperatorArgList
" @usage {operator} [callback]
" @public
"
" Get the arglist description for {operator}.
" {operator} should be a plain string containing a symbol name.
function! vlime#OperatorArgList(operator, ...) dict
    let Callback = get(a:000, 0, v:null)
    let cur_package = self.GetCurrentPackage()
    if type(cur_package) != type(v:null)
        let cur_package = cur_package[0]
    endif
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'OPERATOR-ARGLIST'), a:operator, cur_package]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#OperatorArgList']))
endfunction

""
" @dict VlimeConnection.SimpleCompletions
" @usage {symbol} [callback]
" @public
"
" Get a simple completion list for {symbol}.
" {symbol} should be a plain string containing a (partial) symbol name.
function! vlime#SimpleCompletions(symbol, ...) dict
    let Callback = get(a:000, 0, v:null)
    let cur_package = self.GetCurrentPackage()
    if type(cur_package) != type(v:null)
        let cur_package = cur_package[0]
    endif
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'SIMPLE-COMPLETIONS'), a:symbol, cur_package]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#SimpleCompletions']))
endfunction

""
" @dict VlimeConnection.FuzzyCompletions
" @usage {symbol} [callback]
" @public
"
" Get a completion list for {symbol}, using a more clever fuzzy algorithm.
" {symbol} should be a plain string containing a (partial) symbol name.
function! vlime#FuzzyCompletions(symbol, ...) dict
    let Callback = get(a:000, 0, v:null)
    let cur_package = self.GetCurrentPackage()
    if type(cur_package) != type(v:null)
        let cur_package = cur_package[0]
    endif
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'FUZZY-COMPLETIONS'), a:symbol, cur_package]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#FuzzyCompletions']))
endfunction

function! vlime#ReturnString(thread, ttag, str) dict
    call self.Send([s:KW('EMACS-RETURN-STRING'), a:thread, a:ttag, a:str])
endfunction

function! vlime#Return(thread, ttag, val) dict
    call self.Send([s:KW('EMACS-RETURN'), a:thread, a:ttag, a:val])
endfunction

""
" @dict VlimeConnection.SwankMacroExpandOne
" @usage {expr} [callback]
" @public
"
" Perform one macro expansion on {expr}.
" {expr} should be a plain string containing the lisp expression to be
" expanded.
function! vlime#SwankMacroExpandOne(expr, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'SWANK-MACROEXPAND-1'), a:expr]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#SwankMacroExpandOne']))
endfunction

""
" @dict VlimeConnection.SwankMacroExpand
" @usage {expr} [callback]
" @public
"
" Expand {expr}, until the resulting form cannot be macro-expanded anymore.
function! vlime#SwankMacroExpand(expr, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'SWANK-MACROEXPAND'), a:expr]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#SwankMacroExpand']))
endfunction

""
" @dict VlimeConnection.SwankMacroExpandAll
" @usage {expr} [callback]
" @public
"
" Recursively expand all macros in {expr}.
function! vlime#SwankMacroExpandAll(expr, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'SWANK-MACROEXPAND-ALL'), a:expr]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#SwankMacroExpandAll']))
endfunction

""
" @dict VlimeConnection.DisassembleForm
" @usage {expr} [callback]
" @public
"
" Compile and disassemble {expr}.
function! vlime#DisassembleForm(expr, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'DISASSEMBLE-FORM'), a:expr]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#DisassembleForm']))
endfunction

""
" @dict VlimeConnection.CompileStringForEmacs
" @usage {expr} {buffer} {position} {filename} [policy] [callback]
" @public
"
" Compile {expr}.
" {buffer}, {position} and {filename} specify where {expr} is from. When
" {buffer} or {filename} is unknown, one can pass v:null instead.
" [policy] should be a dictionary specifying a compiler policy. For example,
"
"     {"DEBUG": 3, "SPEED": 0}
"
" This means no optimization in runtime speed, and maximum debug info.
function! vlime#CompileStringForEmacs(expr, buffer, position, filename, ...) dict
    let policy = s:TransformCompilerPolicy(get(a:000, 0, v:null))
    let Callback = get(a:000, 1, v:null)
    let fixed_filename = self.FixLocalPath(a:filename)
    call self.Send(self.EmacsRex(
                    \ [s:SYM('SWANK', 'COMPILE-STRING-FOR-EMACS'),
                        \ a:expr, a:buffer,
                        \ [s:CL('QUOTE'), [[s:KW('POSITION'), a:position]]],
                        \ fixed_filename, policy]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#CompileStringForEmacs']))
endfunction


""
" @dict VlimeConnection.CompileFileForEmacs
" @usage {filename} [load] [policy] [callback]
" @public
"
" Compile a file with the name {filename}.
" [load], if present and |TRUE|, tells Vlime to automatically load the compiled
" file after successful compilation.
" [policy] is the compiler policy, see
" @function(VlimeConnection.CompileStringForEmacs).
function! vlime#CompileFileForEmacs(filename, ...) dict
    let load = get(a:000, 0, v:true)
    let policy = s:TransformCompilerPolicy(get(a:000, 1, v:null))
    let Callback = get(a:000, 2, v:null)
    let fixed_filename = self.FixLocalPath(a:filename)
    let cmd = [s:SYM('SWANK', 'COMPILE-FILE-FOR-EMACS'), fixed_filename, load]
    if type(policy) != type(v:null)
        let cmd += [s:KW('POLICY'), policy]
    endif
    call self.Send(self.EmacsRex(cmd),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#CompileFileForEmacs']))
endfunction

""
" @dict VlimeConnection.LoadFile
" @usage {filename} [callback]
" @public
"
" Load a file with the name {filename}.
function! vlime#LoadFile(filename, ...) dict
    let Callback = get(a:000, 0, v:null)
    let fixed_filename = self.FixLocalPath(a:filename)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'LOAD-FILE'), fixed_filename]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#LoadFile']))
endfunction

""
" @dict VlimeConnection.XRef
" @usage {ref_type} {name} [callback]
" @public
"
" Cross reference lookup.
" {ref_type} can be "CALLS", "CALLS-WHO", "REFERENCES", "BINDS", "SETS",
" "MACROEXPANDS", or "SPECIALIZES".
" {name} is the symbol name to lookup.
function! vlime#XRef(ref_type, name, ...) dict
    function! s:XRefCB(conn, Callback, chan, msg)
        call s:CheckReturnStatus(a:msg,  'vlime#XRef')
        call s:FixXRefListPaths(a:conn, a:msg[1][1])
        call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
    endfunction

    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'XREF'), s:KW(a:ref_type), a:name]),
                \ function('s:XRefCB', [self, Callback]))
endfunction

""
" @dict VlimeConnection.FindDefinitionsForEmacs
" @usage {name} [callback]
" @public
"
" Lookup definitions for symbol {name}.
function! vlime#FindDefinitionsForEmacs(name, ...) dict
    function! s:FindDefinitionsForEmacsCB(conn, Callback, chan, msg)
        call s:CheckReturnStatus(a:msg, 'vlime#FindDefinitionsForEmacs')
        call s:FixXRefListPaths(a:conn, a:msg[1][1])
        call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
    endfunction

    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'FIND-DEFINITIONS-FOR-EMACS'), a:name]),
                \ function('s:FindDefinitionsForEmacsCB', [self, Callback]))
endfunction

""
" @dict VlimeConnection.AproposListForEmacs
" @usage {name} {external_only} {case_sensitive} {package} [callback]
"
" Lookup symbol names containing {name}.
" If {external_only} is |TRUE|, only return external symbols.
" {case_sensitive} specifies whether the search is case-sensitive or not.
" {package} limits the search to a specific package, but one can pass v:null
" to search all packages.
function! vlime#AproposListForEmacs(name, external_only, case_sensitive, package, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'APROPOS-LIST-FOR-EMACS'),
                    \ a:name, a:external_only, a:case_sensitive, a:package]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#AproposListForEmacs']))
endfunction

""
" @dict VlimeConnection.DocumentationSymbol
" @usage {sym_name} [callback]
" @public
"
" Find the documentation for symbol {sym_name}.
function! vlime#DocumentationSymbol(sym_name, ...) dict
    let Callback = get(a:000, 0, v:null)
    call self.Send(self.EmacsRex([s:SYM('SWANK', 'DOCUMENTATION-SYMBOL'), a:sym_name]),
                \ function('vlime#SimpleSendCB', [self, Callback, 'vlime#DocumentationSymbol']))
endfunction

" ------------------ server event handlers ------------------

function! vlime#OnPing(conn, msg)
    let [_msg_type, thread, ttag] = a:msg
    call a:conn.Pong(thread, ttag)
endfunction

function! vlime#OnNewPackage(conn, msg)
    call a:conn.SetCurrentPackage([a:msg[1], a:msg[2]])
endfunction

function! vlime#OnDebug(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, thread, level, condition, restarts, frames, conts] = a:msg
        call a:conn.ui.OnDebug(a:conn, thread, level, condition, restarts, frames, conts)
    endif
endfunction

function! vlime#OnDebugActivate(conn, msg)
    if type(a:conn.ui) != type(v:null)
        if len(a:msg) == 4
            let [_msg_type, thread, level, select] = a:msg
        elseif len(a:msg) == 3
            let [_msg_type, thread, level] = a:msg
            let select = v:null
        endif
        call a:conn.ui.OnDebugActivate(a:conn, thread, level, select)
    endif
endfunction

function! vlime#OnDebugReturn(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, thread, level, stepping] = a:msg
        call a:conn.ui.OnDebugReturn(a:conn, thread, level, stepping)
    endif
endfunction

function! vlime#OnWriteString(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let str = a:msg[1]
        let str_type = (len(a:msg) >= 3) ? a:msg[2] : v:null
        call a:conn.ui.OnWriteString(a:conn, str, str_type)
    endif
endfunction

function! vlime#OnReadString(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, thread, ttag] = a:msg
        call a:conn.ui.OnReadString(a:conn, thread, ttag)
    endif
endfunction

function! vlime#OnReadFromMiniBuffer(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, thread, ttag, prompt, init_val] = a:msg
        call a:conn.ui.OnReadFromMiniBuffer(
                    \ a:conn, thread, ttag, prompt, init_val)
    endif
endfunction

function! vlime#OnIndentationUpdate(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, indent_info] = a:msg
        call a:conn.ui.OnIndentationUpdate(a:conn, indent_info)
    endif
endfunction

function! vlime#OnInvalidRPC(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, id, err_msg] = a:msg
        call a:conn.ui.OnInvalidRPC(a:conn, id, err_msg)
    endif
endfunction

function! vlime#OnInspect(conn, msg)
    if type(a:conn.ui) != type(v:null)
        let [_msg_type, i_content, i_thread, i_tag] = a:msg
        call a:conn.ui.OnInspect(a:conn, i_content, i_thread, i_tag)
    endif
endfunction

" ------------------ end of server event handlers ------------------

function! vlime#OnServerEvent(chan, msg) dict
    let msg_type = a:msg[0]
    let Handler = get(self.server_event_handlers, msg_type['name'], v:null)
    if type(Handler) == v:t_func
        call Handler(self, a:msg)
    endif
endfunction

" ================== end of methods for vlime connections ==================

function! vlime#SimpleSendCB(conn, Callback, caller, chan, msg) abort
    call s:CheckReturnStatus(a:msg, a:caller)
    call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
endfunction

function! s:SLDBSendCB(conn, Callback, caller, chan, msg) abort
    let status = a:msg[1][0]
    if status['name'] != 'ABORT' && status['name'] != 'OK'
        throw caller . ' returned: ' . string(a:msg[1])
    endif
    call s:TryToCall(a:Callback, [a:conn, a:msg[1][1]])
endfunction

function! vlime#PListToDict(plist)
    if type(a:plist) == type(v:null)
        return {}
    endif

    let d = {}
    let i = 0
    while i < len(a:plist)
        let d[a:plist[i]['name']] = a:plist[i+1]
        let i += 2
    endwhile
    return d
endfunction

function! vlime#ChainCallbacks(...)
    let cbs = a:000
    if len(cbs) <= 0
        return
    endif

    function! s:ChainCallbackCB(cbs, ...)
        if len(a:cbs) < 1
            return
        endif
        let CB = function(a:cbs[0], a:000)
        call CB()

        if len(a:cbs) < 2
            return
        endif
        let NextFunc = a:cbs[1]
        call NextFunc(function('s:ChainCallbackCB', [a:cbs[2:]]))
    endfunction

    let FirstFunc = cbs[0]
    call FirstFunc(function('s:ChainCallbackCB', [cbs[1:]]))
endfunction

function! vlime#ParseSourceLocation(loc)
    if type(a:loc[0]) != v:t_dict || a:loc[0]['name'] != 'LOCATION'
        throw 'vlime#ParseSourceLocation: invalid location: ' . string(a:loc)
    endif

    let loc_obj = {}

    for p in a:loc[1:]
        if type(p) != v:t_list
            continue
        endif

        if len(p) == 1
            let loc_obj[p[0]['name']] = v:null
        elseif len(p) == 2
            let loc_obj[p[0]['name']] = p[1]
        elseif len(p) > 2
            let loc_obj[p[0]['name']] = p[1:]
        endif
    endfor

    return loc_obj
endfunction

function! vlime#GetValidSourceLocation(loc)
    let loc_file = get(a:loc, 'FILE', v:null)
    let loc_buffer = get(a:loc, 'BUFFER', v:null)
    let loc_buf_and_file = get(a:loc, 'BUFFER-AND-FILE', v:null)
    let loc_src_form = get(a:loc, 'SOURCE-FORM', v:null)

    if type(loc_file) != type(v:null)
        let loc_pos = get(a:loc, 'POSITION', v:null)
        let loc_snippet = get(a:loc, 'SNIPPET', v:null)
        let valid_loc = [loc_file, loc_pos, loc_snippet]
    elseif type(loc_buffer) != type(v:null)
        let loc_offset = get(a:loc, 'OFFSET', v:null)
        let loc_snippet = get(a:loc, 'SNIPPET', v:null)
        if type(loc_offset) != type(v:null)
            " Negative offsets are used to designate the code snippets entered
            " via the input buffer
            if loc_offset[0] < 0 || loc_offset[1] < 0
                let loc_offset = v:null
            else
                let loc_offset = loc_offset[0] + loc_offset[1]
            endif
        endif
        let valid_loc = [loc_buffer, loc_offset, loc_snippet]
    elseif type(loc_buf_and_file) != type(v:null)
        let loc_offset = get(a:loc, 'OFFSET', v:null)
        let loc_snippet = get(a:loc, 'SNIPPET', v:null)
        if type(loc_offset) != type(v:null)
            if loc_offset[0] < 0 || loc_offset[1] < 0
                let loc_offset = v:null
            else
                let loc_offset = loc_offset[0] + loc_offset[1]
            endif
        endif
        let valid_loc = [loc_buf_and_file[0], loc_offset, loc_snippet]
    elseif type(loc_src_form) != type(v:null)
        let valid_loc = [v:null, 1, loc_src_form]
    else
        let valid_loc = []
    endif

    return valid_loc
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
        throw a:caller . ' returned: ' . string(a:return_msg[1])
    endif
endfunction

function! s:CheckAndReportReturnStatus(conn, return_msg, caller)
    let status = a:return_msg[1][0]
    if status['name'] == 'OK'
        return v:true
    elseif status['name'] == 'ABORT'
        call a:conn.ui.OnWriteString(a:conn, a:return_msg[1][1] . "\n",
                    \ {'name': 'ABORT-REASON', 'package': 'KEYWORD'})
        return v:false
    else
        call a:conn.ui.OnWriteString(a:conn, string(a:return_msg[1]),
                    \ {'name': 'UNKNOWN-ERROR', 'package': 'KEYWORD'})
        return v:false
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

function! s:TryToCall(Callback, args)
    if type(a:Callback) == v:t_func
        let CB = function(a:Callback, a:args)
        call CB()
    endif
endfunction

function! s:FixXRefListPaths(conn, xref_list)
    if type(a:xref_list) != v:t_list
        return
    endif

    for spec in a:xref_list
        if type(spec[0]) == v:t_string && spec[1][0]['name'] == 'LOCATION'
            let spec[1] = a:conn.FixRemotePath(spec[1])
        endif
    endfor
endfunction

function! s:TransformCompilerPolicy(policy)
    if type(a:policy) == v:t_dict
        let plc_list = []
        for [key, val] in items(a:policy)
            call add(plc_list, {'head': [s:CL(key)], 'tail': val})
        endfor
        return [s:CL('QUOTE'), plc_list]
    else
        return a:policy
    endif
endfunction

function! vlime#DummyCB(conn, result)
    echom '---------------------------'
    echom string(a:result)
endfunction
