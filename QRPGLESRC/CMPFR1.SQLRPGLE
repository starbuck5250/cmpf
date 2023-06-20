000100100428      * Compare 2 files
000200100428      * Creates an SQL script that compares two files
000300100430      * field by field, only printing the fields with differences.
000400100428      *
000500100504      * CHGCMD CMD(BUCK/CMPF) PGM(BUCK/CMPF) PRDLIB(BUCK) ENBGUI(*YES)
000600100504      *
000700121203     h dftactgrp(*no) actgrp('QILE') option(*srcstmt: *nodebugio)
000800121203     h debug
000900121203     h bnddir('BUCK')
001000100428      * dbgview(*list)
001100100428
001200100428     fqclsrc    o    e             disk    usropn extfile(clFil)
001300100428     f                                            extmbr(clMbr)
001400100428     f                                            rename(QCLSRC: RCL)
001500100429
001600100429      // utility prototypes
001700100429      /copy qprotosrc,buck
001800100429
001900100430      // *entry plist
002000100430     dcmpfr1           pr                  extpgm('CMPFR1')
002100100430     d inPrdFil                      10
002200100430     d inPrdLib                      10
002300100430     d inPrdMbr                      10
002400100503     d inTstFil                      10
002500100430     d inTstLib                      10
002600100430     d inTstMbr                      10
002700100503     d inSrcFil                      10
002800100503     d inSrcLib                      10
002900100503     d inSrcMbr                      10
003000100503     d inKeyStruc                          like(keyStruc)
003100100503     d inRcdFmt                      10
003200140529     d inCase                        10
003300100504     d inAdlFldsStruc                      like(AdlFldsStruc)
003400100504     d inOmtFldsStruc                      like(OmtFldsStruc)
003500140529     d inOutput                      10
003600140529     d inOutFil                      10
003700140529     d inOutLib                      10
003800140529     d inOutMbr                      10
003900140602     d inJobType                      1
004000140529
004100100430     dcmpfr1           pi
004200100430     d inPrdFil                      10
004300100430     d inPrdLib                      10
004400100430     d inPrdMbr                      10
004500100503     d inTstFil                      10
004600100430     d inTstLib                      10
004700100430     d inTstMbr                      10
004800100503     d inSrcFil                      10
004900100503     d inSrcLib                      10
005000100503     d inSrcMbr                      10
005100100503     d inKeyStruc                          like(keyStruc)
005200100503     d inRcdFmt                      10
005300140529     d inCase                        10
005400140529     d inAdlFldsStruc                      like(AdlFldsStruc)
005500100504     d inOmtFldsStruc                      like(OmtFldsStruc)
005600140529     d inOutput                      10
005700140529     d inOutFil                      10
005800140529     d inOutLib                      10
005900140529     d inOutMbr                      10
006000140602     d inJobType                      1
006100140602
006200100429      // display file field list
006300100429     dSQLforEach...
006400100429     d                 pr
006500100429     d inDBFields                          likeds(DBFields)
006600100429
006700100429     d SQLforEachPtr   s               *   procptr
006800100429
006900100503      // record format list processor
007000100503     drcdFmtProc...
007100100503     d                 pr
007200100503     d rcdFmt                        10
007300100503
007400100503     d rcdFmtPtr       s               *   procptr
007500100503
007600100430     d prdFil          s             10    varying
007700100430     d prdLib          s             10    varying
007800100430     d prdMbr          s             10    varying
007900100503     d tstFil          s             10    varying
008000100430     d tstLib          s             10    varying
008100100430     d tstMbr          s             10    varying
008200100503     d clFil           s             21    varying
008300100503     d clMbr           s             10    varying
008400100503     d rcdFmt          s             10    varying
008500140529     d outFil          s             10    varying
008600140529     d outLib          s             10    varying
008700140529     d outMbr          s             10    varying
008800140529     d SQLOutput       s             75    varying
008900140529
009000100504      // key field list
009100140529      // this describes one individual key element
009200140530     dkeyList          ds                  qualified based(keyListPtr)
009300140530     d count                          5i 0
009400140530     d keys                          10
009500140530     d keysCases                     10
009600140529
009700140529      // the CMD puts a count in the first 2 bytes, then
009800140530      // a varying length array of integer offsets
009900140530      // this array is in 'reverse' order; the last element is
010000140530      // first in the list.  If there are 2 keys specified,
010100140530      // we'll get 2 integers.  If 10 keys are specified, we'll get 10.
010200140529     dkeyStruc         ds                  qualified
010300100430     d count                          5i 0
010400140530     d offsetArray                    5i 0 dim(10)                              // varying length
010500140530     d keyList                      512a                                        // placeholder;vary
010600140529
010700100504      // additional field list
010800100504     dadlFldsStruc     ds                  qualified
010900100504     d count                          5i 0
011000100504     d adlFlds                       10    dim(10)
011100100504
011200100504      // omit field list
011300100504     domtFldsStruc     ds                  qualified
011400100504     d count                          5i 0
011500100504     d omtFlds                       10    dim(10)
011600140529
011700140529     d i               s             10i 0
011800140529     d key             s             10    varying dim(10) inz
011900140529     d keyCase         s             10    varying dim(10) inz
012000100504     d adlFlds         s             10    varying dim(10) inz
012100100504     d omtFlds         s             10    varying dim(10) inz
012200100430
012300100503     d seqIncr         s              6s 2 inz(10.00)
012400100429     d p               s              4    inz('prd.')
012500100429     d t               s              4    inz('tst.')
012600100504     d sel             s           1024    inz varying
012700100429     d sel_keys        s            512    inz varying
012800100429     d join_on         s            512    inz varying
012900100429     d ord             s            128    inz varying
013000100429     d cmd             s           8192    inz varying
013100100430     d SQL_NORMAL      s              5    inz('00000')
013200100428
013300100428      // write source lines
013400100428     dwrtSrc           pr
013500100428     d inCmd                       8192    const varying
013600100428
013700140529      // generate the SQL OUTPUT() keywords
013800140529     dgenSQLoutput     pr            75    varying
013900140530     d inOutput                      10    const varying
014000140530     d inOutFil                      10    const varying
014100140530     d inOutLib                      10    const varying
014200140529     d inOutMbr                      10    const varying
014300140529
014400100428     c/free
014500100428
014600100430       exec sql
014700100430         set option
014800100430           naming    = *sys,
014900100430           closqlcsr = *endactgrp,
015000100430           commit    = *none;
015100100430
015200100430       // load work fields from input
015300100430       prdFil = %trim(inPrdFil);
015400100430       prdLib = %trim(inPrdLib);
015500100430       prdMbr = %trim(inPrdMbr);
015600100503       tstFil = %trim(inTstFil);
015700100430       tstLib = %trim(inTstLib);
015800100503       tstMbr = %trim(inTstMbr);
015900100503       clFil  = %trim(inSrcLib) +'/' + %trim(inSrcFil);
016000100503       clMbr  = %trim(inSrcMbr);
016100100503       rcdFmt = %trim(inRcdFmt);
016200140529       outFil = %trim(inOutFil);
016300140529       outLib = %trim(inOutLib);
016400140529       outMbr = %trim(inOutMbr);
016500140529
016600140529       if rcdfmt = '*ONLY';
016700100503         exsr getRcdFmt;
016800100503         if %subst(rcdfmt: 1: 1) = '*';
016900100503           dsply 'Record format error';
017000100503           dump;
017100100503           return;
017200100503         endif;
017300100503       endif;
017400140529
017500140530       // build an array of keys.
017600140530       // traverse the input list of keys
017700140530       // because it is a mixed list, the structure can vary based
017800140530       // on the number of keys specified.
017900100503       keyStruc = inKeyStruc;
018000140530
018100140530       // iterate the input structure backwards
018200140530       // only trust the offset array for COUNT number of elements
018300140530       for i = keyStruc.count downto 1;
018400140530         keyListPtr = %addr(keyStruc) + keyStruc.offsetArray(i);
018500140530         key(i) = %trim(keyList.keys);
018600140530         keyCase(i) = %trim(keyList.keysCases);
018700140530       endfor;
018800140529
018900140530       // build an array of 'additional fields' to select
019000140530       adlFldsStruc = inAdlFldsStruc;
019100100504       for i = 1 to adlFldsStruc.count;
019200100504         adlFlds(i) = %trim(adlFldsStruc.adlFlds(i));
019300100504       endfor;
019400140529
019500140530       // build an array of fields to omit from the comparison
019600100504       omtFldsStruc = inomtFldsStruc;
019700100504       for i = 1 to omtFldsStruc.count;
019800100504         omtFlds(i) = %trim(omtFldsStruc.omtFlds(i));
019900100504       endfor;
020000100504
020100100430       // normalise the parameters
020200100430       if tstFil = '*PRDFIL';
020300100430         tstFil = prdFil;
020400100430       endif;
020500140529
020600100430       if tstMbr = '*PRDMBR';
020700100430         tstMbr = prdMbr;
020800100430       endif;
020900100503
021000100428       open qclsrc;
021100100428       srcdat = 0;
021200100428       srcseq = 0.00;
021300100428
021400100428       wrtSrc('pgm');
021500140530       exsr blankLine;
021600140530       wrtsrc('monmsg cpf2105 /* not found */');
021700140530
021800100428       // overrides
021900100428       exsr blankLine;
022000100429       cmd = 'ovrdbf prd ' + prdLib + '/' +
022100100429                  prdFil + ' mbr(' + prdMbr + ')';
022200100428       wrtSrc(cmd);
022300100428
022400100429       cmd = 'ovrdbf tst ' + tstLib + '/' +
022500100429                  tstFil + ' mbr(' + tstMbr + ')';
022600100428       wrtSrc(cmd);
022700100428
022800100428       // in prod, not test
022900100428       exsr blankLine;
023000140530
023100100504       // build the list of fields which are keys -
023200100504       // these fields are the JOIN ON fields as well
023300100429       sel_keys = '''select ';
023400100429       ord = ' order by ';
023500140529       for i = 1 to %elem(key);
023600140529         if key(i) <> '';
023700100429           if i > 1;
023800100429             sel_keys += ', ';
023900100429             join_on += ' and ';
024000100429             ord += ',';
024100100429           endif;
024200140529           sel_keys+= p + key(i);
024300140529
024400140529           // the JOIN keys might need to be made case-insensitive
024500140529           select;
024600140529             when keyCase(i) = '*MIXED';
024700140529               join_on += p + key(i) + '=' + t + key(i);
024800140529             when keyCase(i) = '*MONO';
024900140529               join_on += 'lower(' +
025000140529                          p + key(i) + ')=' +
025100140529                          'lower(' +
025200140529                          t + key(i) + ')';
025300140529           endsl;
025400140529
025500100429           ord += %trim(%editc(i:'Z'));
025600100429         endif;
025700100429       endfor;
025800100504
025900100504       // the user can specify additional fields to select,
026000100504       // in addition to the key fields
026100100504       sel = sel_keys;
026200100504       if adlFldsStruc.count <> 0;
026300100504         for i = 1 to adlFldsStruc.count;
026400100504           sel += ', ' + p + adlFlds(i);
026500100504         endfor;
026600100504       endif;
026700100429
026800140529       // rows in production, but not in test
026900140530       cmd = 'dltf ' + outlib + '/' + 'LEFT';
027000140530       wrtSrc(cmd);
027100140530       exsr blankLine;
027200140530
027300130401       cmd = 'buck/rs ' + sel +
027400100429             ' from prd exception join tst on ' +
027500100429              join_on +
027600140529              ord + ''' ' + genSQLoutput(inOutput:
027700140530                                         'LEFT':
027800140529                                         outlib:
027900140529                                         outmbr);
028000100428       wrtSrc(cmd);
028100100428
028200100428       // in test, not prod
028300100429       exsr blankLine;
028400100429       sel_keys= '''select ';
028500100429
028600140529       for i = 1 to %elem(key);
028700140529         if key(i) <> '';
028800100429           if i > 1;
028900100429             sel_keys+= ', ';
029000100429           endif;
029100140529           sel_keys+= t + key(i);
029200100429         endif;
029300100429       endfor;
029400100504
029500100504       // the user can specify additional fields to select,
029600100504       // in addition to the key fields
029700100504       sel = sel_keys;
029800100504       if adlFldsStruc.count <> 0;
029900100504         for i = 1 to adlFldsStruc.count;
030000100504           sel += ', ' + t + adlFlds(i);
030100100504         endfor;
030200100504       endif;
030300100504
030400140529       // rows in test but not in production
030500140530       cmd = 'dltf ' + outlib + '/' + 'RIGHT';
030600140530       wrtSrc(cmd);
030700140530       exsr blankLine;
030800140530
030900140530       cmd = 'buck/rs ' + sel +
031000100429             ' from tst exception join prd on ' +
031100100429              join_on +
031200140529              ord + ''' ' + genSQLoutput(inOutput:
031300140530                                         'RIGHT':
031400140529                                         outlib:
031500140529                                         outmbr);
031600140530       wrtSrc(cmd);
031700100429
031800140529       // rows in each, but different
031900140530       SQLforEachPtr = %paddr(SQLforEach);
032000100429       callp lstDBFields(tstFil:
032100100429                         tstLib:
032200100503                         rcdFmt:
032300100429                         SQLforEachPtr);
032400100429
032500140530       // if we created outfiles, look at them
032600140602       // but only if we're in an interactive job
032700140602       if inJobType = '1';
032800140602         exsr blankLine;
032900140602         cmd = 'wrkobjpdm ' + inOutLib + ' *all *file';
033000140602         wrtsrc(cmd);
033100140602       endif;
033200140530
033300140530       // finish up
033400140530       exsr blankLine;
033500100428       wrtSrc('endpgm');
033600100428
033700100428       close qclsrc;
033800100428       *inlr = *on;
033900100428
034000100428       // blank line
034100100428       begsr blankLine;
034200100428         wrtSrc('');
034300100428       endsr;
034400100428
034500100503       // get record format name
034600100503       begsr getRcdFmt;
034700100503         rcdFmtPtr = %paddr(rcdFmtProc);
034800100503         callp lstDBRecs(tstFil:
034900100503                         tstLib:
035000100503                         rcdFmtPtr);
035100100503       endsr;
035200100503
035300100428      /end-free
035400100428
035500100428      // write source lines
035600100428     pwrtSrc...
035700100428     p                 b
035800100428
035900100428     dwrtSrc...
036000100428     d                 pi
036100100428     d inCmd                       8192    const varying
036200100428
036300100428     d cmdWrk          s           8192    varying
036400100428     d cmdShort        s             75    varying
036500100428     d i               s             10i 0 inz
036600100428     d j               s             10i 0 inz
036700100428     d srcLen          s             10i 0 inz
036800100429     d totLen          s             10i 0 inz
036900100429     d remaining       s             10i 0 inz
037000100428
037100100428     c/free
037200100428         cmdWrk = inCmd;
037300100428         srcLen = %size(srcDta)-5;
037400100428
037500100428         // command short enough to fit on one line
037600100428         if %len(cmdWrk) <= srcLen;
037700100428           srcseq += seqIncr;
037800100428           srcdta = cmdWrk;
037900100428           write rcl;
038000100428           return;
038100100428         endif;
038200100428
038300100428         // incoming command longer than the source length
038400100428         // break it up as needed
038500100429         i = 1;
038600100429         totLen = 0;
038700100429         dow i <= %len(cmdWrk)-srcLen;
038800100429           cmdShort = %subst(cmdWrk: i: srcLen);
038900100428           srcseq += seqIncr;
039000100429           srcdta = cmdShort + '-';
039100100428           write rcl;
039200100429           i += srclen;
039300100429           totLen += srclen;
039400100429         enddo;
039500100429
039600100429         // need to write the last segment
039700100429         remaining = %len(cmdWrk)-totLen;
039800100429         cmdShort = %subst(cmdWrk: i: remaining);
039900100429         srcseq += seqIncr;
040000100429         srcdta = cmdShort;
040100100429         write rcl;
040200100429
040300100429         return;
040400100429      /end-free
040500100428
040600100428     pwrtSrc...
040700100428     p                 e
040800100429
040900100429      // display file field list
041000100429     pSQLforEach...
041100100429     p                 b
041200100429     dSQLforEach...
041300100429     d                 pi
041400100429     d inDBFields                          likeds(DBFields)
041500100429
041600100429     d where           s            128    inz varying
041700100430     d sql_test        s           8192    inz varying
041800100430     d count           s             10i 0 inz
041900100430     d create_alias    s            128    inz varying
042000100429
042100100429     c/free
042200140529       // don't bother comparing the keys; they match by definition
042300140529       if %lookup(%trimr(inDBFields.nm):key)>0;
042400100429         return;
042500100429       endif;
042600100504
042700100504       // user can specify fields to omit from testing
042800100504       // these would be things like date stamps and the like.
042900100504       if omtFldsStruc.count <> 0;
043000100504         if %lookup(%trimr(inDBFields.nm):omtFlds)>0;
043100100504           return;
043200100504         endif;
043300100504       endif;
043400100504
043500100504       sel = sel_keys;
043600100504
043700100504       // the user can specify additional fields to select,
043800100504       // in addition to the key fields
043900100504       if adlFldsStruc.count <> 0;
044000100504         for i = 1 to adlFldsStruc.count;
044100140529           sel += ', ' + p + adlFlds(i) + ' as prd_' + adlFlds(i);
044200140529           sel += ', ' + t + adlFlds(i) + ' as tst_' + adlFlds(i);
044300100504         endfor;
044400100504       endif;
044500100504
044600100504       // and finally, append the field we're looking at right now
044700140529       sel += ', ' + p + %trimr(inDBFields.nm) +
044800140529                     ' as prd_' + %trimr(inDBFields.nm) +
044900140529              ', ' + t + %trimr(inDBFields.nm) +
045000140529                     ' as tst_' + %trimr(inDBFields.nm);
045100100429
045200140529       where = ' where ';
045300140529       // the comparison fields might need to be made case insensitive
045400140529       select;
045500140529         when inCase = '*MIXED';
045600140529           where += p + %trimr(inDBFields.nm) + '<>' +
045700140529                    t + %trimr(inDBFields.nm);
045800140529         when inCase = '*MONO';
045900140529           where += 'lower(' +
046000140529                    p + %trimr(inDBFields.nm) + ')<>' +
046100140529                    'lower(' +
046200140529                    t + %trimr(inDBFields.nm) + ')';
046300140529       endsl;
046400140529
046500100430       // only write a record if there's a difference
046600100430       // because we can be comparing two members of the same file
046700100430       // and SQL doesn't understand members, we need some ALIASes
046800100430
046900100430       // drop existing aliases
047000100430       create_alias = 'drop alias qtemp/tst';
047100100430       exec sql
047200100430         execute immediate :create_alias;
047300100430       create_alias = 'drop alias qtemp/prd';
047400100430       exec sql
047500100430         execute immediate :create_alias;
047600100430
047700100430       // create new aliases
047800100430       create_alias = 'create alias qtemp/tst for ';
047900100430       if tstlib <> '*LIBL';
048000100430         create_alias += tstlib + '/';
048100100430       endif;
048200100917       create_alias += tstfil;
048300100917       if tstMbr <> '*FIRST';
048400100917         create_alias += '(' + tstMbr + ')';
048500100917       endif;
048600100917       exec sql
048700100430         execute immediate :create_alias;
048800100430       create_alias = 'create alias qtemp/prd for ';
048900100430       if prdlib <> '*LIBL';
049000100430         create_alias += prdlib + '/';
049100100430       endif;
049200100917       create_alias += prdfil;
049300100917       if prdMbr <> '*FIRST';
049400100917         create_alias += '(' + prdMbr + ')';
049500100917       endif;
049600100917       exec sql
049700100430         execute immediate :create_alias;
049800100430
049900100430       // using the aliases, see if there are differences
050000100430       sql_test = 'select count(*) from tst join prd on ' +
050100100430              join_on + where;
050200100430
050300100430       exec sql
050400100430         prepare row_count from :sql_test;
050500100430       if sqlstate <> SQL_NORMAL;
050600100430         dump 'prepare';
050700100430       endif;
050800100430
050900100430       exec sql
051000100430         declare row_count_cursor cursor for row_count;
051100100430
051200100430       exec sql
051300100430         open row_count_cursor;
051400100430       if sqlstate <> SQL_NORMAL;
051500100430         dump 'open';
051600100430       endif;
051700100430
051800100430       exec sql
051900100430         fetch from row_count_cursor into :count;
052000100430       if sqlstate <> SQL_NORMAL;
052100100430         count = -1;
052200100430         dump 'fetch';
052300100430       endif;
052400100430
052500100430       exec sql
052600100430         close row_count_cursor;
052700100430
052800100430       if count <> 0;
052900140530         cmd = 'dltf ' + outlib + '/' + %trimr(inDBFields.nm);
053000140530         wrtSrc(cmd);
053100140530
053200140530         wrtsrc(' ');
053300140530         cmd = 'buck/rs ' + sel +
053400100430               ' from tst join prd on ' +
053500100430                join_on +
053600100430                where +
053700140529                ord + ''' ' + genSQLoutput(inOutput:
053800140530                                           %trimr(inDBFields.nm):
053900140530                                           outlib:
054000140530                                           outmbr);
054100100430         wrtSrc(cmd);
054200100430       endif;
054300100430
054400100429       return;
054500100429      /end-free
054600100429
054700100429     pSQLforEach...
054800100429     p                 e
054900100503
055000100503
055100100503      // get back the record format name
055200100503     prcdFmtProc...
055300100503     p                 b
055400100503     drcdFmtProc...
055500100503     d                 pi
055600100503     d inrcdFmt                      10
055700100503
055800100503     c/free
055900100503       select;
056000100503         when rcdFmt = '*ONLY';
056100100503           rcdFmt = inrcdFmt;
056200100503         when rcdFmt <> '*ONLY' and
056300100503              rcdFmt <> inrcdFmt;
056400100503           rcdFmt = '*MULTI';
056500100503         other;
056600100503           rcdFmt = '*ERROR';
056700100503       endsl;
056800100503      /end-free
056900100503
057000100503     prcdFmtProc...
057100100503     p                 e
057200100503
057300140529
057400140529
057500140529     pgenSQLoutput...
057600140529     p                 b
057700140529
057800140529      // generate the SQL OUTPUT() keywords
057900140529     dgenSQLoutput     pi            75    varying
058000140530     d inOutput                      10    const varying
058100140530     d inOutFil                      10    const varying
058200140530     d inOutLib                      10    const varying
058300140529     d inOutMbr                      10    const varying
058400140529
058500140529     d rtnvar          s             75    varying inz
058600140530
058700140530       // default
058800140529       rtnvar = 'output(*print)';
058900140530
059000140530       // generate outfile keywords
059100140530       if inOutput = '*OUTFILE';
059200140530         rtnvar = 'output(*outfile) outfile(' +
059300140530                  inOutLib + '/' + inOutFil +
059400140530                  ') outmbr(' + inOutMbr + ')';
059500140530       endif;
059600140530
059700140529       return rtnvar;
059800140529
059900140529     pgenSQLoutput...
060000140529     p                 e
060100140529
