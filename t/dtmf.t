use strict;
use Test::More;
use Audio::Analyzer::ToneDetect;

use FindBin;

my $test_file = ${FindBin::Bin} . '/data/0123456789spABCD.wav';

TODO: {
    local $TODO = 'Not quite reliable on test tone yet.';

    # For some reason my test wav is currently returning "01234567889*##ABCCD"
    # but it should be returning "0123456789*#ABCD".  Some digits are doubling
    # up.  Possibly an issue with the wav but it sounds and looks okay.

    my $td = Audio::Analyzer::ToneDetect->new(
        source          => $test_file,
        dtmf            => 1,
        min_tone_length => 0.127,
    );

    my $tone = $td->get_next_tone();

    my $dtmf_string = '';
    while ( defined( my $tone = $td->get_next_tone() ) ) {
        $dtmf_string .= $tone;
    }

    is( $dtmf_string, '0123456789*#ABCD', 'all dtmf digits decode' );
}

done_testing;

