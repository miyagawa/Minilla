use strict;
use warnings;
use utf8;
use Test::More;
use t::Util;

use Test::More;

use File::Temp qw(tempdir);
use File::pushd;
use File::Basename qw(dirname);
use File::Path qw(mkpath);
use Minilla::Profile::Default;
use Minilla::Project;

subtest 'develop deps' => sub {
    my $guard = pushd(tempdir());

    my $profile = Minilla::Profile::Default->new(
        author => 'foo',
        dist => 'Acme-Foo',
        path => 'Acme/Foo.pm',
        suffix => 'Foo',
        module => 'Acme::Foo',
        version => '0.01',
        email => 'foo@example.com',
    );
    $profile->generate();
    write_minil_toml('Acme-Foo');

    git_init_add_commit();

    Minilla::Project->new()->regenerate_files;

    like(slurp('META.json'), qr!Test::Pod!, 'Modules required by release testing is noteded in META.json');
};

done_testing;

