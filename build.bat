@SET "NODEPRECATE=/D_CRT_NONSTDC_NO_DEPRECATE /D_CRT_SECURE_NO_DEPRECATE /D_WINSOCK_DEPRECATED_NO_WARNINGS"

@SET "CMNOPTS=/nologo /c /W4 %NODEPRECATE% /Ox /GF /Gy /GS- /GL /EHsc /we4013"
@SET "GAWKLIB=lib /nologo /LTCG"
@SET "GAWKLINK=link /nologo /LTCG /DEFAULTLIB:LIBCPMT.lib"
@SET "EXTLINK=link /nologo /LTCG /DEFAULTLIB:LIBCPMT.lib /DLL /SUBSYSTEM:CONSOLE"

:: debugging options
::@SET "CMNOPTS=/nologo /c /W4 %NODEPRECATE% /Od /Zi /EHsc /we4013 /D_DEBUG"
::@SET "GAWKLIB=lib /nologo"
::@SET "GAWKLINK=link /nologo /DEBUG /DEFAULTLIB:LIBCPMTD.lib"
::@SET "EXTLINK=link /nologo /DEBUG /DEFAULTLIB:LIBCPMTD.lib /DLL /SUBSYSTEM:CONSOLE"

@SET "GAWKCC=cl %CMNOPTS% /DGAWK /DHAVE___INLINE /DHAVE_CONFIG_H /DLOCALEDIR=\"\" /DDEFPATH=\"\" /DDEFLIBPATH=\"\" /DSHLIBEXT=\"dll\" /Isupport /Ipc /I."
@SET "EXTCC=cl %CMNOPTS% /DHAVE_CONFIG_H /Iextension /Ipc /I."

@call :gawk  || goto :build_err
@call :exts  || goto :build_err
@call :tests || goto :test_err

@echo OK!
@exit /b

:gawk

%GAWKCC% /Fosupport\getopt.obj     support\getopt.c     || exit /b 1
%GAWKCC% /Fosupport\getopt1.obj    support\getopt1.c    || exit /b 1
%GAWKCC% /Fosupport\random.obj     support\random.c     || exit /b 1
%GAWKCC% /Fosupport\dfa.obj        support\dfa.c        || exit /b 1
%GAWKCC% /Fosupport\localeinfo.obj support\localeinfo.c || exit /b 1
%GAWKCC% /Fosupport\regex.obj      support\regex.c      || exit /b 1

%GAWKLIB% /OUT:support\libsupport.a ^
support\getopt.obj     ^
support\getopt1.obj    ^
support\random.obj     ^
support\dfa.obj        ^
support\localeinfo.obj ^
support\regex.obj         || exit /b 1

%GAWKCC% /Foarray.obj      array.c             || exit /b 1
%GAWKCC% /Foawkgram.obj    awkgram.c           || exit /b 1
%GAWKCC% /Fobuiltin.obj    builtin.c           || exit /b 1
%GAWKCC% /Fopc\popen.obj   pc\popen.c          || exit /b 1
%GAWKCC% /Fopc\getid.obj   pc\getid.c          || exit /b 1
%GAWKCC% /Focint_array.obj cint_array.c        || exit /b 1
%GAWKCC% /Focommand.obj    command.c           || exit /b 1
%GAWKCC% /Fodebug.obj      debug.c             || exit /b 1
%GAWKCC% /Foeval.obj       eval.c              || exit /b 1
%GAWKCC% /Foext.obj        ext.c               || exit /b 1
%GAWKCC% /Fofield.obj      field.c             || exit /b 1
%GAWKCC% /Fofloatcomp.obj  floatcomp.c         || exit /b 1
%GAWKCC% /Fogawkapi.obj    gawkapi.c           || exit /b 1
%GAWKCC% /Fogawkmisc.obj   gawkmisc.c          || exit /b 1
%GAWKCC% /Foint_array.obj  int_array.c         || exit /b 1
%GAWKCC% /Foio.obj         io.c                || exit /b 1
%GAWKCC% /Fomain.obj       main.c              || exit /b 1
%GAWKCC% /Fompfr.obj       mpfr.c              || exit /b 1
%GAWKCC% /Fomsg.obj        msg.c               || exit /b 1
%GAWKCC% /Fonode.obj       node.c              || exit /b 1
%GAWKCC% /Foprofile.obj    profile.c           || exit /b 1
%GAWKCC% /Fore.obj         re.c                || exit /b 1
%GAWKCC% /Foreplace.obj    replace.c           || exit /b 1
%GAWKCC% /Fostr_array.obj  str_array.c         || exit /b 1
%GAWKCC% /Fosymbol.obj     symbol.c            || exit /b 1
%GAWKCC% /Foversion.obj    version.c           || exit /b 1

%GAWKLINK% /DEFAULTLIB:WS2_32.lib /OUT:gawk.exe ^
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
support\libsupport.a       || exit /b 1

@exit /b

:exts

@call :ext testext        || exit /b 1
@call :ext readdir        || exit /b 1
@call :ext readdir_test   || exit /b 1
@call :ext time           || exit /b 1
@call :ext stack          || exit /b 1
@call :ext rwarray        || exit /b 1
@call :ext revoutput      || exit /b 1
@call :ext revtwoway      || exit /b 1
@call :ext readfile       || exit /b 1
@call :ext ordchr         || exit /b 1
@call :ext intdiv         || exit /b 1
@call :ext inplace        || exit /b 1
::@call :ext gawkfts      || exit /b 1
::@call :ext filefuncs    || exit /b 1
::@call :ext fork         || exit /b 1
::@call :ext fnmatch      || exit /b 1

@exit /b

:ext
%EXTCC% /Foextension\%1.obj extension\%1.c  || exit /b 1
%EXTLINK% /OUT:%1.dll extension\testext.obj || exit /b 2
@exit /b

:tests

setlocal
cd test
@call :tests_in
@set err=%ERRORLEVEL%
cd ..
@endlocal & exit /b %err%

:tests_in

SET AWKPATH=.
SET TEST_ARGS=

@call :testsimple_in addcomma     || exit /b 1
@call :testsimple_in anchgsub     || exit /b 1
@call :testsimple_in anchor       || exit /b 1

copy argarray.in argarray.input > NUL                                         || exit /b 1
echo just a test | ..\gawk.exe -f argarray.awk ./argarray.input - > _argarray || exit /b 1
del /q argarray.input
@call :cmpdel argarray                                                        || exit /b 1

@call :testsimple_in      arrayind1                         || exit /b 1
@call :testsimple         arrayind2                         || exit /b 1
@call :testsimple         arrayind3                         || exit /b 1
@call :testsimple_fail    arrayparm                         || exit /b 1
@call :testsimple         arrayprm2                         || exit /b 1
@call :testsimple         arrayprm3                         || exit /b 1
@call :testsimple         arrayref                          || exit /b 1
@call :testsimple         arrymem1                          || exit /b 1
@call :testsimple         arryref2                          || exit /b 1
@call :testsimple_fail    arryref3                          || exit /b 1
@call :testsimple_fail    arryref4                          || exit /b 1
@call :testsimple_fail    arryref5                          || exit /b 1
@call :testsimple         arynasty                          || exit /b 1
@call :testsimple         arynocls -v "INPUT=arynocls.in"   || exit /b 1
@call :testsimple_fail    aryprm1                           || exit /b 1
@call :testsimple_fail    aryprm2                           || exit /b 1
@call :testsimple_fail    aryprm3                           || exit /b 1
@call :testsimple_fail    aryprm4                           || exit /b 1
@call :testsimple_fail    aryprm5                           || exit /b 1
@call :testsimple_fail    aryprm6                           || exit /b 1
@call :testsimple_fail    aryprm7                           || exit /b 1
@call :testsimple         aryprm8                           || exit /b 1
@call :testsimple         aryprm9                           || exit /b 1
@call :testsimple         arysubnm                          || exit /b 1
@call :testsimple         aryunasgn                         || exit /b 1
@call :testsimple_in      asgext                            || exit /b 1

SET AWKPATH=lib
@call :testsimple         awkpath                           || exit /b 1
SET AWKPATH=.

@call :testsimple_in      assignnumfield                          || exit /b 1
@call :testsimple         assignnumfield2                         || exit /b 1
@call :testsimple_in      back89                                  || exit /b 1
@call :testsimple_in      backgsub                                || exit /b 1
@call :testsimple_fail    badassign1                              || exit /b 1
@call :testsimple_fail    badbuild                                || exit /b 1
@call :testsimple_fail    callparam                               || exit /b 1
@call :testsimple_in      childin                                 || exit /b 1
@call :testsimple         clobber                                 || exit /b 1
@call :testsimple         closebad                                || exit /b 1
@call :testsimple_in      clsflnam                                || exit /b 1
@call :testsimple         compare 0 1 compare.in                  || exit /b 1
@call :testsimple         compare2                                || exit /b 1
@call :testsimple_in      concat1                                 || exit /b 1
@call :testsimple         concat2                                 || exit /b 1
@call :testsimple         concat3                                 || exit /b 1
@call :testsimple_in      concat4                                 || exit /b 1
@call :testsimple         concat5                                 || exit /b 1
@call :testsimple         convfmt                                 || exit /b 1
@call :testsimple_in      datanonl                                || exit /b 1
@call :testsimple_fail    defref --lint                           || exit /b 1
@call :testsimple         delargv                                 || exit /b 1
@call :testsimple         delarpm2                                || exit /b 1
@call :testsimple         delarprm                                || exit /b 1
@call :testsimple_fail    delfunc                                 || exit /b 1
@call :testsimple_in      dfamb1                                  || exit /b 1
@call :testsimple         dfastress                               || exit /b 1
@call :testsimple         dynlj                                   || exit /b 1
@call :testsimple         eofsplit                                || exit /b 1
@call :testsimple_fail_   eofsrc1 -f eofsrc1a.awk -f eofsrc1b.awk || exit /b 1
@call :testsimple         exit2                                   || exit /b 1
@call :testsimple_ok      exitval1                                || exit /b 1
@call :testsimple         exitval2                                || exit /b 1
@call :testsimple_fail    exitval3                                || exit /b 1
@call :testsimple_fail    fcall_exit                              || exit /b 1
@call :testsimple_fail_in fcall_exit2                             || exit /b 1
@call :testsimple_in      fldchg                                  || exit /b 1
@call :testsimple_in      fldchgnf                                || exit /b 1
@call :testsimple_in      fldterm                                 || exit /b 1
@call :testsimple_fail_in fnamedat                                || exit /b 1
@call :testsimple_fail    fnarray                                 || exit /b 1
@call :testsimple_fail    fnarray2                                || exit /b 1
@call :testsimple_fail    fnaryscl                                || exit /b 1
@call :testsimple_fail    fnasgnm                                 || exit /b 1
@call :testsimple_fail    fnmisc                                  || exit /b 1
@call :testsimple         fordel                                  || exit /b 1
@call :testsimple         forref                                  || exit /b 1
@call :testsimple         forsimp                                 || exit /b 1
@call :testsimple_in      fsbs                                    || exit /b 1
@call :testsimple_in      fscaret                                 || exit /b 1
@call :testsimple_in      fsnul1                                  || exit /b 1
@call :testsimple_in      fsrs                                    || exit /b 1
@set "TEST_ARGS='FS=[ :]+' fsspcoln.in"
@set "TEST_ARGS=%TEST_ARGS:'="%"
@call :testsimple         fsspcoln                                || exit /b 1
@call :testsimple_in      fstabplus                               || exit /b 1
@call :testsimple         funsemnl                                || exit /b 1
@call :testsimple_fail    funsmnam                                || exit /b 1
@call :testsimple_in      funstack                                || exit /b 1
@call :testsimple_in      getline                                 || exit /b 1
@call :testsimple         getline2 getline2.awk getline2.awk      || exit /b 1

:: more tests to come...
@rem.

@exit /b

:testsimple_in
@call :testsimple      %1 %2 %3 "<" %1.in || exit /b 1
@exit /b

:testsimple_fail_in
@call :testsimple_fail %1 %2 %3 "<" %1.in || exit /b 1
@exit /b

:testsimple_ok_in
@call :testsimple_ok   %1 %2 %3 "<" %1.in || exit /b 1
@exit /b

:testsimple
@call :testsimple_      %1 -f %1.awk %2 %3 %4 %5 || exit /b 1
@exit /b

:testsimple_fail
@call :testsimple_fail_ %1 -f %1.awk %2 %3 %4 %5 || exit /b 1
@exit /b

:testsimple_ok
@call :testsimple_ok_   %1 -f %1.awk %2 %3 %4 %5 || exit /b 1
@exit /b

:testsimple_
..\gawk.exe %~2 %~3 %~4 %~5 %~6 %~7 %TEST_ARGS% > _%1 2>&1 && call :cmpdel %1 || exit /b 1
@set TEST_ARGS=
@exit /b

:testsimple_fail_
:: awk should fail
..\gawk.exe %Q% %~2 %~3 %~4 %~5 %~6 %~7 %TEST_ARGS% > _%1 2>&1 && exit /b 1
@(echo.EXIT CODE: %ERRORLEVEL%) >> _%1 && call :cmpdel %1 || exit /b 1
@set TEST_ARGS=
@exit /b

:testsimple_ok_
:: awk should NOT fail
..\gawk.exe %Q% %~2 %~3 %~4 %~5 %~6 %~7 %TEST_ARGS% > _%1 2>&1 || exit /b 1
@(echo.EXIT CODE: %ERRORLEVEL%) >> _%1 && call :cmpdel %1 || exit /b 1
@set TEST_ARGS=
@exit /b

:cmpdel
fc _%1 %1.ok > NUL || (fc _%1 %1.ok & exit /b 1)
@del /q _%1
@exit /b

:build_err
@echo *** Compilation failed! ***
@exit /b 1

:test_err
@echo *** Test failed! ***
@exit /b 1
