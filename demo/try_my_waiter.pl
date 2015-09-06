#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use MyWaiter;

my $server = MyWaiter->new( PORT => 9123 );

my $res = $server->run();
print "waiter result: $res\n";


