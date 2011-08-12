use inc::Module::Install;

name     'Mojo-Base-XS';
all_from 'lib/Mojo/Base/XS.pm';
author   q{Yaroslav Korshak <yko@cpan.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

