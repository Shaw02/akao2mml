path c:\Program files\Microsoft Visual Studio 9.0\VC\bin\;C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE

rem path c:\masm611\bin;c:\masm611\binr

ml /AT /omf /c /Foff7mml.obj /DFF7=1 /Fl /Sa akao2mml.asm >merrff7.txt
ml /AT /omf /c /Foff8mml.obj /DFF8=1 /Fl /Sa akao2mml.asm >merrff8.txt

link16 /tiny ff7mml.obj; >lerrf77.txt
link16 /tiny ff8mml.obj; >lerrff8.txt


