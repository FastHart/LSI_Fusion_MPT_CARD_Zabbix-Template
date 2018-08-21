#! /usr/bin/perl
#use strict;
use Data::Dumper;

my $sas2ircu = '/etc/zabbix/scripts/sas2ircu';

my %cards;
my %volumes;

# Find  all LSI cards
# ./sas2ircu LIST 2>/dev/null | sed -E 's/\s+//' | grep '^[0-9]' | awk '{print $1}'
my @cards = `$sas2ircu LIST 2>/tmp/LSI_card.discovery.err | sed -E 's/\\s+//' | grep '^[0-9]' | awk '{print \$1}'`;
chomp @cards;

# Find volumes on each card and add to hash of arrays %cards{card_id}[vol_id]
foreach my $card (@cards) {
    my @vol_ids =  `$sas2ircu $card status | grep 'Volume ID' | awk '{print \$4}'`;
    chomp @vol_ids;
    $cards{$card}=\@vol_ids;
}
# print Dumper \%cards;


# Output in json format
print "{\n";
print "\t\"data\":[\n\n";

my $i=0;
foreach my $card (keys %cards){
    foreach my $vol ( @{$cards{$card}} ) {
        print ",\n" if $i > 0; $i++;
        print "\t{\n";
        print "\t\t\"{#CARD_ID}\":\"$card\",\n";
        print "\t\t\"{#VOL_ID}\":\"$vol\"\n";
        print "\t}";
    }
}
print "\n\t]\n";
print "}\n";
