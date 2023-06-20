000100140529pgm (&prdfil &tstfil &keylist &adlflds &omtflds +
000200140529     &case   &output &outfil  &outmbr  &rcdfmt +
000300140529     &prdmbr &tstmbr &srcfil &srcmbr)
000400100503
000500100503dcl &prdfil  *char 20
000600100430dcl &prdfile *char 10
000700100430dcl &prdlibr *char 10
000800100503dcl &prdmbr  *char 10
000900100503dcl &tstfil  *char 20
001000100430dcl &tstfile *char 10
001100100430dcl &tstlibr *char 10
001200100503dcl &tstmbr  *char 10
001300140529dcl &keylist *char 226   /* 10 @ 22b + 6b length */
001400100504dcl &adlflds *char 102   /* 10 @ 10b + 2b length */
001500100504dcl &omtflds *char 102   /* 10 @ 10b + 2b length */
001600100503dcl &srcfil  *char 20
001700140529dcl &output  *char 10
001800140529dcl &outfil  *char 20
001900140529dcl &outmbr  *char 10
002000140529dcl &srcfile *char 10
002100100503dcl &srclibr *char 10
002200100503dcl &srcmbr  *char 10
002300100503dcl &rcdfmt  *char 10
002400140529dcl &case    *char 10
002500140529dcl &outfile *char 10
002600140529dcl &outlibr *char 10
002700140602dcl &jobType *char 1
002800140529
002900100430chgvar &prdfile %sst(&prdfil 01 10)
003000100430chgvar &prdlibr %sst(&prdfil 11 10)
003100100430chgvar &tstfile %sst(&tstfil 01 10)
003200100430chgvar &tstlibr %sst(&tstfil 11 10)
003300100503chgvar &srcfile %sst(&srcfil 01 10)
003400100503chgvar &srclibr %sst(&srcfil 11 10)
003500140529chgvar &outfile %sst(&outfil 01 10)
003600140529chgvar &outlibr %sst(&outfil 11 10)
003700140529
003800140602/* Batch or interactive? */
003900140602rtvjoba type(&jobType)
004000140602
004100100503/* create the source member */
004200100503crtsrcpf &srclibr/&srcfile mbr(&srcmbr)
004300100503monmsg cpf7302  /* already exists */
004400100503
004500100503clrpfm &srclibr/&srcfile &srcmbr
004600100503monmsg cpf3141 exec(do)  /* mbr not found */
004700100503   addpfm &srclibr/&srcfile &srcmbr
004800100503enddo
004900100503
005000100503/* generate the CL source */
005100100503call cmpfr1 (&prdfile &prdlibr &prdmbr +
005200100503             &tstfile &tstlibr &tstmbr +
005300100503             &srcfile &srclibr &srcmbr +
005400140529             &keylist &rcdfmt  &case &adlflds &omtflds +
005500140602             &output  &outfile &outlibr &outmbr &jobType)
005600100430
005700100503/* create the CL program */
005800100503crtclpgm &srcLibr/&srcMbr &srclibr/&srcfile &srcmbr
005900100503
006000100503/* execute the CL program */
006100100429call cmpfcl
006200100429
006300100429endpgm
