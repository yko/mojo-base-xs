#!/usr/bin/env perl
use lib 't/lib';

use Test::More tests => 15;

use Mojo::Base::XS;

use BaseTestXS;

can_ok 'BaseTestXS', 'has';

my $self = BaseTestXS->new({foo => 'bar'});

is($self->{foo}, 'bar');
$self->attr('x');

can_ok $self, 'name';
can_ok $self, 'x';
is $self->name, 'Named!';

is_deeply $self->def_array, ['Named!'];

$self->name("ololo");
is $self->name, "ololo";

isa_ok $self->name("ololo"), 'BaseTestXS';

is $self->ears, 2;

eval {
    BaseTestXS->attr("42shouldfail");
};

like $@, qr/Attribute "42shouldfail" invalid/,
  "match Mojo::Base accessor name restrictions";

TODO: {
    diag "perl 5.16.0 .. 5.18.0 affected by bug #117947 - all XS functions are implicitly :lvalue";
    local $TODO = 'find a workaround for bug #117947';
    eval { $self->ears = 2 };
    like $@, qr/^Can't modify non-lvalue subroutine call/,
      "runtime error thrown";
}

# Check for aliases

(sub { $_[0] = "attribute modified in lvalue" })->($self->ears);

is $self->ears, 2, "accessor does not create alias in lvalue context";

ok !exists($self->{heads});

(sub { $_[0] = "attribute modified in lvalue" })->($self->heads);

is $self->heads, 1, "accessor does not create alias in lvalue context";

(sub { $_[0] = "object modified in lvalue" })->($self->heads(1));

isa_ok $self, 'BaseTestXS', "accessor does not create alias to object in lvalue context";
