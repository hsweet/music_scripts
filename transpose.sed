# command line example: sed s/##t/##t\\n'  #(set-paper-size "letter")'/  Dobriden1.ly
#find  . -name  '*ly' -exec  sed -i s/##t/##t\\n'  #(set-paper-size "letter")'/  {} \;

# s/##t/##t'\\n  #(set-paper-size "letter")'/

#these lines for mass transpoition
#s/\\relative c/\\transpose c d \\relative c/   
#s/\\chordmode/\\transpose c d \\chordmode/  
#s/Violin/Clarinet/i
#s/Szélrózsa//
# sed 's/instrument =\""/instrument = \"Violin\"/' 

#####################Basic Usage#############################
#sed -f sedscript <old >new

#Invoke as follows to edit in place (CAREFUL, OVERWRITES ORIGINAL)
#sed  -i ""-f  transpose.sed 'A Gitte Nacht.ly'

#Do the whole folder at once.....
#find  . -name  '*ly' -exec sed  -i ""-f  transpose.sed {} \;
#find . *.ly  without -name works

###############################################################
#s/relative [a-s]*/relative c/    takes care of fis and all that  
#fis is the euro way of saying fs f sharp
