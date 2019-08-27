package BaseTestXS;

use strict;
use warnings;

use Mojo::Base::XS;

has [qw/ears eyes/] => sub {2};

__PACKAGE__->attr(heads => 1);
__PACKAGE__->attr('name' => sub { 'Named!' });
__PACKAGE__->attr('def_array' => sub { ['Named!'] });
__PACKAGE__->attr('dies_in_default' => sub { die "Exception thrown" });

my $GLOBAL_WEAK = ['weakened!'];
has 'weakling' => sub { $GLOBAL_WEAK }, weak => 1;

1;
