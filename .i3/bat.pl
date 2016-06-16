#!/usr/bin/perl
#
# Copyright 2014 Pierre Mavro <deimos@deimos.fr>
# Copyright 2014 Vivien Didelot <vivien@didelot.org>
#
# Licensed under the terms of the GNU GPL v3, or any later version.
#
# This script is meant to use with i3blocks. It parses the output of the "acpi"
# command (often provided by a package of the same name) to read the status of
# the battery, and eventually its remaining time (to full charge or discharge).
#
# The color will gradually change for a percentage below 85%, and the urgency
# (exit code 33) is set if there is less that 5% remaining.

use strict;
use warnings;
use utf8;

my $acpi;
my $status;
my $percent;
my $full_text;
my $short_text;

# print utf-8 chars directly and redirect stderr to stdout
binmode STDOUT, ':encoding(UTF-8)';
*STDERR = *STDOUT;

# read the first line of the "acpi" command output
open (ACPI, 'acpi -b |') or die "Can't exec acpi: $!\n";
$acpi = <ACPI>;
close(ACPI);

# fail on unexpected output
if ($acpi !~ /: (\w+), (\d+)%/) {
	die "$acpi\n";
}

$status = $1;
$percent = $2;
$full_text = "⚡";

if ($status eq 'Discharging') {
	$full_text .= '↘';
} elsif ($status eq 'Charging') {
	$full_text .= '↗';
}

$full_text .= " $percent%";
$short_text = $full_text;

if ($acpi =~ /, (\d+:\d+):\d+/) {
	$full_text .= " ($1)";
}

# print text
print "$full_text\n";
print "$short_text\n";

# and color, eventually
if ($percent < 20) {
	print '#FF0000\n';
} elsif ($percent < 40) {
	print '#FFAE00\n';
} elsif ($percent < 60) {
	print '#FFF600\n';
} elsif ($percent < 85) {
	print '#A8FF00\n';
}

# set urgent flag if below 5% and discharging
exit($percent < 5 && $status eq 'Discharging' ? 33 : 0);
