use Test::More;

use strict;
use warnings;

use File::Spec;
my $ppixref = File::Spec->catfile("util", "ppixref");

my $fh;

ok(open($fh,
        "$^X -Ilib $ppixref --code='use utf8' --files --subs --subs_files --incs_files |"),
   "start ppixref");

my %files;
my %subs;
my %subs_files;
my %incs_files;

while(<$fh>) {
    print;
    if (m{/((?:utf8|strict)\.pm)$}) {
        $files{$1}++;
    }
    if (m{^((?:utf8|strict)::import)$}) {
        $subs{$1}++;
    }
    if (m{^((?:utf8|strict)::import)\t/.+/([^/]+)\t\d+$}) {
        $subs_files{$1}{$2}++;
    }
    if (m{^/.+/([^/]+\.p[ml])\t\d+\t/.+/([^/]+\.p[ml])\t(?:use|require)\t.+}) {
        $incs_files{$1}{$2}++;
    }
}

ok($files{'utf8.pm'}, "saw utf8.pm");
ok($files{'strict.pm'}, "saw strict.pm");
ok($subs{'utf8::import'}, "saw utf8::import");
ok($subs{'strict::import'}, "saw strict::import");
ok($subs_files{'utf8::import'}{'utf8.pm'}, "utf8::import subs_files");
ok($subs_files{'strict::import'}{'strict.pm'}, "strict::import subs_files");
ok($incs_files{'utf8.pm'}{'utf8_heavy.pl'}, "utf8.pm utf8_heavy.pl");
ok($incs_files{'warnings.pm'}{'Carp.pm'}, "warnings.pm Carp.pm");

done_testing();
