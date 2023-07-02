use strict;




my $gffFile = $ARGV[0];
my $blast6File = $ARGV[1];
my $chrNamToTake = $ARGV[2];
my $outFile = $ARGV[3];


my $chrNamToTakeAnother = "";
if($chrNamToTake eq "O7_R7")
{
	$chrNamToTakeAnother = "R7_O7";
}
else
{
	if($chrNamToTake eq "R7_O7")
	{
		$chrNamToTakeAnother = "O7_R7";
	}
	else
	{
		if(substr($chrNamToTake,0,1) eq "O")
		{
			$chrNamToTakeAnother = "R".substr($chrNamToTake,1);
		}
		else
		{
			if(substr($chrNamToTake,0,1) eq "R")
			{
				$chrNamToTakeAnother = "O".substr($chrNamToTake,1);
			}
		}
	}
}




open(FTW,">$outFile") or die;

my @gffGenesList = ();


my %correspondGenesOfHomSp = ();
my %pairsRecorded = ();


open(FTR,"<$blast6File") or die;

while(my $input = <FTR>)
{
	chomp($input);
	my @arrInp = split(/\t/,$input);
	
	my $gNam1 = $arrInp[0];
	my $gNam2 = $arrInp[1];
	my $identity = $arrInp[2];
	
	next if($identity < 70);
	#next if(exists $correspondGenesOfHomSp{"$gNam1"});
	
	my @arrGeneNam = split(/\./,$gNam1);
	$gNam1 = $arrGeneNam[0];
	for(my $i = 1;$i < $#arrGeneNam;$i++)
	{
		$gNam1 = $gNam1.".".$arrGeneNam[$i];
	}
	print "$gNam2";
	@arrGeneNam = split(/\./,$gNam2);
	$gNam2 = $arrGeneNam[0];
	my $currGNam2ChrNam = $arrGeneNam[1];
	print "\t$currGNam2ChrNam\t$chrNamToTakeAnother\n";
	next if($currGNam2ChrNam ne $chrNamToTakeAnother);
	for(my $i = 1;$i < $#arrGeneNam;$i++)
	{
		$gNam2 = $gNam2.".".$arrGeneNam[$i];
	}
	next if(exists $pairsRecorded{"$gNam1\t$gNam2"});
	if(exists $correspondGenesOfHomSp{"$gNam1"})
	{
		$correspondGenesOfHomSp{"$gNam1"} = $correspondGenesOfHomSp{"$gNam1"}.",$gNam2";
		$pairsRecorded{"$gNam1\t$gNam2"} = 1;
	}
	else
	{
		$correspondGenesOfHomSp{"$gNam1"} = "$gNam2";
		$pairsRecorded{"$gNam1\t$gNam2"} = 1;
	}
	
	
}



close(FTR);

open(FTR,"<$gffFile") or die;

while(my $input = <FTR>)
{
	chomp($input);
	my @arrInp = split(/\t/,$input);
	
	my $chrNam = $arrInp[0];
	my $source = $arrInp[1];
	my $featType = $arrInp[2];
	my $startCoor = $arrInp[3];
	my $endCoor = $arrInp[4];
	my $prop5 = $arrInp[5];
	my $strand = $arrInp[6];
	my $prop7 = $arrInp[7];
	my $propNam = $arrInp[8];
	next if($chrNamToTake ne $chrNam);
	if($featType eq "gene")
	{
		
		my $currGeneNam = substr($propNam,3,length($propNam)-4);
		
		my @arrDot = split(/\./,$currGeneNam);
		
		$currGeneNam = $arrDot[0];
		
		for(my $i = 1;$i <= $#arrDot;$i++)
		{
			$currGeneNam = $currGeneNam.".".$arrDot[$i];
		}
		
		push @gffGenesList,$currGeneNam;
		
	}
	
	
	
}


close(FTR);


for(my $i = 0;$i <= $#gffGenesList;$i++)
{
	my $currFirstGeneNam = $gffGenesList[$i];
	print FTW "$currFirstGeneNam";
	if(exists $correspondGenesOfHomSp{"$currFirstGeneNam"})
	{
		my $currSecondGeneNam = $correspondGenesOfHomSp{"$currFirstGeneNam"};
		print FTW "\t$currSecondGeneNam\n";
	}
	else
	{
		print FTW "\t-\n";
	}
}


close(FTW);
