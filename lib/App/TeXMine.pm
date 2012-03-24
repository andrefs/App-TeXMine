package App::TeXMine;

use 5.014;
use strict;
use warnings;
use feature 'say';

=head1 NAME

App::TeXMine - extract information from LaTeX files

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01_03';


=head1 SYNOPSIS

texmine command file.tex

Run C<texmine help> for more options

=head1 DESCRIPTION

texmine is a script to quickly inspect the contents of a LaTeX file,
such as image references, URLs, table of contens and citations.

=head1 SUBROUTINES/METHODS


=head2 img_cmd

=cut

sub img_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&img,$files);
}

=head2 img

=cut


sub img {
	my $file = shift;
	my $res = [];
	my $imgpat  = qr/\\(?:includegraphics|pgfimage).*?{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>){
	 	if ($line =~ /$imgpat/p) {
			my $comm = ${^MATCH};
			my $img = $comm =~ s/^.*?{(.*?)}/$1/r;
			push @$res,$img if $img;
		}
	}
	close $fh;
	return join "\n",@$res;
}


=head2 url_cmd

=cut

sub url_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&url,$files);
}

=head2 url

=cut

sub url{
	my $file = shift;
	my $res = [];
	my $urlpat  = qr/\\url{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>){
	 	if ($line =~ /$urlpat/p) {
			my $comm = ${^MATCH};
			my $url = $comm =~ s/^.*?{(.*?)}/$1/r;
			say $url;
			push @$res,$url if $url;
		}
	}
	close $fh;
	return join "\n",@$res;
}

=head2 bib_cmd

=cut

sub bib_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&bib,$files);
}

=head2 bib

=cut

sub bib {
	my $file = shift;
	my $res = [];
	my $citepat = qr/\\(?:no)?cite{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>){
	 	if ($line =~ /$citepat/p) {
			my $comm = ${^MATCH};
			my $cite = $comm =~ s/^.*?{(.*?)}/$1/r;
			say foreach split /,/,$cite ;
			push @$res,$cite if $cite;
		}
	}
	close $fh;
	return join "\n",@$res;
}

=head2 index_cmd

=cut

sub index_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&index,$files);
}

=head2 index

=cut

sub index {
	my $file = shift;
	my $res;
	my $secpat  = qr/\\(?:sub)*section{.*?}/;
	my $chpat   = qr/\\chapter{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>) {
		if ($line =~ /$chpat/p) {
			my $comm = ${^MATCH};	
			my $chap = $comm =~ s/^.*?{(.*?)}/$1/r;
			$res.="$chap\n";
		}
		if ($line =~ /$secpat/p){
			my $comm = ${^MATCH};	
			my $sec = $comm =~ s/^.*?{(.*?)}/$1/r;
			my $tabs = 0;
	
			$tabs++ while ($comm =~ s/sub//g);
			
			$res.= "    "x$tabs;
			$res.=" - $sec\n";
		}
	}
	close $fh;
	return $res;
}


sub _open_file {
	my ($file) = @_;
	open my $fh, '<', $file or die "Could not open file '$file': $!";
	return $fh;
}

sub _exec_cmd {
	my ($func,$files) = @_;
	my $res;
	foreach my $file (@$files){
		$res.= $func->($file);
	}
	return $res;
}

=head1 AUTHOR

Andre Santos, C<< <andrefs at cpan.org> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::TeXMine

=head1 DEVELOPMENT

=head2 Repository

L<http://github.com/andrefs/app-texmine>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Andre Santos.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of App::TeXMine
