# NAME

    Net::Waiter compact INET socket server

# SYNOPSIS

    package MyWaiter;
    use strict;
    use parent qw( Net::Waiter );

    sub on_accept_ok
    {
      my $self = shift;
      my $sock = shift;
      my $peerhost = $sock->peerhost();
      print "client connected from $peerhost\n";
    }

    sub on_process
    {
      my $self = shift;
      my $sock = shift;
      print $sock "hello world\n";
    }

    #--------------------------------------------------

    packgage main;
    use strict;
    use MyWaiter;

    my $server = MyWaiter->new( PORT => 9123 );
    my $res = $server->run();
    print "waiter result: $res\n"; # 0 is ok, >0 is error

# DESCRIPTION

Net::Waiter is a base class which implements compact INET network socket server.  

# METHODS/FUNCTIONS

## new( OPTION => VALUE, ... )

Creates new Net::Waiter object and sets its options:

    PORT    => 9123, # which port to listen on
    PREFORK =>    8, # how many preforked processes
    MAXFORK =>   32, # max count of preforked processes
    NOFORK  =>    0, # if 1 will not fork, only single client will be accepted
    TIMEOUT =>    4, # timeout for accepting connections, defaults to 4 seconds
    SSL     =>    1, # use SSL

    PX_IDLE =>   31, # prefork exit idle time, defaults to 31

    PROP_SIGUSR => 1, # if true, will propagate USR1/USR2 signals to childs
    
    DEBUG   =>    1, # enable debug mode, prints debug messages

if PREFORK is negative, the absolute value will be used both for PREFORK and
MAXFORK counts.

if SSL is enabled then additional IO::Socket::SSL options can be added:

    SSL_cert_file   => 'cert.pem',
    SSL_key_file    => 'key.pem', 
    SSL_ca_file     => 'ca.pem',
    SSL_verify_mode => 1,

for further details, check IO::Socket::SSL docs. all SSL\_ options are allowed.

## run()

This executes server main loop. It will create new server socket, set
options (listen port, ssl options, etc.) then fork and call handlers along
the way.

Run returns exit code:

      0 -- ok
    100 -- cannot create server listen socket

## break\_main\_loop()

Breaks main server loop. Calling break\_main\_loop() is possible from parent 
server process handler functions (see HANDLER FUNCTIONS below) but it will 
not break the main loop immediately. It will just raise flag which will stop 
when control is returned to the next server loop.

## ssl\_in\_use()

Returns true (1) if current setup uses SSL (useful mostly inside handlers).

## is\_child()

Returns true (1) if this process is client/child process (useful mostly inside handlers).

## get\_server\_socket()

Returns server (listening) socket object. Valid in parent only, otherwise returns undef.

## get\_client\_socket()

Returns connected client socket.

## get\_busy\_kids\_count()

Returns the count of all forked busy processes (which are already accepted connection).
In array contect returns two integers: busy process count and all forked processes count.
This method is accessible from parent and all forked processes and reflect all processes.

Returns client (connected) socket object. Valid in kids only, otherwise returns undef.

## get\_kid\_pids()

Returns list of forked child pids. Available only in parent processes.

## propagate\_signal( 'SIGNAME' )

Sends signal 'SIGNAME' to all child processes.

# EVENT HANDLING FUNCTIONS

All of the following methods are empty in the base implementation and are
expected to be reimplemented. The list order below is chronological but the
most important function which must be reimplemented is on\_process().

## on\_listen\_ok()

Called when listen socket is ready but no connection is accepted yet.

## on\_accept\_error()

Called if there is an error with accepting connections.

## on\_accept\_ok( $client\_socket )

Called when new connection is accepted without error.

## on\_fork\_ok( $child\_pid )

Called when new process is forked. This will be executed inside the server
(parent) process and will have forked (child) process pid as 1st argument.

## on\_process( $client\_socket )

Called when socket is ready to be used. This is the place where the actual
work must be done.

## on\_prefork\_child\_idle

Called on preforked childs, when accept timeouts (see 'TIMEOUT' option).

## on\_forking\_idle

Called on forking mode parent, when accept timeouts (see 'TIMEOUT' option).

## on\_maxforked( $client\_socket )

Called if client socket is accepted but MAXFORK count reached. This can be
used to advise the situation over the socket and will be called right before
client socket close.

note: this handler is only used for FORKING server. preforked servers will
not accept the socket at all if MAXFORK has been reached. the reason is that
forking server may release child process during the accept() call.

## on\_child\_start()

Called right after fork, in the forked child, after initial setup but just before processing start.

## on\_child\_exit()

Called inside a child, just before forked or preforked child exits.

## on\_close( $client\_socket )

Called right before client socket will be closed. And after on\_process().
Will be called and when MAXFORK has been reached also.

## on\_server\_close()

Called right before server (listen) socket is closed (i.e. when main loop 
is interrupted). This is the last handler to be called on each run().

## on\_ssl\_error( $ssl\_handshake\_error )

Called when SSL handshake or other error encountered. Gets error message as 1st argument.

## on\_sig\_child( $child\_pid )

Called when child/client process finishes. It executes only inside the parent/server
process and gets child pid as 1st argument.

## on\_sig\_usr1()

Called when server process receives USR1 signal.

## on\_sig\_usr2()

Called when server process receives USR2 signal.

## on\_child\_sig\_usr1()

Called when forked (child) process receives USR1 signal.

## on\_child\_sig\_usr2()

Called when forked (child) process receives USR2 signal.

## log() and log\_debug()

Called when Waiter prints (debug) messages. Should be reimplemented to use
specific log facility. By default it prints messages to STDERR. Can be
reimplemented empty to supress any messages.

# NOTES

in PREFORK mode, fixed initial number of processes will be forked. each will
accept socket and wait for connection. if waiting time for accept reaches a
limit (default to 31 seconds, see PX\_IDLE option above) the process will exit
and main process will decide if new one should be forked or not.

PREFORK process count may momentarily fall under the initial/lower count limit 
if several processes exit on idle.

SIG\_CHLD handler defaults to IGNORE in child processes. 
whoever forks further here, should reinstall signal handler if needed. 

# TODO

    (more docs)

# REQUIRED MODULES

Net::Waiter tries to use as little modules as possible. Currenlty only those
core modules are in use:
  \* IO::Socket::INET
  \* POSIX ":sys\_wait\_h";
  \* IO::Socket::INET;
  \* Sys::SigAction qw( set\_sig\_handler );
  \* IPC::Shareable;
  \* Data::Dumper;

# DEMO

For demo server check 'demo' directory in the source tar package or at the
GITHUB repository:

    https://github.com/cade-vs/perl-net-waiter/tree/master/demo  

# GITHUB REPOSITORY

    https://github.com/cade-vs/perl-net-waiter

    git@github.com:cade-vs/perl-net-waiter.git

    git clone git://github.com/cade-vs/perl-net-waiter.git
    

# AUTHOR

    Vladi Belperchinov-Shabanski "Cade"

    <cade@noxrun.com> <cade@bis.bg> <cade@cpan.org>

    http://cade.noxrun.com
