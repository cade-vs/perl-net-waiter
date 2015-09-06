#!/usr/bin/perl
use strict;
use lib '.', '../lib';
use MyWaiter;

my $server = MyWaiter->new( PORT => 9123 );

$server->run();


