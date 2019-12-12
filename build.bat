@echo off

set "NODEPRECATE=/D_CRT_NONSTDC_NO_DEPRECATE /D_CRT_SECURE_NO_DEPRECATE /D_WINSOCK_DEPRECATED_NO_WARNINGS"

set "CMNOPTS=/nologo /c /W4 %NODEPRECATE% /Ox /GF /Gy /GS- /GL /EHsc /we4013"
set "GAWKLIB=lib /nologo /LTCG"
set "GAWKLINK=link /nologo /LTCG /DEFAULTLIB:LIBCPMT.lib"
set "EXTLINK=link /nologo /LTCG /DEFAULTLIB:LIBCPMT.lib /DLL /SUBSYSTEM:CONSOLE"

:: debugging options
::set "CMNOPTS=/nologo /c /W4 %NODEPRECATE% /Od /Zi /EHsc /we4013 /D_DEBUG"
::set "GAWKLIB=lib /nologo"
::set "GAWKLINK=link /nologo /DEBUG /DEFAULTLIB:LIBCPMTD.lib"
::set "EXTLINK=link /nologo /DEBUG /DEFAULTLIB:LIBCPMTD.lib /DLL /SUBSYSTEM:CONSOLE"

set "GAWKCC=cl %CMNOPTS% /DGAWK /DHAVE___INLINE /DHAVE_CONFIG_H /DLOCALEDIR=\"\" /DDEFPATH=\"\" /DDEFLIBPATH=\"\" /DSHLIBEXT=\"dll\" /Isupport /Ipc /I."
set "EXTCC=cl %CMNOPTS% /DHAVE_CONFIG_H /Iextension /Ipc /I."

set CALL_STAT=0

call :gawk  || goto :build_err
call :exts  || goto :build_err
call :tests || goto :test_err

echo CALL_STAT=%CALL_STAT%
echo OK!
exit /b

:gawk

call :exec %GAWKCC% /Fosupport\getopt.obj     support\getopt.c     || exit /b
call :exec %GAWKCC% /Fosupport\getopt1.obj    support\getopt1.c    || exit /b
call :exec %GAWKCC% /Fosupport\random.obj     support\random.c     || exit /b
call :exec %GAWKCC% /Fosupport\dfa.obj        support\dfa.c        || exit /b
call :exec %GAWKCC% /Fosupport\localeinfo.obj support\localeinfo.c || exit /b
call :exec %GAWKCC% /Fosupport\regex.obj      support\regex.c      || exit /b

call :exec %GAWKLIB% /OUT:support\libsupport.a ^
support\getopt.obj     ^
support\getopt1.obj    ^
support\random.obj     ^
support\dfa.obj        ^
support\localeinfo.obj ^
support\regex.obj         || exit /b

call :exec %GAWKCC% /Foarray.obj      array.c             || exit /b
call :exec %GAWKCC% /Foawkgram.obj    awkgram.c           || exit /b
call :exec %GAWKCC% /Fobuiltin.obj    builtin.c           || exit /b
call :exec %GAWKCC% /Fopc\popen.obj   pc\popen.c          || exit /b
call :exec %GAWKCC% /Fopc\getid.obj   pc\getid.c          || exit /b
call :exec %GAWKCC% /Focint_array.obj cint_array.c        || exit /b
call :exec %GAWKCC% /Focommand.obj    command.c           || exit /b
call :exec %GAWKCC% /Fodebug.obj      debug.c             || exit /b
call :exec %GAWKCC% /Foeval.obj       eval.c              || exit /b
call :exec %GAWKCC% /Foext.obj        ext.c               || exit /b
call :exec %GAWKCC% /Fofield.obj      field.c             || exit /b
call :exec %GAWKCC% /Fofloatcomp.obj  floatcomp.c         || exit /b
call :exec %GAWKCC% /Fogawkapi.obj    gawkapi.c           || exit /b
call :exec %GAWKCC% /Fogawkmisc.obj   gawkmisc.c          || exit /b
call :exec %GAWKCC% /Foint_array.obj  int_array.c         || exit /b
call :exec %GAWKCC% /Foio.obj         io.c                || exit /b
call :exec %GAWKCC% /Fomain.obj       main.c              || exit /b
call :exec %GAWKCC% /Fompfr.obj       mpfr.c              || exit /b
call :exec %GAWKCC% /Fomsg.obj        msg.c               || exit /b
call :exec %GAWKCC% /Fonode.obj       node.c              || exit /b
call :exec %GAWKCC% /Foprofile.obj    profile.c           || exit /b
call :exec %GAWKCC% /Fore.obj         re.c                || exit /b
call :exec %GAWKCC% /Foreplace.obj    replace.c           || exit /b
call :exec %GAWKCC% /Fostr_array.obj  str_array.c         || exit /b
call :exec %GAWKCC% /Fosymbol.obj     symbol.c            || exit /b
call :exec %GAWKCC% /Foversion.obj    version.c           || exit /b

call :exec %GAWKLINK% /DEFAULTLIB:WS2_32.lib /OUT:gawk.exe ^
array.obj             ^
awkgram.obj           ^
builtin.obj           ^
pc\popen.obj          ^
pc\getid.obj          ^
cint_array.obj        ^
command.obj           ^
debug.obj             ^
eval.obj              ^
ext.obj               ^
field.obj             ^
floatcomp.obj         ^
gawkapi.obj           ^
gawkmisc.obj          ^
int_array.obj         ^
io.obj                ^
main.obj              ^
mpfr.obj              ^
msg.obj               ^
node.obj              ^
profile.obj           ^
re.obj                ^
replace.obj           ^
str_array.obj         ^
symbol.obj            ^
version.obj           ^
support\libsupport.a       || exit /b

exit /b

:exts

call :ext testext        || exit /b
call :ext readdir        || exit /b
call :ext readdir_test   || exit /b
call :ext time           || exit /b
call :ext stack          || exit /b
call :ext rwarray        || exit /b
call :ext revoutput      || exit /b
call :ext revtwoway      || exit /b
call :ext readfile       || exit /b
call :ext ordchr         || exit /b
call :ext intdiv         || exit /b
call :ext inplace        || exit /b
::call :ext gawkfts      || exit /b
::call :ext filefuncs    || exit /b
::call :ext fork         || exit /b
::call :ext fnmatch      || exit /b

exit /b

:ext
call :exec %EXTCC% /Foextension\%1.obj extension\%1.c  || exit /b
call :exec %EXTLINK% /OUT:%1.dll extension\testext.obj || exit /b
exit /b

:tests

setlocal
set CALL_STAT=0
call :exec cd test
call :tests_in
set err=%ERRORLEVEL%
call :exec cd ..
set CALL_STAT1=%CALL_STAT%
endlocal & set /A "CALL_STAT+=%CALL_STAT1%" & exit /b %err%

:tests_in

call :execq "set AWKPATH=."

:: 262 basic tests

call :runtest_in addcomma || exit /b
call :runtest_in anchgsub || exit /b
call :runtest_in anchor   || exit /b

call :execq "copy argarray.in argarray.input > NUL" || exit /b
call :execq "echo just a test | ..\gawk.exe -f argarray.awk ./argarray.input - > _argarray" || exit /b
call :exec del /q argarray.input
call :cmpdel argarray                               || exit /b

call :runtest_in      arrayind1                         || exit /b
call :runtest         arrayind2                         || exit /b
call :runtest         arrayind3                         || exit /b
call :runtest_fail    arrayparm                         || exit /b
call :runtest         arrayprm2                         || exit /b
call :runtest         arrayprm3                         || exit /b
call :runtest         arrayref                          || exit /b
call :runtest         arrymem1                          || exit /b
call :runtest         arryref2                          || exit /b
call :runtest_fail    arryref3                          || exit /b
call :runtest_fail    arryref4                          || exit /b
call :runtest_fail    arryref5                          || exit /b
call :runtest         arynasty                          || exit /b
call :runtest         arynocls -v "INPUT=arynocls.in"   || exit /b
call :runtest_fail    aryprm1                           || exit /b
call :runtest_fail    aryprm2                           || exit /b
call :runtest_fail    aryprm3                           || exit /b
call :runtest_fail    aryprm4                           || exit /b
call :runtest_fail    aryprm5                           || exit /b
call :runtest_fail    aryprm6                           || exit /b
call :runtest_fail    aryprm7                           || exit /b
call :runtest         aryprm8                           || exit /b
call :runtest         aryprm9                           || exit /b
call :runtest         arysubnm                          || exit /b
call :runtest         aryunasgn                         || exit /b
call :runtest_in      asgext                            || exit /b

call :execq "set AWKPATH=lib"
call :runtest         awkpath                           || exit /b
call :execq "set AWKPATH=."

call :runtest_in      assignnumfield                          || exit /b
call :runtest         assignnumfield2                         || exit /b
call :runtest_in      back89                                  || exit /b
call :runtest_in      backgsub                                || exit /b
call :runtest_fail    badassign1                              || exit /b
call :runtest_fail    badbuild                                || exit /b
call :runtest_fail    callparam                               || exit /b
call :runtest_in      childin                                 || exit /b
call :runtest         clobber                                 || exit /b
call :cmpdel_         clobber.ok seq                          || exit /b
call :runtest         closebad                                || exit /b
call :runtest_in      clsflnam                                || exit /b
call :runtest         compare 0 1 compare.in                  || exit /b
call :runtest         compare2                                || exit /b
call :runtest_in      concat1                                 || exit /b
call :runtest         concat2                                 || exit /b
call :runtest         concat3                                 || exit /b
call :runtest_in      concat4                                 || exit /b
call :runtest         concat5                                 || exit /b
call :runtest         convfmt                                 || exit /b
call :runtest_in      datanonl                                || exit /b
call :runtest_fail    defref --lint                           || exit /b
call :runtest         delargv                                 || exit /b
call :runtest         delarpm2                                || exit /b
call :runtest         delarprm                                || exit /b
call :runtest_fail    delfunc                                 || exit /b
call :runtest_in      dfamb1                                  || exit /b
call :runtest         dfastress                               || exit /b
call :runtest         dynlj                                   || exit /b
call :runtest         eofsplit                                || exit /b
call :runtest_fail_   eofsrc1 -f eofsrc1a.awk -f eofsrc1b.awk || exit /b
call :runtest         exit2                                   || exit /b
call :runtest_ok      exitval1                                || exit /b
call :runtest         exitval2                                || exit /b
call :runtest_fail    exitval3                                || exit /b
call :runtest_fail    fcall_exit                              || exit /b
call :runtest_fail_in fcall_exit2                             || exit /b
call :runtest_in      fldchg                                  || exit /b
call :runtest_in      fldchgnf                                || exit /b
call :runtest_in      fldterm                                 || exit /b
call :runtest_fail_in fnamedat                                || exit /b
call :runtest_fail    fnarray                                 || exit /b
call :runtest_fail    fnarray2                                || exit /b
call :runtest_fail    fnaryscl                                || exit /b
call :runtest_fail    fnasgnm                                 || exit /b
call :runtest_fail    fnmisc                                  || exit /b
call :runtest         fordel                                  || exit /b
call :runtest         forref                                  || exit /b
call :runtest         forsimp                                 || exit /b
call :runtest_in      fsbs                                    || exit /b
call :runtest_in      fscaret                                 || exit /b
call :runtest_in      fsnul1                                  || exit /b
call :runtest_in      fsrs                                    || exit /b
call :runtest         fsspcoln  """FS=[ :]+""" fsspcoln.in    || exit /b
call :runtest_in      fstabplus                               || exit /b
call :runtest         funsemnl                                || exit /b
call :runtest_fail    funsmnam                                || exit /b
call :runtest_in      funstack                                || exit /b
call :runtest_in      getline                                 || exit /b
call :runtest         getline2 getline2.awk getline2.awk      || exit /b
call :runtest         getline3                                || exit /b
call :runtest_in      getline4                                || exit /b
call :runtest         getline5                                || exit /b
call :runtest_in      getlnbuf                                || exit /b
call :runtest_        getlnbuf -f gtlnbufv.awk getlnbuf.in    || exit /b
call :runtest_in      getnr2tb                                || exit /b
call :runtest_in      getnr2tm                                || exit /b
call :runtest_fail    gsubasgn                                || exit /b
call :runtest         gsubtest                                || exit /b
call :runtest         gsubtst2                                || exit /b
call :runtest_in      gsubtst3 --re-interval                  || exit /b
call :runtest         gsubtst4                                || exit /b
call :runtest_in      gsubtst5                                || exit /b
call :runtest         gsubtst6                                || exit /b
call :runtest_in      gsubtst7                                || exit /b
call :runtest_in      gsubtst8                                || exit /b
call :runtest         hex                                     || exit /b
call :runtest_in      hex2                                    || exit /b
call :runtest         hsprint                                 || exit /b
call :runtest_in      inpref                                  || exit /b
call :runtest         inputred                                || exit /b
call :runtest         intest                                  || exit /b
call :runtest         intprec                                 || exit /b
call :runtest         iobug1                                  || exit /b
call :runtest         leaddig                                 || exit /b
call :runtest_in      leadnl                                  || exit /b
call :runtest_in      litoct  --traditional                   || exit /b
call :runtest_in      longsub                                 || exit /b
call :runtest_in      longwrds -v "SORT=sort"                 || exit /b
call :runtest_in      manglprm                                || exit /b
call :runtest         math                                    || exit /b
call :runtest_in      membug1                                 || exit /b
call :runtest         memleak                                 || exit /b

call :execq "..\gawk.exe -f messages.awk >_out2 2>_out3" && ^
call :cmpdel_ out1.ok _out1 && ^
call :cmpdel_ out2.ok _out2 && ^
call :cmpdel_ out3.ok _out3 || exit /b

call :runtest         minusstr                                || exit /b
call :runtest_in      mmap8k                                  || exit /b
call :runtest         nasty                                   || exit /b
call :runtest         nasty2                                  || exit /b
call :runtest         negexp                                  || exit /b
call :runtest         negrange                                || exit /b
call :runtest_in      nested                                  || exit /b
call :runtest_in      nfldstr                                 || exit /b
call :runtest         nfloop                                  || exit /b
call :runtest_fail    nfneg                                   || exit /b
call :runtest_in      nfset                                   || exit /b
call :runtest_in      nlfldsep                                || exit /b
call :runtest_in      nlinstr                                 || exit /b
call :runtest         nlstrina                                || exit /b
call :runtest         noeffect --lint                         || exit /b
call :runtest_fail_   nofile """{}""" no/such/file            || exit /b
call :runtest         nofmtch --lint                          || exit /b
call :runtest_in      noloop1                                 || exit /b
call :runtest_in      noloop2                                 || exit /b
call :runtest_in      nonl --lint                             || exit /b
call :runtest_fail    noparms                                 || exit /b

call :execq "<NUL set /p=A B C D E | ..\gawk.exe ""{ print $NF }"" - nors.in > _nors" && ^
call :cmpdel_ nors.ok _nors || exit /b

call :runtest_fail    nulinsrc                                || exit /b
call :runtest_in      nulrsend                                || exit /b
call :runtest_in      numindex                                || exit /b
call :runtest         numrange                                || exit /b
call :runtest         numstr1                                 || exit /b
call :runtest_in      numsubstr                               || exit /b
call :runtest         octsub                                  || exit /b
call :runtest_in      ofmt                                    || exit /b
call :runtest         ofmta                                   || exit /b
call :runtest_in      ofmtbig                                 || exit /b
call :runtest_in      ofmtfidl                                || exit /b
call :runtest_in      ofmts                                   || exit /b
call :runtest         ofmtstrnum                              || exit /b
call :runtest_in      ofs1                                    || exit /b
call :runtest_in      onlynl                                  || exit /b
call :runtest         opasnidx                                || exit /b
call :runtest         opasnslf                                || exit /b
call :runtest_fail    paramasfunc1 --posix                    || exit /b
call :runtest_fail    paramasfunc2 --posix                    || exit /b
call :runtest_fail    paramdup                                || exit /b
call :runtest_fail    paramres                                || exit /b
call :runtest         paramtyp                                || exit /b
call :runtest         paramuninitglobal                       || exit /b
call :runtest_in      parse1                                  || exit /b
call :runtest_in      parsefld                                || exit /b
call :runtest_fail    parseme                                 || exit /b
call :runtest         pcntplus                                || exit /b
call :runtest         posix2008sub --posix                    || exit /b
call :runtest_in      prdupval                                || exit /b
call :runtest         prec                                    || exit /b
call :runtest         printf0 --posix                         || exit /b
call :runtest         printf1                                 || exit /b
call :runtest         printfchar                              || exit /b
call :runtest_fail    prmarscl                                || exit /b
call :runtest         prmreuse                                || exit /b
call :runtest         prt1eval                                || exit /b
call :runtest         prtoeval                                || exit /b
call :runtest         rand                                    || exit /b
call :runtest randtest "-vRANDOM=" "-vNSAMPLES=1024" "-vMAX_ALLOWED_SIGMA=5" "-vNRUNS=50" || exit /b
:: 184

:: more tests to come...

exit /b

:runtest_in
call :runtest      %1 %2 %3 "<" %1.in
exit /b

:runtest_fail_in
call :runtest_fail %1 %2 %3 "<" %1.in
exit /b

:runtest_ok_in
call :runtest_ok   %1 %2 %3 "<" %1.in
exit /b

:runtest
:: if called from runtest_in
:: %4 = "<"
:: %5 = %1.in
call :runtest_      %1 -f %1.awk %2 %3 %4 %5
exit /b

:runtest_fail
:: if called from runtest_fail_in
:: %4 = "<"
:: %5 = %1.in
call :runtest_fail_ %1 -f %1.awk %2 %3 %4 %5
exit /b

:runtest_ok
:: if called from runtest_ok_in
:: %4 = "<"
:: %5 = %1.in
call :runtest_ok_   %1 -f %1.awk %2 %3 %4 %5
exit /b

:runtest_
:: if called from runtest_in -> runtest
:: %2 = -f
:: %3 = %1.awk
:: %4 = %2
:: %5 = %3
:: %6 = "<"
:: %7 = %1.in
call :execq "..\gawk.exe %~2 %~3 %~4 %~5 %~6 %~7 > _%1 2>&1" && call :cmpdel %1
exit /b

:runtest_fail_
:: if called from runtest_fail_in -> runtest_fail
:: %2 = -f
:: %3 = %1.awk
:: %4 = %2
:: %5 = %3
:: %6 = "<"
:: %7 = %1.in
:: awk should fail
call :execq "..\gawk.exe %~2 %~3 %~4 %~5 %~6 %~7 > _%1 2>&1" && exit /b 1
:: reset ERRORLEVEL
set err=%ERRORLEVEL%
cmd /c "exit /b 0"
call :execq "(echo.EXIT CODE: %err%) >> _%1" && call :cmpdel %1
exit /b

:runtest_ok_
:: if called from runtest_ok_in -> runtest_ok
:: %2 = -f
:: %3 = %1.awk
:: %4 = %2
:: %5 = %3
:: %6 = "<"
:: %7 = %1.in
:: awk should NOT fail
call :execq "..\gawk.exe %~2 %~3 %~4 %~5 %~6 %~7 > _%1 2>&1" || exit /b
call :execq "(echo.EXIT CODE: %ERRORLEVEL%) >> _%1" && call :cmpdel %1
exit /b

:cmpdel
call :cmpdel_ %1.ok _%1
exit /b

:cmpdel_
call :execq "fc %1 %2 > NUL" || (fc %1 %2 & exit /b 1)
del /q %2
exit /b

:exec
:: simple command, without quotes, redirections, etc.
echo %*
set /A "CALL_STAT+=1"
%*
exit /b

:execq
:: complex command in double-quotes
:: note: replace "" with " in arguments
set "COMMAND=%~1"
set "COMMAND=%COMMAND:>=^>%"
set "COMMAND=%COMMAND:<=^<%"
set "COMMAND=%COMMAND:&=^&%"
set "COMMAND=%COMMAND:|=^|%"
set "COMMAND=%COMMAND:(=^(%"
set "COMMAND=%COMMAND:)=^)%"
echo %COMMAND:""="%
set /A "CALL_STAT+=1"
set "COMMAND=%~1"
%COMMAND:""="%
exit /b

:build_err
echo CALL_STAT=%CALL_STAT%
echo *** Compilation failed! ***
exit /b 1

:test_err
echo CALL_STAT=%CALL_STAT%
echo *** Test failed! ***
exit /b 1
