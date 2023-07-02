use strict;


my $listFile = $ARGV[0];
my $outFile = $ARGV[1];



my %allSNPs = ();


open(FTR_1,"<$listFile") or die;

while(my $fileBaseName = <FTR_1>)
{
    chomp($fileBaseName);
    
    
    
    
    my $fileName = $fileBaseName;
    
    
    my @arrInpFileBase = split(/\s+/,$fileBaseName);
    my $baseName = $arrInpFileBase[0];
    @arrInpFileBase = split(/\//,$baseName);
    $baseName = $arrInpFileBase[$#arrInpFileBase];
    open(FTR,"<$fileName") or die;
    <FTR>;
    while(my $input = <FTR>)
    {
        chomp($input);
        
        my @arrInp = split(/\t/,$input);
        
        my $seqNam = $arrInp[0];
        my @arrTmp = split(/\s+/,$seqNam);
        $seqNam = $arrTmp[0];
        
        my $pos = $arrInp[1];
        my $type = $arrInp[2];
        
        next if($type ne "SNV");
        
        my $refVar = $arrInp[4];
        my $altVar = $arrInp[5];
        my $zygosity = $arrInp[7];
        
        #die if($zygosity ne "Homozygous");
        $allSNPs{"$seqNam\t$pos\t$refVar\t$altVar"} = 1;
        
    }
    close(FTR);
}



close(FTR_1);

open(FTW,">$outFile") or die;


my @arrPos = sort {$a cmp $b} keys %allSNPs;

for(my $i = 0;$i <= $#arrPos;$i++)
{
    my $currPos = $arrPos[$i];
    print FTW "$currPos\n";
    
}




close(FTW);


