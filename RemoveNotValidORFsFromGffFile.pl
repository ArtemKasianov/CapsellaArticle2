use strict;





my $gffFile = $ARGV[0];
my $outFile = $ARGV[1];




open(FTW,">$outFile") or die;

open(FTR,"<$gffFile") or die;

my $isRemove = 0;
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
		$isRemove = 0;
		
		my @arrComma = split(/;/,$propNam);
		
		for(my $i = 0;$i <= $#arrComma;$i++)
		{
			my $currProp = $arrComma[$i];
			my @arrEqual = split(/=/,$currProp);
			my $currPropNam = $arrEqual[0];
			my $currPropVal = $arrEqual[1];
			print "$currPropNam\n";
			if($currPropNam eq "valid_ORFs")
			{
				if($currPropVal == 0)
				{
					$isRemove = 1;
				}
			}
			
		}
		
		
	}
	
	if($isRemove == 0)
	{
		print FTW "$input\n";
	}
	
	
}


close(FTR);



close(FTW);


