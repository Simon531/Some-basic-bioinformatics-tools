#needleman.pl by Xiuge Chen

#This is a Perl version of the Needleman-Wunsch alignment algorithm,
#using the dynamic programming recurrence relations, instead of an alignment graph

#it will ask the user for a match value V, a mismatch cost Cm, an indel cost Im, and a gaps cost gap

#it will find the maximum value of any possible alignments of the two input string with the objective function:
#maximize{ V * (#matches) - Cm * (#mismatches) - Im * (#indels) - gap * (#gaps) }

#!/pkg/bin/perl -w

#set the output file from command line
open (OUT, '> outer');   

#get the first string      
print "Input string 1 \n";
$line = <>;
chomp $line;
@string1 =  split(//, $line);  

#get the second string from terminal
print "Input string 2 \n";
$line = <>;
chomp $line;
@string2 =  split(//, $line);

#get the length of these strings from terminal
$n = @string1;                 
$m = @string2;

#initiate our computing matrix
$record[0] = 0;
for ($i = 1; $i < $n; $i++) {
	$record[$i] = 1;
}

#get the match value V from terminal
print "Input the match value V: ";
$V = <>;
chomp $V;
$V = -$V if $V < 0;

#get the mismatch cost Cm from terminal
print "Input the mismatch cost Cm: ";
$Cm = <>;
chomp $Cm;
$Cm = -$Cm if $Cm > 0;

#get the indel cost Im from terminal
print "Input the indel cost lm: ";
$lm = <>;
chomp $lm;
$lm = -$lm if $lm > 0;

#get the gaps cost gap from terminal
print "Input the gaps cost gap: ";
$gap = <>;
chomp $gap;
$gap = -$gap if $gap > 0;

print "The lengths of the two strings are $n, $m \n";   
print "the match value V is $V, mismatch cost Cm is $Cm, indel cost lm is $lm, gaps cost gap is $gap.\n";

$V[0][0] = 0;                 

#print out the first string the output file
for ($i = 1; $i <= $n; $i++) { 
   	$V[$i][0] = $gap + $lm * $i;
   	print OUT "$string1[$i-1]";  
}
print OUT "\n";

#print out the second string the output file
for ($j = 1; $j <= $m; $j++) { 
	$V[0][$j] = $gap + $lm * $j;
   	print OUT "$string2[$j-1]";
}
print OUT "\n";

$upRecord = 1; #record the situation(whether there is a gap) of upstream path

for ($i = 1; $i <= $n; $i++) { 
 	for ($j = 1; $j <= $m; $j++) {
 		
 		#determine matches or mismatches
   		if ($string1[$i-1] eq $string2[$j-1]) {
     		$t = $V; 
		}
   		else {
   	 		$t = $Cm;
   		}

		$max = $V[$i-1][$j-1] + $t;  
		$newRecord = 0; #record the situation(whether there is a gap) of the current path
		
		#the parallel path way has the max score
		if ($max <= $V[$i][$j-1] + $lm) {
			
			#determine whether the new gap is produced
  			if($upRecord != 1 && $upRecord != 2) {
    			$max = $V[$i][$j-1] + $lm + $gap;
   			}
    		else {
    			$max = $V[$i][$j-1] + $lm;
    		}
    		$newRecord = 1;
    		
    		#the parallel path way and diagonal both have the same max score
    		if (($V[$i-1][$j] + $lm) == ($V[$i][$j-1] + $lm)) {
  				$newRecord = 2;
  			}
  		}
		
		#the vertical path way has the max score
  		if ($V[$i-1][$j] + $lm >= $max) {	
  			
  			#determine whether the new gap is produced
  			if($upRecord != -1 && $upRecord != 2) { 
    			$max = $V[$i-1][$j] + $lm + $gap;
   			}
    		else {
    			$max = $V[$i-1][$j] + $lm;
    		}
    		$newRecord = -1;
    		
    		#the vertical path way and diagonal both have the same max score
    		if (($V[$i-1][$j] + $lm) == ($V[$i][$j-1] + $lm)) {
  				$newRecord = 2;
  			}
  		}
  
  		$record[$j - 1] = $upRecord;
		$upRecord = $newRecord;
  		$V[$i][$j] = $max;
   
 		print OUT "V[$i][$j] has value $V[$i][$j]\n";
  	}
}
print OUT "\n The similarity value of the two strings is $V[$n][$m]\n";

close(OUT);
