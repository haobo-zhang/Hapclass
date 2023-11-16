my $file=$ARGV[0];

my $convertIndelVcfToHapMapoutFile=$file.".hapmap";
open(IN,$file) or die "not find $file!\n";
open(OUT,">$convertIndelVcfToHapMapoutFile");
my $line=<IN>;
while($line=~m/^##.+/){ # discrad anno
	$line=<IN>;
}
chomp $line;
my @a=split "\t",$line; #title
print OUT "rs\talleles\tchrom\tpos\tstrand\tassembly\tcenter\tprotLSID\tassayLSID\tpanelLSID\tQCcode";  #output the title
foreach $i (9 .. $#a){
	print OUT "\t",$a[$i];
}
print OUT "\n"; 
#We restrict that no more than three allels in on indel loci,and we set 0 as G ,1 as A ,2 as C ,3 as T 
#
my %byteMap=("0/0"=>"G","1/1"=>"A","2/2"=>"A","3/3"=>"A","./."=>"-","1/2"=>"T","2/1"=>"T","1/0"=>"C","0/1"=>"C","1/3"=>"T","3/1"=>"T","2/0"=>"C","0/2"=>"C","2/3"=>"T","3/2"=>"T","0/3"=>"C","3/0"=>"C");
my $indelCount=0;
while(<IN>) {
	chomp ;
	my @a=split "\t";
	
	print OUT $a[0]."_".$a[1];  		# chr and pos 
	print OUT "\t",$a[3]."/".$a[4];		# ref and alt 
	print OUT "\t",$a[0],"\t",$a[1];	
	print OUT "\t+\tNA\tNA\tNA\tNA\tNA\tNA";
	my @d=split ",",$a[4];
	
	foreach $i (9 .. $#a){
		my @b=split ":",$a[$i];	
		my $v=$byteMap{$b[0]};
		if ($v){
			print OUT "\t$v";
		}else {
			print OUT "\tN";#if more than three allels will be N
		}  	
	}
	print OUT "\n";
	$indelCount++;
}
close(IN);
close(OUT);
print "$indelCount indel record converted!\n";

my $hapmap=$convertIndelVcfToHapMapoutFile;
my $outFile=$ARGV[0].".csv";
open(IN,$hapmap) or die "not find $hapmap\n";

#<IN>; #REMOVE TITLE
my $count=0;
open(OUT,">$outFile");
while(<IN>){
	chomp;
	my @a =split "\t";
	print OUT $a[2],"\t",$a[3],"\t";
	my $s=$a[11];
	foreach $i (12 .. $#a){
		$s=$s." ".$a[$i];
	}
	print OUT $s,"\n";
	$count++;
}
close(IN);
close(OUT);
print "convert $count snps.\n";


