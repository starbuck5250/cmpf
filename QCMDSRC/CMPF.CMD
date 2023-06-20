000100100430cmd 'Compare 2 files by field'
000200100429
000300100503parm kwd(PrdF) TYPE(prdFil) prompt('Production file') min(1)
000400100503parm kwd(TstF) TYPE(tstFil) prompt('Test file') min(1)
000500100503
000600140529parm kwd(Keys) type(keys) min(1) max(10) prompt('Key fields')
000700140529
000800100504parm kwd(AdlFld) TYPE(*name) len(10) prompt('Additional fields to display') +
000900100504                 min(0) max(10) expr(*yes) pmtctl(*pmtrqs)
001000100504
001100100504parm kwd(OmtFld) TYPE(*name) len(10) prompt('Fields to omit from comparison') +
001200100504                 min(0) max(10) expr(*yes) pmtctl(*pmtrqs)
001300100504
001400140529parm kwd(Case) TYPE(*char) len(10) prompt('Compare fields case sensitive?') +
001500140529                 min(0) max(1) expr(*yes) pmtctl(*pmtrqs) dft(*mixed) +
001600140529                 rstd(*yes) values(*mono *mixed)
001700140529
001800140529parm kwd(Output) type(*char) len(10) dft(*print) values(*print *outfile) +
001900140529                 rstd(*yes) min(0) expr(*yes) pmtctl(*pmtrqs) prompt('Output')
002000140530parm kwd(OutF) TYPE(outFil) prompt('Output file') min(0) pmtctl(*pmtrqs)
002100140529parm kwd(OutMbr) TYPE(*name) len(10) prompt('Output file member') +
002200140530                 dft(*first) spcval(*first) min(0) expr(*yes) pmtctl(*pmtrqs)
002300140529
002400100503parm kwd(RcdFmt) TYPE(*name) len(10) prompt('File Record format') +
002500100503                 min(0) expr(*yes) dft(*only) spcval(*only) pmtctl(*pmtrqs)
002600100503
002700100503parm kwd(PrdMbr) TYPE(*name) len(10) prompt('Production file member') +
002800100503                 dft(*first) spcval(*first) min(0) expr(*yes) pmtctl(*pmtrqs)
002900100503
003000100503parm kwd(TstMbr) TYPE(*name) len(10) prompt('Test file member') +
003100100503                 dft(*first) spcval(*first *prdmbr) min(0) expr(*yes) +
003200100503                 pmtctl(*pmtrqs)
003300100503
003400100503parm kwd(SrcF) TYPE(clFil) prompt('CL source file') min(0) pmtctl(*pmtrqs)
003500100503parm kwd(SrcMbr) TYPE(*name) len(10) prompt('CL source file member') +
003600100430                 dft(CMPFCL) min(0) expr(*yes) pmtctl(*pmtrqs)
003700100430
003800140530prdFil: qual type(*name) len(10) expr(*yes) min(1)
003900100430        qual type(*name) len(10) prompt('Library') +
004000100430             dft(*libl) spcval(*libl) expr(*yes)
004100100429
004200140530tstFil: qual type(*name) len(10) min(0) +
004300100430             dft(*prdfil) spcval(*prdfil) expr(*yes)
004400100430        qual type(*name) len(10) prompt('Library') +
004500100430             dft(*libl) spcval(*libl) expr(*yes)
004600100430
004700140529keys: elem TYPE(*name) len(10) prompt('Key') expr(*yes) min(1)
004800140529      elem TYPE(*char) len(10) prompt('Case sensititve') expr(*yes) +
004900140529        dft(*mixed) rstd(*yes) values(*mono *mixed) min(0)
005000140529
005100100430clFil:  qual type(*name) len(10) +
005200100430             dft(QCLSRC) expr(*yes)
005300100430        qual type(*name) len(10) prompt('Library') +
005400100430             dft(QTEMP) spcval(*libl) expr(*yes)
005500140529
005600140530outFil: qual type(*name) len(10) dft(*gen) +
005700140530             spcval(*gen *none) expr(*yes)
005800140529        qual type(*name) len(10) prompt('Library') +
005900140530             dft(qtemp) spcval(*libl) expr(*yes)
006000140529
