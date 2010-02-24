
path c:\masm611\bin;c:\masm611\binr

ml /AT /Fers1mml /DSPC=1 /DRS1=1 /Sa /Flrs1mml.lst akao2mml.asm
ml /AT /Fers2mml /DSPC=1 /DRS2=1 /Sa /Flrs2mml.lst akao2mml.asm
ml /AT /Fers3mml /DSPC=1 /DRS3=1 /Sa /Flrs3mml.lst akao2mml.asm
ml /AT /Fesd2mml /DSPC=1 /DSD2=1 /Sa /Flsd2mml.lst akao2mml.asm
ml /AT /Feff4mml /DSPC=1 /DFF4=1 /Sa /Flff4mml.lst akao2mml.asm
ml /AT /Feff5mml /DSPC=1 /DFF5=1 /Sa /Flff5mml.lst akao2mml.asm
ml /AT /Feff6mml /DSPC=1 /DFF6=1 /Sa /Flff6mml.lst akao2mml.asm
ml /AT /Feff7mml /DPS1=1 /DFF7=1 /Sa /Flff7mml.lst akao2mml.asm
ml /AT /Feff8mml /DPS1=1 /DFF8=1 /Sa /Flff8mml.lst akao2mml.asm

ml /AT /Fecd1mml /DPS1=1 /DFF7=1 /DCD1=1 /Sa /Flcd1mml.lst akao2mml.asm

ml /AT /Sa /Fllzs2bin.lst lzs2bin.asm

del *.obj
