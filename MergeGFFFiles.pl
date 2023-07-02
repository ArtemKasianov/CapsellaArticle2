use strict;





my $gffFile1 = $ARGV[0];
my $gffFile2 = $ARGV[1];
my $outFile = $ARGV[2];

my %regionsGFFToInsert = ();
my %writedGFFInput = ();



open(FTW,">$outFile") or die;

open(FTR,"<$gffFile1") or die;


while(my $input = <FTR>)
{
	chomp($input);
	my @arrInp = split(/\t/,$input);
	
	my $chrNam = $arrInp[0];
	my $startCoor = $arrInp[3];
	my $endCoor = $arrInp[4];
	my $strand = $arrInp[6];
	
	if(exists $regionsGFFToInsert{"$chrNam"})
	{
		my $ptrHashCoors = $regionsGFFToInsert{"$chrNam"};
		$ptrHashCoors->{"$startCoor\t$endCoor\t$strand"} = $input;
	}
	else
	{
		my %hashCoors = ();
		$hashCoors{"$startCoor\t$endCoor\t$strand"} = $input;
		$regionsGFFToInsert{"$chrNam"} = \%hashCoors;
	}
	
}


close(FTR);



open(FTR,"<$gffFile2") or die;


while(my $input = <FTR>)
{
	chomp($input);
	my @arrInp = split(/\t/,$input);
	
	my $chrNam = $arrInp[0];
	my $startCoor = $arrInp[3];
	my $endCoor = $arrInp[4];
	my $strand = $arrInp[6];
	
	if(exists $regionsGFFToInsert{"$chrNam"})
	{
		my $ptrHashCoors = $regionsGFFToInsert{"$chrNam"};
		my @arrHashCoors = keys %$ptrHashCoors;
		for(my $i = 0;$i <= $#arrHashCoors;$i++)
		{
			my $currCoorStr = $arrHashCoors[$i];
			my $currInput = $ptrHashCoors->{"$currCoorStr"};
			my @arrCoorStr = split(/\t/,$currCoorStr);
			
			my $currStartCoor = $arrCoorStr[0];
			my $currEndCoor = $arrCoorStr[1];
			my $currStrand = $arrCoorStr[2];
			
			
			
			
			if(($startCoor <= $currStartCoor) && ($currStartCoor <= $endCoor) && ($strand eq $currStrand))
			{
				if(($startCoor <= $currEndCoor) && ($currEndCoor <= $endCoor))
				{
					print FTW "$input\n";
					$writedGFFInput{"$currInput"} = 1;
					$writedGFFInput{"$input"} = 1;
					last;
				}
				else
				{
					my $diffLength = abs($endCoor - $currStartCoor);
					
					my $seqLength = abs($endCoor - $startCoor);
					my $currSeqLength = abs($currEndCoor - $currStartCoor);
					my $maxSeqLength = $seqLength;
					if($currSeqLength > $seqLength)
					{
						$maxSeqLength = $seqLength;
					}
					
					my $ratio = $diffLength/$maxSeqLength;
					if($ratio <= 0.1)
					{
						print FTW "$input\n";
						print FTW "$currInput\n";
						$writedGFFInput{"$currInput"} = 1;
						$writedGFFInput{"$input"} = 1;
						last;
					}
					else
					{
						print FTW "$input\n";
						$writedGFFInput{"$currInput"} = 1;
						$writedGFFInput{"$input"} = 1;
						last;
					}
				}
			}
			else
			{
				if(($currStartCoor <= $startCoor) && ($startCoor <= $currEndCoor) && ($strand eq $currStrand))
				{
					if(($currStartCoor <= $endCoor) && ($endCoor <= $currEndCoor))
					{
						print FTW "$currInput\n";
						$writedGFFInput{"$currInput"} = 1;
						$writedGFFInput{"$input"} = 1;
						last;
					}
					else
					{
						my $diffLength = abs($currEndCoor - $startCoor);
						
						my $seqLength = abs($endCoor - $startCoor);
						my $currSeqLength = abs($currEndCoor - $currStartCoor);
						my $maxSeqLength = $seqLength;
						if($currSeqLength > $seqLength)
						{
							$maxSeqLength = $seqLength;
						}
						
						my $ratio = $diffLength/$maxSeqLength;
						if($ratio <= 0.1)
						{
							print FTW "$input\n";
							print FTW "$currInput\n";
							$writedGFFInput{"$currInput"} = 1;
							$writedGFFInput{"$input"} = 1;
							last;
						}
						else
						{
							print FTW "$currInput\n";
							$writedGFFInput{"$currInput"} = 1;
							$writedGFFInput{"$input"} = 1;
							last;
						}
					}
					
				}
				else
				{
					if(($startCoor <= $currEndCoor) && ($currEndCoor <= $endCoor) && ($strand eq $currStrand))
					{
						my $diffLength = abs($currEndCoor - $startCoor);
						
						my $seqLength = abs($endCoor - $startCoor);
						my $currSeqLength = abs($currEndCoor - $currStartCoor);
						my $maxSeqLength = $seqLength;
						if($currSeqLength > $seqLength)
						{
							$maxSeqLength = $seqLength;
						}
						
						my $ratio = $diffLength/$maxSeqLength;
						if($ratio <= 0.1)
						{
							print FTW "$input\n";
							print FTW "$currInput\n";
							$writedGFFInput{"$currInput"} = 1;
							$writedGFFInput{"$input"} = 1;
							last;
						}
						else
						{
							print FTW "$currInput\n";
							$writedGFFInput{"$currInput"} = 1;
							$writedGFFInput{"$input"} = 1;
							last;
						}
					}
					else
					{
						if(($currStartCoor <= $endCoor) && ($endCoor <= $currEndCoor) && ($strand eq $currStrand))
						{
							my $diffLength = abs($endCoor - $currStartCoor);
							
							my $seqLength = abs($endCoor - $startCoor);
							my $currSeqLength = abs($currEndCoor - $currStartCoor);
							my $maxSeqLength = $seqLength;
							if($currSeqLength > $seqLength)
							{
								$maxSeqLength = $seqLength;
							}
							
							my $ratio = $diffLength/$maxSeqLength;
							if($ratio <= 0.1)
							{
								print FTW "$input\n";
								print FTW "$currInput\n";
								$writedGFFInput{"$currInput"} = 1;
								$writedGFFInput{"$input"} = 1;
								last;
							}
							else
							{
								print FTW "$currInput\n";
								$writedGFFInput{"$currInput"} = 1;
								$writedGFFInput{"$input"} = 1;
								last;
							}
						}
						else
						{
							print FTW "$input\n";
							$writedGFFInput{"$input"} = 1;
							last;
						}
					}
				}
			}
		}
	}
	else
	{
		print FTW "$input\n";
		$writedGFFInput{"$input"} = 1;
	}
	
	
	
}


close(FTR);


open(FTR,"<$gffFile1") or die;


while(my $input = <FTR>)
{
	chomp($input);
	if(not exists $writedGFFInput{"$input"})
	{
		print FTW "$input\n";
	}
	
}


close(FTR);


close(FTW);


