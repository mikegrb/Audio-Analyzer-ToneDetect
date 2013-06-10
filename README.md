# NAME

Audio::Analyzer::ToneDetect - Detect freq of tones in an audio file or stream

# SYNOPSIS

    use Audio::Analyzer::ToneDetect;
    my $tone_detect = Audio::Analyzer::ToneDetect->new( source => \*STDIN );
    my $tone = $tone_detect->get_next_tone();
    say "I heard $tone!";

# DESCRIPTION

Audio::Analyzer::ToneDetect is a module for detecting single frequency tones
in an audio stream or file.  It supports mono PCM data and defaults to STDIN.
For supporting other formats, eg MP3, you can pipe things through sox.

# USAGE

## new

This needs docs

## get\_next\_tone

Returns the next detected tone in the stream.  Will return false if we go
through chunk\_max without detecting a tone but the buffer will be preserved
between calls if the a tone begins just before hitting chunk\_max.

## get\_next\_two\_tones

Calls get next tone twice.  Will return false if either tone returns false.

## find\_closest\_valid

In scalar context, returns the closest valid tone in valid\_tones.  In list
context returns the closest valid tone and the delta from detected tone.

# AUTHOR

Mike Greb <michael@thegrebs.com>

# COPYRIGHT

Copyright 2013- Mike Greb

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
