use strict;





my $gffFile = $ARGV[0];
my $outFile = $ARGV[1];




open(FTW,">$outFile") or die;

open(FTR,"<$gffFile") or die;

my $lastChrNam = "";
my $currGeneIndex = 10;
my $currTranscriptIndex = 0;
my $currExonIndex = 1;
my $currCDSIndex = 1;
my $currGeneName = "";
my $currTranscriptName = "";

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
	
	if($featType eq "gene")
	{
		$currTranscriptIndex = 0;
		
		if($chrNam ne $lastChrNam)
		{
			$currGeneIndex = 10;
			$lastChrNam = $chrNam;
			
		}
		
		
		$currGeneName = "Cbp.$chrNam.g".sprintf("%06s",$currGeneIndex);
		print FTW "$chrNam\t$source\t$featType\t$startCoor\t$endCoor\t$prop5\t$strand\t$prop7\tID=$currGeneName;\n";
		$currGeneIndex+=10;
	}
	
	if($featType eq "transcript")
	{
		$currExonIndex = 1;
		$currCDSIndex = 1;
		$currTranscriptIndex = $currTranscriptIndex + 1;
		$currTranscriptName = "$currGeneName".".t$currTranscriptIndex";
		print FTW "$chrNam\t$source\t$featType\t$startCoor\t$endCoor\t$prop5\t$strand\t$prop7\tID=$currTranscriptName;Parent=$currGeneName;\n";
		
	}
	
	if($featType eq "mRNA")
	{
		$currExonIndex = 1;
		$currCDSIndex = 1;
		$currTranscriptIndex = $currTranscriptIndex + 1;
		$currTranscriptName = "$currGeneName".".t$currTranscriptIndex";
		print FTW "$chrNam\t$source\ttranscript\t$startCoor\t$endCoor\t$prop5\t$strand\t$prop7\tID=$currTranscriptName;Parent=$currGeneName;\n";
		
	}
	if($featType eq "exon")
	{
		my $currExonName = "$currGeneName".".t$currTranscriptIndex".".exon$currExonIndex";
		print FTW "$chrNam\t$source\t$featType\t$startCoor\t$endCoor\t$prop5\t$strand\t$prop7\tID=$currExonName;Parent=$currTranscriptName;\n";
		$currExonIndex = $currExonIndex + 1;
	}
	if($featType eq "CDS")
	{
		my $currCDSName = "$currGeneName".".t$currTranscriptIndex".".CDS$currCDSIndex";
		print FTW "$chrNam\t$source\t$featType\t$startCoor\t$endCoor\t$prop5\t$strand\t$prop7\tID=$currCDSName;Parent=$currTranscriptName;\n";
		$currCDSIndex = $currCDSIndex + 1;
	}
	
	
	
}


close(FTR);



close(FTW);


