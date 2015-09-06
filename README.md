

# NAME

    Net::Waiter concise INET socket server

# SYNOPSIS

    package MyWaiter;
    use strict;
    use base qw( Net::Waiter );

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
    $server->run();
    



# METHODS/FUNCTIONS

## run()

This executes server main loop. It will create new server socket, set
options (listen port, ssl options, etc.) then fork and call handlers along
the way.

## break\_main\_loop()

Breaks main server loop. Calling break\_main\_loop() is possible from any handler
function (see HANDLER FUNCTIONS below) but it will not break the main loop 
immediately. It will just rise flag which will stop when control is returned to
the next server loop.

## ssl\_in\_use()

Returns true (1) if current setup uses SSL (useful mostly inside handlers).

## is\_child()

Returns true (1) if this process is client/child process (useful mostly inside handlers).

# HANDLER FUNCTIONS

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

## on\_close( $client\_socket )

Called right before client socket will be closed. And after on\_process().

## on\_server\_close()

Called right before server (listen) socket is closed (i.e. when main loop 
is interrupted). This is the last handler to be called on each run().

## on\_ssl\_error( $ssl\_handshake\_error )

Called when SSL handshake or other error encountered. Gets error message as 1st argument.

## on\_sig\_child( $child\_pid )

Called when child/client process finishes. It executes only inside the parent/server
process and gets child pid as 1st argument.

## on\_sig\_usr1()

Called when server or forked (child) process receives USR1 signal.
(is\_child() can be used here)

## on\_sig\_usr2()

Called when server or forked (child) process receives USR2 signal.
(is\_child() can be used here)
                                                                                        

# TODO

    (more docs)

# REQUIRED MODULES

Net::Waiter is designed to be compact and self sufficient. 
However it uses some 3rd party modules:

    * IO::Socket::INET

# DEMO

For demo server check 'demo' directory in the source tar package or at the
GITHUB repository:

    



# GITHUB REPOSITORY

    git@github.com:cade-vs/perl-net-waiter.git
    

    git clone git://github.com/cade-vs/perl-net-waiter.git
    

# AUTHOR

    Vladi Belperchinov-Shabanski "Cade"

    <cade@biscom.net> <cade@cpan.org> <cade@datamax.bg>

    http://cade.datamax.bg