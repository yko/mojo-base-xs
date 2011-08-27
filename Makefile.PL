use inc::Module::Install;

name 'Mojo-Base-XS';
all_from 'lib/Mojo/Base/XS.pm';
author q{Yaroslav Korshak <yko@cpan.org>};
license 'perl';

perl_version '5.010';

requires 'XSLoader';
build_requires 'Test::More';

resources
  license    => "http://dev.perl.org/licenses",
  repository => "http://github.com/yko/mojo-base-xs";

auto_install;

WriteAll;
