#!/usr/bin/env perl
use lib 't/lib';

use Test::More tests => 19;

use Mojo::Base::XS;
use B;

{
    package RTest;
    use Mojo::Base::XS;
    __PACKAGE__->attr(foo => sub { {} });
    sub fake_foo { shift->{foo} }
    __PACKAGE__->attr(bar => 2);
};
{
    package RTest::Container;
    use Mojo::Base::XS;
    __PACKAGE__->attr(test => sub { RTest->new });
    __PACKAGE__->attr(xxx => 0);
    __PACKAGE__->attr('def_array' => sub { ['Named!'] });
};

sub refcnt { B::svref_2object($_[0])->REFCNT; }

my $rtest = RTest->new;

is refcnt($rtest), 1;

is refcnt($rtest->foo), 2;
is refcnt($rtest->foo), 2;
is refcnt($rtest->{foo}), 1;
is_deeply($rtest->foo, {});

{
    my $foo = $rtest->foo;
    is refcnt($foo), 2;
    is refcnt($rtest->foo), 3;
};

is refcnt($rtest->foo), 2;
is $rtest->bar, 2;
$rtest->bar({});
is_deeply($rtest->bar, {});

my $container = RTest::Container->new(xxx => {});

is refcnt($container->test), 2;
is refcnt($container->test->foo), 2;
is refcnt($container->test->foo), 2;
{
    my $foo = $container->test->foo;
    is refcnt($container->test), 2;
    is refcnt($foo), 2;
    is refcnt($container->test->foo), 3;
};
is refcnt($container->test->foo), 2;
is_deeply $container->xxx, {};
is_deeply $container->def_array, ['Named!'];
