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

::call :gawk  || goto :build_err
::call :exts  || goto :build_err
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

set AWKPATH=.

call :testsimple_in addcomma || exit /b
call :testsimple_in anchgsub || exit /b
call :testsimple_in anchor   || exit /b

call :execq "copy argarray.in argarray.input > NUL" || exit /b
call :execq "echo just a test | ..\gawk.exe -f argarray.awk ./argarray.input - > _argarray" || exit /b
call :exec del /q argarray.input
call :cmpdel argarray                               || exit /b

call :testsimple_in      arrayind1                         || exit /b
call :testsimple         arrayind2                         || exit /b
call :testsimple         arrayind3                         || exit /b
call :testsimple_fail    arrayparm                         || exit /b
call :testsimple         arrayprm2                         || exit /b
call :testsimple         arrayprm3                         || exit /b
call :testsimple         arrayref                          || exit /b
call :testsimple         arrymem1                          || exit /b
call :testsimple         arryref2                          || exit /b
call :testsimple_fail    arryref3                          || exit /b
call :testsimple_fail    arryref4                          || exit /b
call :testsimple_fail    arryref5                          || exit /b
call :testsimple         arynasty                          || exit /b
call :testsimple         arynocls -v "INPUT=arynocls.in"   || exit /b
call :testsimple_fail    aryprm1                           || exit /b
call :testsimple_fail    aryprm2                           || exit /b
call :testsimple_fail    aryprm3                           || exit /b
call :testsimple_fail    aryprm4                           || exit /b
call :testsimple_fail    aryprm5                           || exit /b
call :testsimple_fail    aryprm6                           || exit /b
call :testsimple_fail    aryprm7                           || exit /b
call :testsimple         aryprm8                           || exit /b
call :testsimple         aryprm9                           || exit /b
call :testsimple         arysubnm                          || exit /b
call :testsimple         aryunasgn                         || exit /b
call :testsimple_in      asgext                            || exit /b

call :execq "set AWKPATH=lib"
call :testsimple         awkpath                           || exit /b
call :execq "set AWKPATH=."

call :testsimple_in      assignnumfield                          || exit /b
call :testsimple         assignnumfield2                         || exit /b
call :testsimple_in      back89                                  || exit /b
call :testsimple_in      backgsub                                || exit /b
call :testsimple_fail    badassign1                              || exit /b
call :testsimple_fail    badbuild                                || exit /b
call :testsimple_fail    callparam                               || exit /b
call :testsimple_in      childin                                 || exit /b
call :testsimple         clobber                                 || exit /b
call :testsimple         closebad                                || exit /b
call :testsimple_in      clsflnam                                || exit /b
call :testsimple         compare 0 1 compare.in                  || exit /b
call :testsimple         compare2                                || exit /b
call :testsimple_in      concat1                                 || exit /b
call :testsimple         concat2                                 || exit /b
call :testsimple         concat3                                 || exit /b
call :testsimple_in      concat4                                 || exit /b
call :testsimple         concat5                                 || exit /b
call :testsimple         convfmt                                 || exit /b
call :testsimple_in      datanonl                                || exit /b
call :testsimple_fail    defref --lint                           || exit /b
call :testsimple         delargv                                 || exit /b
call :testsimple         delarpm2                                || exit /b
call :testsimple         delarprm                                || exit /b
call :testsimple_fail    delfunc                                 || exit /b
call :testsimple_in      dfamb1                                  || exit /b
call :testsimple         dfastress                               || exit /b
call :testsimple         dynlj                                   || exit /b
call :testsimple         eofsplit                                || exit /b
call :testsimple_fail_   eofsrc1 -f eofsrc1a.awk -f eofsrc1b.awk || exit /b
call :testsimple         exit2                                   || exit /b
call :testsimple_ok      exitval1                                || exit /b
call :testsimple         exitval2                                || exit /b
call :testsimple_fail    exitval3                                || exit /b
call :testsimple_fail    fcall_exit                              || exit /b
call :testsimple_fail_in fcall_exit2                             || exit /b
call :testsimple_in      fldchg                                  || exit /b
call :testsimple_in      fldchgnf                                || exit /b
call :testsimple_in      fldterm                                 || exit /b
call :testsimple_fail_in fnamedat                                || exit /b
call :testsimple_fail    fnarray                                 || exit /b
call :testsimple_fail    fnarray2                                || exit /b
call :testsimple_fail    fnaryscl                                || exit /b
call :testsimple_fail    fnasgnm                                 || exit /b
call :testsimple_fail    fnmisc                                  || exit /b
call :testsimple         fordel                                  || exit /b
call :testsimple         forref                                  || exit /b
call :testsimple         forsimp                                 || exit /b
call :testsimple_in      fsbs                                    || exit /b
call :testsimple_in      fscaret                                 || exit /b
call :testsimple_in      fsnul1                                  || exit /b
call :testsimple_in      fsrs                                    || exit /b
call :testsimple         fsspcoln  """FS=[ :]+""" fsspcoln.in    || exit /b
call :testsimple_in      fstabplus                               || exit /b
call :testsimple         funsemnl                                || exit /b
call :testsimple_fail    funsmnam                                || exit /b
call :testsimple_in      funstack                                || exit /b
call :testsimple_in      getline                                 || exit /b
call :testsimple         getline2 getline2.awk getline2.awk      || exit /b
call :testsimple         getline3                                || exit /b
call :testsimple_in      getline4                                || exit /b

:: more tests to come...
rem.

exit /b

:testsimple_in
call :testsimple      %1 %2 %3 "<" %1.in
exit /b

:testsimple_fail_in
call :testsimple_fail %1 %2 %3 "<" %1.in
exit /b

:testsimple_ok_in
call :testsimple_ok   %1 %2 %3 "<" %1.in
exit /b

:testsimple
:: if called from testsimple_in
:: %4 = "<"
:: %5 = %1.in
call :testsimple_      %1 -f %1.awk %2 %3 %4 %5
exit /b

:testsimple_fail
:: if called from testsimple_fail_in
:: %4 = "<"
:: %5 = %1.in
call :testsimple_fail_ %1 -f %1.awk %2 %3 %4 %5
exit /b

:testsimple_ok
:: if called from testsimple_ok_in
:: %4 = "<"
:: %5 = %1.in
call :testsimple_ok_   %1 -f %1.awk %2 %3 %4 %5
exit /b

:testsimple_
:: if called from testsimple_in -> testsimple
:: %2 = -f
:: %3 = %1.awk
:: %4 = %2
:: %5 = %3
:: %6 = "<"
:: %7 = %1.in
call :execq "..\gawk.exe %~2 %~3 %~4 %~5 %~6 %~7 > _%1 2>&1" && call :cmpdel %1
exit /b

:testsimple_fail_
:: if called from testsimple_fail_in -> testsimple_fail
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

:testsimple_ok_
:: if called from testsimple_ok_in -> testsimple_ok
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
call :execq "fc _%1 %1.ok > NUL" || (fc _%1 %1.ok & exit /b 1)
del /q _%1
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
