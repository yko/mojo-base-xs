#!/usr/bin/env perl
use strict;
use warnings;

use Mojo::Base::XS -infect;
use Test::More;

eval { require Mojo::Base };
if ($@) {
    plan skip_all => "Mojo::Base required to run this test";
}

# Imported from Mojolicious v1.70
# https://github.com/kraih/mojo/blob/v1.70/t/mojo/base.t

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2011, Sebastian Riedel.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut

plan tests => 411;

use FindBin;
use lib "$FindBin::Bin/lib";

package BaseTest;

use strict;
use warnings;

use base 'BaseTest::Base2';

# "When I first heard that Marge was joining the police academy,
#  I thought it would be fun and zany, like that movie Spaceballs.
#  But instead it was dark and disturbing.
#  Like that movie... Police Academy."
__PACKAGE__->attr(heads => 1);
__PACKAGE__->attr('name');

package main;

use_ok 'Mojo::Base';
use_ok 'BaseTest::Base1';
use_ok 'BaseTest::Base2';
use_ok 'BaseTest::Base3';

# Basic functionality
my $monkeys = [];
for my $i (1 .. 50) {
  $monkeys->[$i] = BaseTest->new;
  $monkeys->[$i]->bananas($i);
  is $monkeys->[$i]->bananas, $i, 'right attribute value';
}
for my $i (51 .. 100) {
  $monkeys->[$i] = BaseTest->new(bananas => $i);
  is $monkeys->[$i]->bananas, $i, 'right attribute value';
}

# Instance method
my $monkey = BaseTest->new;
$monkey->attr('mojo');
$monkey->mojo(23);
is $monkey->mojo, 23, 'monkey has mojo';

# "default" defined but false
my $m = $monkeys->[1];
ok defined($m->coconuts);
is $m->coconuts, 0, 'right attribute value';
$m->coconuts(5);
is $m->coconuts, 5, 'right attribute value';

# "default" support
my $y = 1;
for my $i (101 .. 150) {
  $y = !$y;
  $monkeys->[$i] = BaseTest->new;
  isa_ok $monkeys->[$i]->name('foobarbaz'),
    'BaseTest', 'attribute value has right class';
  $monkeys->[$i]->heads('3') if $y;
  $y
    ? is($monkeys->[$i]->heads, 3, 'right attribute value')
    : is($monkeys->[$i]->heads, 1, 'right attribute default value');
}

# "chained" and coderef "default" support
for my $i (151 .. 200) {
  $monkeys->[$i] = BaseTest->new;
  is $monkeys->[$i]->ears, 2, 'right attribute value';
  is $monkeys->[$i]->ears(6)->ears, 6, 'right chained attribute value';
  is $monkeys->[$i]->eyes, 2, 'right attribute value';
  is $monkeys->[$i]->eyes(6)->eyes, 6, 'right chained attribute value';
}

# Inherit -base flag
$monkey = BaseTest::Base3->new(evil => 1);
is $monkey->evil,    1,     'monkey is evil';
is $monkey->bananas, undef, 'monkey has no bananas';
$monkey->bananas(3);
is $monkey->bananas, 3, 'monkey has 3 bananas';

1;
