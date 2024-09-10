#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use MyWaiter;

my $server = MyWaiter->new( PORT => 9123, PREFORK => 8, MAXFORK => 128, DEBUG => 10, PX_IDLE => 5 );

my $res = $server->run();
print "waiter result: $res\n";


