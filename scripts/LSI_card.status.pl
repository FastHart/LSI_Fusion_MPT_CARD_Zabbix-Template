#! /usr/bin/perl
use strict;
use Switch;

my $sas2ircu = '/etc/zabbix/scripts/sas2ircu';

my $OUT;
my $command=shift;


switch ($command) {
    case "get_volume_status" { $OUT=`$sas2ircu @ARGV[0] STATUS | egrep -A+4 "Volume ID\\s+: @ARGV[1]" | grep 'Volume state' | awk '{print \$4}'`; print $OUT;}
    case "get_drive_state" { $OUT=`$sas2ircu @ARGV[0] DISPLAY | grep -i -A11  "Hard disk" | egrep -i -A 9 'Enclosure.+@ARGV[1]' | egrep -i -A8 'Slot.+@ARGV[2]' | grep -i "State"  | awk {'print \$3'}`; print $OUT; }
    case "get_drive_info" { $OUT=`$sas2ircu @ARGV[0] DISPLAY | grep -i -A11  "Hard disk" | egrep -i -A 9 'Enclosure.+@ARGV[1]' | egrep -i -A8 'Slot.+@ARGV[2]' | grep -i "@ARGV[3]"  | awk -F\: {'print \$2'}`; print $OUT; }
    else		{ print "previous case not true" }
}
