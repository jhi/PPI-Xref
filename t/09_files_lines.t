use Test::More;

use strict;
use warnings;

use PPI::Xref;

use FindBin qw[$Bin];
require "$Bin/util.pl";
my ($xref, $lib) = get_xref();

ok($xref->process("$lib/B.pm"), "process file");

my @fl;
for my $f ($xref->files) {
  push @fl, "$f\t" . $xref->file_lines($f);
}

is_deeply(\@fl,
          [
           "$lib/A.pm\t13",
           "$lib/B.pm\t9",
           "$lib/E.pm\t3",
           "$lib/F.pm\t2",
           "$lib/f.pl\t3",
           "$lib/g.pl\t1",
          ],
         "files_lines");

done_testing();
