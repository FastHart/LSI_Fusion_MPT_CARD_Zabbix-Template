#! /usr/bin/perl
#use strict;
use Data::Dumper;

my $sas2ircu = '/etc/zabbix/scripts/sas2ircu';

my %drives;
my %volumes;

# Find  all LSI cards
my @cards = `$sas2ircu LIST 2>/tmp/LSI_card.discovery.err | sed -E 's/\\s+//' | grep '^[0-9]' | awk '{print \$1}'`;
chomp @cards;

# Find drives on each card and add to hash of hash of arrays %drives{card_id}{enclosure}[slot]
foreach my $card (@cards) {
    my @OUT =  `$sas2ircu $card DISPLAY`;
    chomp @OUT;
    my $enclosure; my $slot; my $i=0;
    foreach my $line (@OUT) {
        if ( $line =~ /.*Hard disk.*/) {
            $enclosure = $1 if ( @OUT[$i+1] =~ /.*Enclosure.+(\d+)$/);
            $slot = $1 if ( @OUT[$i+2] =~ /.*Slot.+(\d+)$/);
        }
    $i++;
    push (@{$drives{$card}{$enclosure}}, $slot) if ( defined $enclosure && defined $slot );
    undef $enclosure; undef $slot;
    }
}
# print Dumper \%drives;
#exit;

# Output in json format
print "{\n";
print "\t\"data\":[\n\n";

my $i=0;
foreach my $card (keys %drives){
    foreach my $enclosure ( keys %{$drives{"$card"}} ) {
        foreach my $slot ( @{$drives{$card}{$enclosure}} ) {
            print ",\n" if $i > 0; $i++;
            print "\t{\n";
            print "\t\t\"{#CARD_ID}\":\"$card\",\n";
            print "\t\t\"{#ENCLOSURE}\":\"$enclosure\",\n";
            print "\t\t\"{#SLOT}\":\"$slot\"\n";
            print "\t}";
        }
    }
}
print "\n\t]\n";
print "}\n";
