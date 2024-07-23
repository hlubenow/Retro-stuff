#!/usr/bin/perl

use warnings;
use strict;

=begin comment

    compile_zx.pl 1.0 - Runs commands for cross compiling
                        ZX Spectrum assembly code with "z80masm"
                        and "bin2tap".

    Copyright (C) 2024 hlubenow

    This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

=end comment

=cut

if ($#ARGV < 0) {
    print "\nUsage: compile_zx.pl [program.asm]\n\n";
    exit 1;
}

sub clean {
    my $fpref = shift;
    my @sufs = qw(o bin tap err);
    my $i;
    my $e;
    my $rmfile;
    for $i (@sufs) {
        $rmfile = "$fpref.$i";
        if (-e $rmfile) {
            $e = "rm $rmfile";
            system($e);
            print "'$rmfile' was removed.\n";
        }
    }
}

my $fname = $ARGV[0];
if (substr($fname, -4) ne ".asm") {
    print "\nError: Filename should end with '.asm'.\n\n";
    exit 2;
}
my $fpref = substr($fname, 0, -4);

print "\n";

# clean($fpref);

print "\n";

my $binfile = "$fpref.bin";
# my $e = "z80asm -b \"$fname\"";
my $e = "z80masm \"$fname\" \"$binfile\"";
print "$e\n";
system($e);
if (-e $binfile) {
    print "'$binfile' was created.\n";
    $e = "bin2tap -b -cb 7 -cp 7 -ci 0 \"$binfile\"";
    print "$e\n";
    system($e);
} else {
    print "\nError: Compilation of '$fname' failed.\n\n";
    exit 3;
}
my $tapfile = "$fpref.tap";
if (-e $tapfile) {
    print "'$tapfile' was created.\n";
} else {
    print "\nError: '$tapfile' wasn't created.\n\n";
    exit 4;
}

print "\nRun '$tapfile' (y/n)? ";
my $answer = <STDIN>;
chomp($answer);
if ($answer eq "y") {
    $e = "fuse -g paltv3x $tapfile";
    system($e);
}

