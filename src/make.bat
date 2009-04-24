path c:\Program files\Microsoft Visual Studio 9.0\VC\bin\;C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE

rem path c:\masm611\bin;c:\masm611\binr

ml /AT /omf /c /Fors1mml.obj /DSPC=1 /DRS1=1 /Flrs1mml.lst /Sa akao2mml.asm >merrrs1.txt
ml /AT /omf /c /Fors2mml.obj /DSPC=1 /DRS2=1 /Flrs2mml.lst /Sa akao2mml.asm >merrrs2.txt
ml /AT /omf /c /Fors3mml.obj /DSPC=1 /DRS3=1 /Flrs3mml.lst /Sa akao2mml.asm >merrrs3.txt
ml /AT /omf /c /Foff4mml.obj /DSPC=1 /DFF4=1 /Flff4mml.lst /Sa akao2mml.asm >merrff4.txt
ml /AT /omf /c /Foff5mml.obj /DSPC=1 /DFF5=1 /Flff5mml.lst /Sa akao2mml.asm >merrff5.txt
ml /AT /omf /c /Foff6mml.obj /DSPC=1 /DFF6=1 /Flff6mml.lst /Sa akao2mml.asm >merrff6.txt
ml /AT /omf /c /Foff7mml.obj /DPS1=1 /DFF7=1 /Flff7mml.lst /Sa akao2mml.asm >merrff7.txt
ml /AT /omf /c /Foff8mml.obj /DPS1=1 /DFF8=1 /Flff8mml.lst /Sa akao2mml.asm >merrff8.txt

link16 /tiny rs1mml.obj; >lerrrs1.txt
link16 /tiny rs2mml.obj; >lerrrs2.txt
link16 /tiny rs3mml.obj; >lerrrs3.txt
link16 /tiny ff4mml.obj; >lerrff4.txt
link16 /tiny ff5mml.obj; >lerrff5.txt
link16 /tiny ff6mml.obj; >lerrff6.txt
link16 /tiny ff7mml.obj; >lerrff7.txt
link16 /tiny ff8mml.obj; >lerrff8.txt

del *.obj
