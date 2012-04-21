use strict; use warnings;
package App::TeXMine;
use feature 'say';

# ABSTRACT: extract information from LaTeX files

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
	return _exec_cmd(\&img,$files,$c->options);
}

=head2 img

=cut


sub img {
	my ($file,$options) = @_;
	my $res = [];
	my $imgpat  = qr/\\(?:includegraphics|pgfimage).*?{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>){
		last if $line =~ m|\\end{document}| and ! $options->{a};
	 	if ($line =~ /$imgpat/p) {
			my $comm = ${^MATCH};
			my $img = $comm;
			$img =~ s/^.*?{(.*?)}/$1/;
			push @$res,$img if $img;
		}
	}
	close $fh;
	return join "\n",(defined($options->{s}) ? sort { lc($a) cmp lc($b) } @$res : @$res);
}


=head2 url_cmd

=cut

sub url_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&url,$files,$c->options);
}

=head2 url

=cut

sub url{
	my ($file,$options) = @_;
	my $res = [];
	my $urlpat  = qr/\\url{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>){
		last if $line =~ m|\\end{document}| and ! $options->{a};
	 	if ($line =~ /$urlpat/p) {
			my $comm = ${^MATCH};
			my $url = $comm;
			$url =~ s/^.*?{(.*?)}/$1/;
			say $url;
			push @$res,$url if $url;
		}
	}
	close $fh;
	return join "\n",(defined($options->{s}) ? sort { lc($a) cmp lc($b) } @$res : @$res);
}

=head2 bib_cmd

=cut

sub bib_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&bib,$files,$c->options);
}

=head2 bib

=cut

sub bib {
	my ($file,$options) = @_;
	my $res = [];
	my $citepat = qr/\\(?:no)?cite{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>){
		last if $line =~ m|\\end{document}| and ! $options->{a};
	 	if ($line =~ /$citepat/p) {
			my $comm = ${^MATCH};
			my $cite = $comm;
			$cite =~ s/^.*?{(.*?)}/$1/;
			push @$res,(split /,/,$cite);
		}
	}
	close $fh;
	return join "\n",(defined($options->{s}) ? sort { lc($a) cmp lc($b) } @$res : @$res);
}

=head2 index_cmd

=cut

sub index_cmd {
	my $c = shift;
	my $files = $c->argv;
	return _exec_cmd(\&index,$files,$c->options);
}

=head2 index

=cut

sub index {
	my ($file,$options) = @_;
	my $res;
	my $secpat  = qr/\\(?:sub)*section{.*?}/;
	my $chpat   = qr/\\chapter{.*?}/;
	my $fh = _open_file($file);
	while (my $line = <$fh>) {
		last if $line =~ m|\\end{document}| and ! $options->{a};
		if ($line =~ /$chpat/p) {
			my $comm = ${^MATCH};	
			my $chap = $comm;
			$chap =~ s/^.*?{(.*?)}/$1/;
			$res.="$chap\n";
		}
		if ($line =~ /$secpat/p){
			my $comm = ${^MATCH};	
			my $sec = $comm;
			$sec =~ s/^.*?{(.*?)}/$1/;
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
	my ($func,$files,$options) = @_;
	my $res;
	foreach my $file (@$files){
		$res.= $func->($file,$options);
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
