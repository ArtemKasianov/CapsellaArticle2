use strict;

my $variantsListFile = $ARGV[0];
my $depthListFile = $ARGV[1];
my $dbFile = $ARGV[2];
my $chrNam = $ARGV[3];
my $startCoor = $ARGV[4];
my $endCoor = $ARGV[5];
my $outFile = $ARGV[6];


my %depthBySample = ();
my %variantsBySample = ();
my %refLettersByPos = ();
my %heteroByPos = ();
my @arrPos = ();
my @arrSortedPos = ();
my %seqBySample = ();



open(FTW,">$outFile") or die;


open(FTR,"<$dbFile") or die;

while(my $input = <FTR>)
{
    chomp($input);
    my @arrInp = split(/\t/,$input);
    my $scaffNam = $arrInp[0];
    my $pos = $arrInp[1];
    my $refVar = $arrInp[2];
    next if($chrNam ne $scaffNam);
    next if($pos < $startCoor);
    next if($pos > $endCoor);
    
    $refLettersByPos{$pos} = $refVar;
    push @arrPos,$pos;
    
    
}


close(FTR);

@arrSortedPos = sort {$a <=> $b} @arrPos;

open(FTR,"<$depthListFile") or die;


while(my $input = <FTR>)
{
    chomp($input);
    
    my @arrInp = split(/\./,$input);
    
    my $filePath = $arrInp[0];
    my @arrTmp = split(/\//,$filePath);
    my $sampleName = $arrTmp[$#arrTmp];
    #print "$sampleName\n";
    my %hashDepth = ();
    my %hashVariants = ();
    $depthBySample{"$sampleName"} = \%hashDepth;
    $variantsBySample{"$sampleName"} = \%hashVariants;
    open(FTR_1,"<$input") or die;
    $seqBySample{"$sampleName"} = "";
    while(my $input_1 = <FTR_1>)
    {
        chomp($input_1);
        my @arrInp = split(/\t/,$input_1);
        my $scaffNam = $arrInp[0];
        my $pos = $arrInp[1];
        next if($chrNam ne $scaffNam);
        next if($pos < $startCoor);
        next if($pos > $endCoor);
        $heteroByPos{"$pos"} = 0;
        
        my $depth = $arrInp[2];
        $depthBySample{"$sampleName"}->{$pos} = $depth;
        my $currRefVar = $refLettersByPos{$pos};
        if($pos == 10000012)
        {
            print "10000012 here $sampleName\n";
        }
        if($depth>=8)
        {
            $variantsBySample{"$sampleName"}->{$pos} = "$currRefVar";
        }
        else
        {
            
            $variantsBySample{"$sampleName"}->{$pos} = "N";    
        }
        
        
    }
    
    close(FTR_1);
    
    
    
}



close(FTR);

print "next_stage\n";
open(FTR,"<$variantsListFile") or die;


while(my $input = <FTR>)
{
    chomp($input);
    my @arrInp = split(/\s/,$input);
    
    my $filePath = $arrInp[0];
    my @arrTmp = split(/\//,$filePath);
    my $sampleName = $arrTmp[$#arrTmp];
    
    open(FTR_1,"<$input") or die;
    <FTR_1>;
    while(my $input_1 = <FTR_1>)
    {
        chomp($input_1);
        my @arrInp = split(/\s+/,$input_1);
        my $scaffNam = $arrInp[0];
        my $pos = $arrInp[2];
        my $varType = $arrInp[3];
        my $refVar = $arrInp[5];
        my $altVar = $arrInp[6];
        my $zygosity = $arrInp[7];
        next if($varType ne "SNV");
        next if($chrNam ne $scaffNam);
        next if($pos < $startCoor);
        next if($pos > $endCoor);
        
        if($zygosity eq "Heterozygous")
        {
            $heteroByPos{"$pos"} = 1;
            if(($refVar eq "A" && $altVar eq "T") || ($refVar eq "T" && $altVar eq "A"))
            {
                $variantsBySample{"$sampleName"}->{$pos} = "W";      
            }
            if(($refVar eq "A" && $altVar eq "C") || ($refVar eq "C" && $altVar eq "A"))
            {
                $variantsBySample{"$sampleName"}->{$pos} = "M";        
            }
            if(($refVar eq "A" && $altVar eq "G") || ($refVar eq "G" && $altVar eq "A"))
            {
                $variantsBySample{"$sampleName"}->{$pos} = "R";        
            }
            
            if(($refVar eq "T" && $altVar eq "C") || ($refVar eq "C" && $altVar eq "T"))
            {
                $variantsBySample{"$sampleName"}->{$pos} = "Y";        
            }
            if(($refVar eq "T" && $altVar eq "G") || ($refVar eq "G" && $altVar eq "T"))
            {
                $variantsBySample{"$sampleName"}->{$pos} = "K";        
            }
            
            if(($refVar eq "C" && $altVar eq "G") || ($refVar eq "G" && $altVar eq "C"))
            {
                $variantsBySample{"$sampleName"}->{$pos} = "S";        
            }
        }
        else
        {
            $variantsBySample{"$sampleName"}->{$pos} = "$altVar";
        }
        
        
        
    }
    
    close(FTR_1);

}

my @arrSamples = keys %variantsBySample;
for(my $i = 0;$i <= $#arrSamples;$i++)
{
    my $currSample = $arrSamples[$i];
    for(my $j = 0;$j <= $#arrSortedPos;$j++)
    {
        my $currPos = $arrSortedPos[$j];
        my $currLetter = $variantsBySample{"$currSample"}->{$currPos};
        if(($currLetter eq "A") || ($currLetter eq "T") || ($currLetter eq "C") || ($currLetter eq "G"))
        {
            $heteroByPos{"$currPos"} = 0;
        }
    }
}


for(my $i = 0;$i <= $#arrSamples;$i++)
{
    my $currSample = $arrSamples[$i];
    my $sampleType = substr($currSample,0,2);
    if($sampleType eq "Cg")
    {
        
        for(my $j = 0;$j <= $#arrSortedPos;$j++)
        {
            my $currPos = $arrSortedPos[$j];
            my $currLetter = $variantsBySample{"$currSample"}->{$currPos};
            $seqBySample{"$currSample"} = $seqBySample{"$currSample"}.$currLetter;
        }
    }
    else
    {
        for(my $j = 0;$j <= $#arrSortedPos;$j++)
        {
            my $currPos = $arrSortedPos[$j];
            my $currLetter = $variantsBySample{"$currSample"}->{$currPos};
            if(($currLetter ne "A") && ($currLetter ne "T") && ($currLetter ne "C") && ($currLetter ne "G"))
            {
                if($heteroByPos{"$currPos"} == 1)
                {
                    $seqBySample{"$currSample"} = $seqBySample{"$currSample"}."N";
                }
                else
                {
                    $seqBySample{"$currSample"} = $seqBySample{"$currSample"}.$currLetter;        
                }
            }
            else
            {
                $seqBySample{"$currSample"} = $seqBySample{"$currSample"}.$currLetter;    
            }
            
        }
    }

}


for(my $i = 0;$i <= $#arrSamples;$i++)
{
    my $currSample = $arrSamples[$i];
    my $seqTxt = $seqBySample{"$currSample"};
    my $currLen = length($seqTxt);
    #print "$currSample\t$currLen\n";
    print FTW ">$currSample\n";
    print FTW "$seqTxt\n";
}

close(FTW);

