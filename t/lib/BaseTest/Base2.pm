package BaseTest::Base2;
use Mojo::Base 'BaseTest::Base1';

# "Hey, I asked for ketchup! I'm eatin' salad here!"
has [qw/ears eyes/] => sub {2};
has coconuts => 0;

1;
