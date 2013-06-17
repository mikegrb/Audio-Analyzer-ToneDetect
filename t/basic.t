use strict;
use Test::More;
use Audio::Analyzer::ToneDetect;

use FindBin;

{
    my $td = Audio::Analyzer::ToneDetect->new(
        source => "${FindBin::Bin}/data/01.wav" );

    is( ref $td, 'Audio::Analyzer::ToneDetect',
        'object blessed w/ correct class' );
    is( $td->get_next_two_tones, '984.375 640.625', 'get two tones scalar' );

    {
        my @two = $td->get_next_two_tones;
        ok( @two, 'get two tones list...' );
        is( $two[0], 1515.625, '   ... tone a' );
        is( $two[1], 1234.375, '   ... tone b' );
    }
}

{
    my $td = Audio::Analyzer::ToneDetect->new(
        source      => "${FindBin::Bin}/data/01.wav",
        valid_tones => 'builtin'
    );

    is( $td->get_next_two_tones, '984.4 640.6',
        'valid_tones corrects tones to closest valid' );

    my @tone_with_error = $td->get_next_tone;
    ok( @tone_with_error, 'get_next_tone in list context w/valid list' );
    is( $tone_with_error[0], '1530.0', '   ... closest valid tone is correct' );
    is( $tone_with_error[1], '-14.375', '   ... delta detected to valid is correct' );
}

done_testing;
