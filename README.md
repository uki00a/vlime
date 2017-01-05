Intro
=====

Vlime is a Common Lisp dev environment for Vim, similar to SLIME for Emacs and
SLIMV for Vim (and yes, I dug around SLIMV's source code when writing Vlime).

Vlime provides REPL integration inside Vim, as well as omni-completions and
basic SLDB support. And, optionally, it makes you a lot sexier.

Why?
====

* There were barely no choice besides SLIMV.
* SLIMV was written in Python on the Vim side, but I think a Lisp-and-Vimscript
  implementation would be awesome.
* Vim 8 has these nice `channel` APIs, why not try them out?

Current State
=============

Vlime is currently in a pre-alpha state. One should expect changes in APIs and
key bindings etc.

Dependencies
============

* Quicklisp
* libuv
* Vim 8.0+ and +channel
* A decent Common Lisp implementation (SBCL is recommended)

Vlime is built and tested with SBCL, but other implementations may also work.

Currently Vlime can only detect s-expressions inside parentheses. To make your
life easier, use [paredit](https://github.com/kovisoft/paredit).

Installation
============

1. Make sure your system has libuv installed.
2. Set up Quicklisp properly.
3. Clone this repo, and create a symlink to Vlime's `lisp` directory in your
   `local-projects` directory.
4. In your REPL, invoke `(ql:quickload :vlime)`
5. Install the Vim plugin in Vlime's `vim` directory using your usual way
   (Vundle or something).

Usage
=====

Run the server:

    sbcl --load <vlime repo>/lisp/start-vlime.lisp

Use Vim to start editing a Lisp source file. These keys are mapped:

Connection management:

* `<LocalLeader>cc`: Connect to Vlime server.
* `<LocalLeader>cs`: Switch Vlime connections.
* `<LocalLeader>cd`: Disconnect.
* `<LocalLeader>cr`: Rename the current connection.

Sending stuff to the REPL:

* `<LocalLeader>ss`: Send the "thing" (an s-expression or an atom) under the cursor to the REPL.
* `<LocalLeader>se`: Send the s-expression under the cursor to the REPL.
* `<LocalLeader>sa`: Send the atom under the cursor to the REPL.
* `<LocalLeader>s`: (In visual mode) Send the current selection to the REPL.

Expanding macros:

* `<LocalLeader>m1`: Expand the macro under the cursor.
* `<LocalLeader>ma`: Expand the macro under the cursor and all nested macros.

Compiling:

* `<LocalLeader>oe`: Compile the form under the cursor.
* `<LocalLeader>of`: Compile the current file.
* `<LocalLeader>o`: (In visual mode) Compile the current selection.

Describing things:

* `<LocalLeader>do`: Describe the "operator" of the s-expression under the cursor.
* `<LocalLeader>da`: Describe the atom under the cursor.

Inspection:

* `<LocalLeader>II`: Evaluate and inspect the "thing" (an s-expression or an atom) under the cursor.
* `<LocalLeader>Ii`: Same as `<LocalLeader>II`
* `<LocalLeader>IE`: Evaluate and inspect the s-expression under the cursor.
* `<LocalLeader>Ie`: Same as `<LocalLeader>IE`
* `<LocalLeader>IA`: Evaluate and inspect the atom under the cursor.
* `<LocalLeader>Ia`: Same as `<LocalLeader>IA`
* `<LocalLeader>I` : (In visual mode) Evaluate and inspect the current selection.

Other stuff:

* `<LocalLeader>i`: Interaction Mode.
* `<LocalLeader>l`: Load the current file.
* `<LocalLeader>a`: Disassemble the form under the cursor.

`<LocalLeader>` defaults to backslash `\`. In addition, you can use `<tab>`
instead of `<c-x><c-o>` to invoke omni-completion.

Most of Vlime's functionalities need an active connection to the server. Press
`<LocalLeader>cc` to create one. And Vlime supports multiple connections, use
`<LocalLeader>cs` to select the connection to use for the current buffer.

In `Interaction Mode` (entered via `<LocalLeader>i`), you can place the cursor
on an s-expression and then press `<cr>` to send it to the REPL.

In the REPL output buffer, `<c-c>` will interrupt the REPL thread.

When there's an unhandled condition or a thread is interrupted, the SLDB
buffer will appear, with posible restarts and stack frames as it's content.
Pressing `<cr>` on one of the restart options will invoke that restart. These
keys are available in the SLDB buffer:

* `<cr>`: Choose a restart.
* `d`: Show the details (local variables and source location etc.) of the
       frame under the cursor (or the most recent frame).
* `S`: Jump to the source code for the frame under the cursor (or the most recent frame).
* `r`: Restart the frame under the cursor.
* `s`: Start stepping in the frame under the cursor (or the most recent frame).
* `x`: Step over the current function call.
* `o`: Step out of the current function.
* `c`: Invoke the restart labeled CONTINUE.
* `a`: Invoke the restart labeled ABORT.
* `C`: Inspect the current condition object.
* `i`: Evaluate and inspect an expression in the frame under the cursor (or
       the most recent frame).

License
=======

MIT. See `LICENSE.txt`.
