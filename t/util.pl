use strict;
use warnings;

sub get_abslib {
    use FindBin qw[$Bin];
    my $relbin = $Bin;
    return "$relbin/lib";
}

sub get_rellib {
    use FindBin qw[$Bin];
    use Cwd qw[getcwd];
    my $relbin = $Bin;
    substr($relbin, 0, length(getcwd()) + 1) = '';
    return "$relbin/lib";
}

sub get_xref {
    my ($xref_opt) = @_;
    $xref_opt //= {};
    my $lib;
    if (defined $xref_opt->{incdir}) {
        $lib = delete $xref_opt->{incdir};
        delete $xref_opt->{abslib};
    } else {
        $lib = delete $xref_opt->{abslib} ? get_abslib() : get_rellib();
    }
    $lib = [ $lib ] unless ref $lib;
    $xref_opt->{INC} //= $lib;
    my $xref = PPI::Xref->new($xref_opt);
    is_deeply($xref->INC, $lib, "test lib set");
    return ($xref, ref $lib ? $lib->[0] : $lib, $lib);
}

sub warner {
    $@ = shift;
    chomp($@);
    print "# warning: $@\n";
}

1;
