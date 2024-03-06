#!/usr/bin/perl

use warnings;
use strict;

=begin comment

    c64melody.pl 1.0 - Prints C64 BASIC code to produce a humble one voice melody. 
                       Calculates frequencies for musical notes on C64's SID chip (PAL model).

                       Use the additional "create_d64" script to convert the output
                       to a ".d64"-file to be used in the emulator "Vice".

    Copyright (C) 2024 H. Lubenow

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

# ----------------------------------
# Settings:

# Defaults: volume 15, attack_decay 28, sustain_release 192, waveform "saw", speed 35.

my %OPTIONS = (volume          => 15,
               attack_decay    => 28,
               sustain_release => 25,
               waveform        => "square",
               speed           => 50,
               songpause       => 800);

# Melody notation. Example "UK Hymn":
# Note-name and delay-value for note-length:
my @melody = (["f4", 3], ["f4", 4], ["g4", 4], ["e4", 5], ["f4", 2], ["g4", 4],
              ["a4", 3], ["a4", 4], ["b4", 4], ["a4", 5], ["g4", 2], ["f4", 4],
              ["g4", 4], ["f4", 4], ["e4", 4], ["f4", 8]);

my $LINENRSTART = 10;
my $LINENRSTEP  = 10;

# ----------------------------------
# Functions:

sub getFrequencyValues {

    # Instructions from:
    # https://codebase64.org/doku.php?id=base:how_to_calculate_your_own_sid_frequency_table

    my $distance_to_a4 = shift;
    my $hertzfreq = 440 * 2 ** ($distance_to_a4 / 12);
    my $pal_cevi_freq = 17.02841924 * $hertzfreq;
    return [int($pal_cevi_freq / 256), $pal_cevi_freq % 256];
}

sub getNotesHash {
    my @notenames = qw(a b h c cis d dis e f fis g gis);
    my $i;
    my $n = 0;
    my $o = 0;
    my %notes;
    # Notes a0 to h7:
    for $i (-48 .. 38) {
        if ($notenames[$n] eq "c") {
            $o++;
        }
        $notes{$notenames[$n] . $o} = getFrequencyValues($i);
        # print $notenames[$n] . $o . "\t";
        $n++;
        if ($n > 11) {
            $n = 0;
        }
    }
    return \%notes;
}

sub getGotoLabel {
    my $gotoline = shift();
    my @b = split(/goto /, $gotoline);
    return pop(@b);
}

sub getGotoDestination {
    my $gotolabel= pop();
    my @a = @_;
    my @b;
    my $i;
    for $i (@a) {
        if ($i =~ /$gotolabel/ && $i =~ /rem / && $i !~ /goto /) {
            @b = split(/ /, $i);
            return shift(@b);
        }
    }
}

# ----------------------------------
# Main:

my @a = <DATA>;
close(DATA);

my ($i, $i2, $u, $gotodest, $gotolabel, $s, $e);
my (@b, @c, @d, @code, @temp);

my $melodylength       = $#melody + 1;
my $n                  = $LINENRSTART;
my %waveforms          = (square => 17, saw => 33);
$OPTIONS{waveform_on}  = $waveforms{$OPTIONS{waveform}};
$OPTIONS{waveform_off} = $OPTIONS{waveform_on} - 1;

my @replaces           = (["MELODYLENGTH" , $melodylength],
                          ["SPEED", $OPTIONS{speed}],
                          ["ATTACKDECAY", $OPTIONS{attack_decay}],
                          ["SUSTAINRELEASE",  $OPTIONS{sustain_release}],
                          ["VOLUME", $OPTIONS{volume}],
                          ["WAVEFORMON", $OPTIONS{waveform_on}],
                          ["WAVEFORMOFF", $OPTIONS{waveform_off}],
                          ["SONGPAUSE", $OPTIONS{songpause}]);

my %notes = %{ getNotesHash() };

for $i (@a) {
    chomp($i);
    if ($i eq "") {
        next;
    }
    $i2 = "$n $i";
    push(@b, $i2);
    $n += $LINENRSTEP;
}

for $i (@melody) {
    @c = @{ $i };
    @d = @{ $notes{$c[0]} };
    $s = "$n data $d[0], $d[1], $c[1]: rem $c[0]";
    push(@code, $s);
    $n += $LINENRSTEP;
}

for $i (@b) {
    $i2 = $i;
    $gotodest = getGotoDestination(@b, getGotoLabel($i2));
    $gotodest = getGotoDestination(@b, getGotoLabel($i2));
    if ($i2 =~ /goto/) {
        $gotolabel = getGotoLabel($i2);
        $gotodest = getGotoDestination(@b, $gotolabel);
        $i2 =~ s/$gotolabel/$gotodest/;
    }
    for $u (@replaces) {
        @temp = @{$u};
        if ($i2 =~ $temp[0]) {
            $i2 =~ s/$temp[0]/$temp[1]/;
        }
    }
    print "$i2\n";
}

for $i (@code) {
    print "$i\n";
}

# ----------------------------------
# Data
#
# C64 BASIC code from ancient examples, as seen in documents such as:
# https://www.commodore.ca/manuals/c64_users_guide/c64-users_guide-07-creating_sound.pdf

__DATA__
dim v%(102, 3)
f = 1: rem firsttart
rem initsound
s = 54272
for i = 0 to 24: poke s + i, 0: next i
poke s + 24, VOLUME
poke s + 5, ATTACKDECAY
poke s + 6, SUSTAINRELEASE
w = s + 4
poke w, WAVEFORMON
rem
rem read in data
l = MELODYLENGTH
for i = 1 to l
read v%(i,1), v%(i,2), v%(i,3)
next i
rem
rem startmelody
if f = 0 then for d = 1 to SONGPAUSE: next d
rem n = notenumber: t = timecounter: notelength = v%(n, 3)
n = 1
t = 0
rem pokenoteon
poke s + 1, v%(n,1)
poke s, v%(n,2)
poke w, WAVEFORMON
for d = 1 to SPEED: next d
t = t + 1
rem if timecounter == notelength: volume = off; notenumber++; timecounter = 0;
if t = v%(n, 3) then t = 0: n = n + 1: poke w,WAVEFORMOFF
if n = l + 1 then f = 0: goto startmelody
rem if timecounter < notelength: timecounter++; poke note on (which, depends on notenumber)
goto pokenoteon
rem
