rem path c:\Program files\Microsoft Visual Studio 8\VC\bin\;C:\Program Files\Microsoft Visual Studio 8\Common7\IDE

path c:\masm611\bin;c:\masm611\binr

masm /Ml /Mx /DFF7=1 akao2mml.asm,ff7mml.obj; >merrff7.txt
masm /Ml /Mx /DFF8=1 akao2mml.asm,ff8mml.obj; >merrff8.txt

link /tiny ff7mml.obj; >lerrf77.txt
link /tiny ff8mml.obj; >lerrff8.txt


