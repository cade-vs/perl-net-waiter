##############################################################################
#
#  Net::Waiter concise INET socket server
#  (c) Vladi Belperchinov-Shabanski "Cade" 2015
#  http://cade.datamax.bg
#  <cade@bis.bg> <cade@biscom.net> <cade@datamax.bg> <cade@cpan.org>
#
#  GPL
#
##############################################################################
package Net::Waiter;
use strict;

our $VERSION = '1.00';

our @ISA    = qw( Exporter );
our @EXPORT = qw(

                );

our %EXPORT_TAGS = (
                   
                   'all'  => \@EXPORT,
                   'none' => [],
                   
                   );
            

##############################################################################

=pod


=head1 NAME

  Net::Waiter concise INET socket server

=head1 SYNOPSIS

  use Net::Waiter;

=head1 TODO

  (more docs)

=head1 REQUIRED MODULES

Net::Waiter is designed to be compact and self sufficient. 
However it uses some 3rd party modules:

  * IO::Socket::INET

=head1 GITHUB REPOSITORY

  git@github.com:cade-vs/perl-net-waiter.git
  
  git clone git://github.com/cade-vs/perl-net-waiter.git
  
=head1 AUTHOR

  Vladi Belperchinov-Shabanski "Cade"

  <cade@biscom.net> <cade@cpan.org> <cade@datamax.bg>

  http://cade.datamax.bg

=cut

##############################################################################
1;
