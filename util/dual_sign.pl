#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

use Path::Tiny qw(path);

my $keys = { 
    new => 'E854324B1366A820',
    old => 'ECD2C675C102CDA4',
};

for my $key ( sort keys %{$keys} ) {
    path('.')->child('99-keyid.' . $key )->spew($keys->{$key});
    for my $file ( qw( 00_Contact.mkdn 01_Message.mkdn ) ) {
        my $source = path('.')->child( $file );
        my $target = path('.')->child( $file . '-' . $key . '.asc' );
        system(
            'gpg', '-u', $keys->{$key}, '-a', '-o', $target->stringify, '--detach-sign', $source->stringify 
        ) == 0 or die;
    }

    system(
        'gpg', '-a', '-o', '99-pubkey.'.$key . '.gpg', '--export', $keys->{$key}
    ) == 0 or die;
}
