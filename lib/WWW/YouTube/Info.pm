package WWW::YouTube::Info;

use 5.008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(
  Exporter
);

our @EXPORT = qw(
  get_info
);

our $VERSION = '0.01';

use Carp;
use Data::Dumper;
use LWP::Simple;

=head1 NAME

WWW::YouTube::Info - gain info on YouTube video by VIDEO_ID

=head1 SYNOPSIS

=head2 Perhaps a little code snippet?

  #!/usr/bin/perl
  
  use strict;
  use warnings;
  
  use WWW::YouTube::Info;
  
  # id taken from YouTube video URL
  my $id = 'foobar';
  
  my $yt = WWW::YouTube::Info->new($id);
  
  $yt->get_info();
  
  # hash reference holds values gained via http://youtube.com/get_video_info?video_id=foobar
  # $yt->{title}          # e.g.: Foo+bar+-+Foobar
  # $yt->{author}         # e.g.: foobar
  # $yt->{keywords}       # e.g.: Foo%2Cbar%2CFoobar
  # $yt->{length_seconds} # e.g.: 60
  # $yt->{fmt_map}        # e.g.: 22%2F1280x720%2F9%2F0%2F115%2C35%2F854x480%2F9%2F0%2F115%2C34%2F640x360%2F9%2F0%2F115%2C5%2F320x240%2F7%2F0%2F0
  # $yt->{fmt_url_map}    # e.g.: 22%7Chttp%3A%2F%2Fv14.lscache1.c.youtube.com%2Fvideoplayback%3Fip%3D131.0.0.0 ..
  # $yt->{fmt_stream_map} # e.g.: 22%7Chttp%3A%2F%2Fv14.lscache1.c.youtube.com%2Fvideoplayback%3Fip%3D131.0.0.0 ..
  # ..
  
  # Remark:
  # You might want to check $yt->{status} before further workout,
  # as some videos have copyright issues indicated, for instance, by
  # $yt->{status} ne 'ok'.

=head1 DESCRIPTION

I guess its pretty much self-explanatory ..

=head1 FUNCTIONS

=cut

sub new {
  my ($class, $val) = @_;

  my $self = {};
  $self->{_id} = $val || croak "no VIDEO_ID given!";
  bless($self, $class);

  return $self;
}

sub get_info {
  my ($self) = @_;

  my $id = $self->{_id};

  my $info_url = "http://youtube.com/get_video_info?video_id=$id";

  my $video_info = get($info_url)
    or croak "no get at $info_url - $!";

  my @info = split /&/, $video_info;

  for ( @info ) {
    my ($key, $value) = split /=/;
    $self->{info}->{$key} = $value;
  }

  return $self->{info};
}

1;

__END__

=head2 EXPORT

Exported by default:
get_info

=head1 HINTS

Searching the internet regarding 'fmt_url_map' and/or 'get_video_info' might gain hints/information to improve L<WWW::YouTube::Info>.

=head1 BUGS

Please report bugs and/or feature requests to
C<bug-WWW-YouTube-Info at rt.cpan.org>,
alternatively my means of the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-YouTube-Info>.

=head1 AUTHOR

east

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by east

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut

