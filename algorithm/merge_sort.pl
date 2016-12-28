!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Data::Dumper;

if (!@ARGV) {
    exit 1;
}

my @arr = @ARGV;

if (@ARGV >= 2) {
    sort_once(\@arr);
    merge(\@arr);

    print Dumper(@arr);
} elsif (@ARGV == 1) {
    print $ARGV[1]
}

sub sort_once {
    my $source = shift;
    my $size = @$source;

    for (my $i=0; 2*$i<$size - 1; $i++) {
        my ($first, $second) = @$source[2*$i, 2*$i+1];
        if ($first < $second) {
            @$source[2*$i, 2*$i+1] = ($first, $second);
        } else {
            @$source[2*$i, 2*$i+1] = ($second, $first);
        }
    }
}

sub merge {
    my $source = shift;
    my $size = @$source;

    my ($main_index, $index1, $index2) = (0, 0, 0);
    my $unit_size = 2;
    while (my $i < $size) {
        for (my $j=0;;$j++) {
            my @sub_arr1 = @$source[$j, $j+$unit_size];
            my @sub_arr2 = @$source[$j+$unit_size+1, $j+$unit_size*2];
#            ($index1, $index2) = ($unit_size*$j, $unit_size*($j+1));
            while ($index1 < $j + $unit_size || $index2 < $j + $unit_size*2) {
                if ($index1 == $unit_size) {
                    $source->[$main_index] = $sub_arr2[$index2];
                    $index2++;
                } elsif ($index2 == $unit_size) {
                    $source->[$main_index] = $sub_arr1[$index1];
                    $index1++;
                } elsif ($sub_arr1[$index1] < $sub_arr2[$index2]) {
                    $source->[$main_index] = $sub_arr1[$index1];
                    $index1++;
                } else {
                    $source->[$main_index] = $sub_arr2[$index2];
                    $index2++;
                }

                $main_index++;
            }

        }
    }
}

