package MyWaiter;
use strict;
use base qw( Net::Waiter );

use Data::Dumper;

sub dump_args
{
  my ( $package, $filename, $line, $subroutine ) = caller( 1 );
  my @args = @_;
  shift( @args );
  print Dumper( { $subroutine => \@args }, "\n\n" );
}

sub on_listen_ok
{
  dump_args( @_ );
}

sub on_accept_error
{
  dump_args( @_, $! );
}

sub on_accept_ok
{
  my $sock = $_[1];
  dump_args( @_ );
  my $peerhost = $sock->peerhost();
  print "client connected from $peerhost\n";
}

sub on_fork_ok
{
  dump_args( @_ );
}

sub on_process
{
  my $sock = $_[1];
  dump_args( @_ );

  print $sock "HTTP/1.0 200 OK\n\nhello world\n";
}

sub on_close
{
  dump_args( @_ );
}

sub on_server_close
{
  dump_args( @_ );
}

sub on_ssl_error
{
  dump_args( @_ );
}

sub on_sig_child
{
  dump_args( @_ );
}

sub on_sig_usr1
{
  dump_args( @_ );
}

sub on_sig_usr2
{
  dump_args( @_ );
}

1;
