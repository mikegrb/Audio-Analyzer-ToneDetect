# NAME

Audio::Analyzer::ToneDetect - Detect freq of tones in an audio file or stream

# SYNOPSIS

    use Audio::Analyzer::ToneDetect;
    my $tone_detect = Audio::Analyzer::ToneDetect->new( source => \*STDIN );
    my $tone = $tone_detect->get_next_tone();
    say "I heard $tone!";

# DESCRIPTION

Consider this alpha software.  It is still under fairly active development and
the interface may change in incompatible ways.

Audio::Analyzer::ToneDetect is a module for detecting single frequency tones
in an audio stream or file.  It supports mono PCM data and defaults to STDIN.
For supporting other formats, eg MP3, you can pipe things through sox.

# USAGE

## new (%opts)

Takes the following named parameters:

- source \\\*FH or $path

    The audio source.  Only Mono PCM is supported.  You can pass the path to a WAV
    file or a file handle for an open file or stream.  Defaults to STDIN.



- sample\_rate 16000

    Source sample rate, results will be orders of magnitude off if set incorrectly.
    Defaults to 16000.

- chunk\_size 1024

    Number of samples to analyze at once.  Corresponds to dft\_size in [Audio::Analyzer](http://search.cpan.org/perldoc?Audio::Analyzer).
    Must be a power of 2.  Defaults to 1024.

- chunk\_max 70

    Maximum number of chunks to process before returning.  Returns false if it
    reaches this number of chunks without detecting a tone. With default chunk\_size
    and sample\_rate, the default of 70 equates to about 4.5 seconds of audio.

- min\_tone\_length 0.5

    Minimum durration of a tone, in seconds, before we consider it detected.  Due to
    sample rate, chunk size, and integer math, with defaults this ends up being
    0.448 seconds.  The formula for actual seconds is int( min\_length \* sample\_rate
    / chunk\_size ) \* chunk\_size / sample\_rate.  Default to 0.5

- valid\_tones undef, 'builtin', or ARRAYREF

    A list of valid (expected) tones.  If supplied, the closest expected tone for
    a given detected tone is returned. Call get\_next\_tone() in list context or
    supply the following call back if you want both values.  A value of 'builtin'
    uses a builtin list of valid classic Motorola Minitor tones.  Defaults to unset.

- valid\_error\_cb

    A callback that if provided and valid\_tones is set will be called just before
    get\_next\_tone or find\_closest\_valid returns.  Arguments are the closest valid
    tone, the actual detected tone, the diference between the two in Hertz.

    Example:

        valid_error_cb => sub { printf "VF %s DF %s EF %.2f\n", @_; return }

    Return value is expected to be one of three possibilities.

    - undef

        Has no effect on program flow, if you don't want your call back changing stuff
        make sure you have an explicit 'return' as the last line.

    - A return value of 0 discards the tone and continues the get\_next\_tone loop.
    - N

        Any other value replaces the valid detected tone with the return value from the
        call back.

- rejected\_freqs undef or ARRAYREF

    If specified, a reference to an array of frequencies that will be ignored. e.g
    roger beeps, repeater beeps, etc.  Note, if you use valid tone detection, then
    this is the raw detected tone, not the closest match.  Defaults to empty list.

## valid\_tones

Returns the arraref of valid tones currently being used.  Optionally takes a
reference to an array of new tones to use as the valid list.  Make sure the list
is in numerical order as an optimization is used for searching for the closest
match that requires it be in order.



## get\_next\_tone

Returns the next detected tone in the stream.  Will return false if we go
through chunk\_max without detecting a tone but the buffer will be preserved
between calls if the a tone begins just before hitting chunk\_max.  If valid\_tones
was supplied, returns the result of passing the tone to find\_closest\_valid(),
following it's list vs scalar semantics.

## get\_next\_two\_tones

Calls get next tone twice.  Will return false if either tone returns false.

## find\_closest\_valid

In scalar context, returns the closest valid tone in valid\_tones.  In list
context returns the closest valid tone and the delta from detected tone.

# AUTHOR

Mike Greb <michael@thegrebs.com>

# COPYRIGHT

Copyright 2013 - Mike Greb

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Audio::Analyzer](http://search.cpan.org/perldoc?Audio::Analyzer)

[Math::FFT](http://search.cpan.org/perldoc?Math::FFT)
