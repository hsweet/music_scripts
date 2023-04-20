# music_scripts
Various short scripts to help manipulate and manage lilypond files and other music related scripts.

Many/most are just stubs.  transpose.pl is the main script here.  Given a lilypond file (or at least one using my template) 
it will transpose to Bb, Eb and Bass, compile to pdf format, combine all the transpositions to a single pdf, compress the pdf
and finally upload the finished file to my google drive. (Also it opens a file manager in the correct folder so you can check
for problems).

It uses a few external utilities, including rclone for uploading, qpdf for compression, and pdftk for combining pdfs. 

It will ask for how long back to process files and if this is a new or modified chart.  If you say no it will only recompile, combine,
compress and transfer.  This is because on occasion one of the transpositions needs a manual tweak.

To use it you must have perl installed and change the $basepath variable to the folder you keep your charts in.
