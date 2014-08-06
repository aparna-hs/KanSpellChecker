#!/usr/bin/perl

  use strict;
  use warnings;

  print "Enter input file:";
  my $filename = <STDIN>;
  my @fields;
  my $flag;
  my %frequency=("null"=>0);
  my $word;
  my $newfilename="$filename.dic";
  open(FILE1, $filename) or die "Invalid file";
  open (FILE2, ">", $newfilename) || die "Could not open file $newfilename";
  while(<FILE1>)
{
  
  # read the fields in the current record into an array
  @fields = split(' ', $_);
    foreach my $val (@fields) {
    $val =~ s/[^a-zA-Z]*//g;
    my @allkeys = sort keys(%frequency);
    $flag=-1;
    foreach  $word(sort keys(%frequency))
	{
     if ($word eq $val)
	{
     $frequency{$word}++;
     $flag=0;
	}
	}
     if($flag==-1)
	{
     $frequency{$val}=1
	}
    print FILE2 "${val}\n";
  }
}
$newfilename =~ s/\n+/\n/g;   
my $freqnewfile="$filename.freq";
open (FILE3, ">", $freqnewfile) || die "Could not open file $newfilename";
foreach my $i (sort keys (%frequency)) {
   print FILE3 $i . " " . $frequency{$i} . "\n";
}
print "Output written to $newfilename\n";
$freqnewfile =~ s/\n+/\n/g;
print "Output written to $freqnewfile";

close FILE1;
close FILE2;
close FILE3;
  exit 0;
