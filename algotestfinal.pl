#!/usr/bin/perl

  use strict;
  use warnings;

  print "Enter input file:";
  my $filename = <STDIN>;
  open(FILE1, $filename) or die "Invalid file";
  my $curword;
  my $pos;
  my $laststateror;
  my $prevword;
  my $laststate;
  my $curprefix;
  my $count=0;
  my @register;
  my %info;
  my %automata;
  my $toprint;
  my $firstword=0;
  while(<FILE1>)
{

 my $r;
 $curword=$_;
 chomp $curword;
 
 if($count!=0)
 { 
 my $xor= "$prevword" ^ "$curword";
 $xor =~ /^\0*/;
 $r = $+[0];
 $curprefix=substr $curword,0,$r;
 $prevword=$curword
 }
 else
 {
 $curprefix=undef;
 $r=0;
 $prevword=$curword;
 }
 if($r==0)
    {
	$laststate=0;
    }
 else
{
    $laststate=&getlaststate();
    
}
 
 #$laststate=getlaststate(curprefix);
 #haschildren
 my $cursuffix=substr($curword,$r);
 my @letters=("a".."z");
 my $req_key;
 $pos=25;
 do{
  my $f1=$letters[$pos];
  my $f2=uc($f1);
  my $key=$laststate.$f1;
  my $keyup=$laststate.$f2;
  if (exists $automata{$key}) {
        $laststateror=$laststate;
	&ror();    
	$pos=0;
  }
 else{
  if (exists $automata{$keyup}) {
        $laststateror=$laststate;
	&ror();    
	$pos=0;
  }}
  $pos--;
  }while($pos>=0);  
  #..haschildren 
  #adding states
my @tobeadded=split(//,$cursuffix);
my $thisflag=0;
foreach my $w(@tobeadded)
 {
my $keynew;

if($thisflag==0)
{
$info{$laststate}=0;
$keynew="$laststate$w";
$thisflag++;
}
else
{
$info{$count}=0;
$keynew="$count$w";

}
$count++;
$automata{$keynew}=$count;
}
 
$info{$count}=1;
}

#call function ror with state 0
$laststateror=0;
&ror(); 

#test printing assoc array

foreach $toprint(keys %automata)
{
print $toprint;
print ">";
print $automata{$toprint};
print "\n";
}
$firstword++;
#fucntion getlaststate
sub getlaststate
{
 my @curletters=split(//,$curprefix);
 my $statecount=0;
 foreach my $x(@curletters)
 {
   my $thiskey=$statecount.$x;
   $statecount=$automata{$thiskey};
 }
  $statecount;
}
 

#function r.o.r
sub ror
{
 my $st=$laststateror;

 my @letters=("a".."z");
 my $req_key;
 my $posror=25;
 my $lastchild;
 do{
  my $f2=$letters[$posror];
  my $f3=uc($f2);
  my $lastchildkey=$st.$f2;
  my $lastchildkeyup=$st.$f3;
  if (exists $automata{$lastchildkey}) {
    $req_key=$lastchildkey;
    $posror=0;
  }
  else {if (exists $automata{$lastchildkeyup}) {
    $req_key=$lastchildkeyup;
    $posror=0;
  }}
  $posror--;
  }while($posror>=0); 
 $lastchild=$automata{$req_key};
 my $child=$lastchild;
 #haschildren(child)
 my $flag=-1;
 $posror=0;
 while($posror<=25)
 {
  my $f3=$letters[$posror];
  my $k=$child.$f3;
  my $k1=$child.uc($f3);
  if (exists $automata{$k} || exists $automata{$k1})
  {
    $flag=0;
    last;
   }
  $posror++;
 }
 if($flag==0)
{#child has children
 #call fucntion ror with child as parameter
 $laststateror=$child;
 &ror();
}
 my $temp=-1;
 foreach my $reg(@register)
{
 my $s1=$info{$reg};
 my $s2=$info{$child};
 if($s1 eq $s2)#both final or both non-final
 {
 #call function to check for element by element equivalence
 
 my $ret_value=&check_equ($reg,$child,1);
 if($ret_value==1)
{
 $ret_value=&check_equ($reg,$child,0);
}
 if($ret_value == 1)
 {
  $automata{$req_key}=$reg;
  $posror=0;
  do{
  my $f3=$letters[$posror];
  my $thiskey=$child.$f3;
  my $thiskeyupp=$child.uc($f3);
  if (exists $automata{$thiskey}) 
	{
	delete $automata{$thiskey};
        }
  if (exists $automata{$thiskeyupp}) 
	{
	delete $automata{$thiskeyupp};
        }
  $posror++;
  }while($posror<=25); 
  
  $temp=0;
  last;
 }
 }
}
if($temp == -1)
{
push(@register,$child);
}
}#end of ror

sub check_equ
{

 my $var1=$_[0];
 my $var2=$_[1];
 my $sentflag=$_[2];
 my $retval1=1;
 my @letters=("a".."z");
 my $retval0=0;
 my $k;
 my $j;
 my $flag=-1;
 $pos=0;
 my $checkvar=0;
 while($pos<=25)
 {
if($sentflag==1){
   $k=$var2.$letters[$pos];
   $j=$var1.$letters[$pos];}
else
{
 $k=$var2.uc($letters[$pos]);
 $j=$var1.uc($letters[$pos]);}

  if(exists $automata{$k})
  {
    $checkvar=1;
    if(exists $automata{$j})
    {
     if($automata{$k} != $automata{$j})
    {
      $flag=0;
      last;
    }
    }
    else
 {
   $flag=0;
   last;
 }
 }
 if($checkvar==0 && exists $automata{$j})
 {
$flag=0;
last;
 }
 $pos++;
 $checkvar=0;
 }
if($flag == -1)
{
$retval1;
}
else
{
$retval0;
}
}#end of check_equs
 
  
  
