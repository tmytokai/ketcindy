REM 20180401
echo off
set xcp="\Windows\System32\xcopy"
set ketsrc=%HOMEPATH%\Desktop\ketcindyfolder
set prgcin=C:\Program Files (x86)
if not exist "%prgcin%\Cinderella" (
  set prgcin=C:\Program Files
)
NET SESSION > NUL 2>&1
if %ERRORLEVEL% == 0 (
  echo Running as administator
  set admin="y"
) else (
  echo Running as non-administator
  echo If you are an administrator, rerun as adminstrator
  set admin="n"
)
echo 1. C:\kettex\texlive (default)
echo 2. Other texlive
echo 3. w32tex
set /P ans="Choose path of TeX (number): "
if "%ans%" == "1" (
  set kind=\texlive
  set pathT=C:\kettex\texlive
)
if "%ans%" == "2" (
  set kind=\texlive
  set /P pathT="Full path (ex)C:\texlive\2017: "
)
if "%ans%" == "3" (
  set kind=\w32tex
  set /P pathT="Full path (ex)C:\w32tex: "
)
echo Path of TeX is %pathT%
if "%kind%" == "\texlive" (
  set bin=\bin\win32
  set scripts=\texmf-dist\scripts\ketcindy
  set styles=\texmf-dist\tex\latex\ketcindy
  set doc=\texmf-dist\doc\support\ketcindy
) else (
  set bin=\bin
  set scripts=\share\texmf-dist\scripts\ketcindy
  set styles=\share\texmf-dist\tex\latex\ketcindy
  set doc=\share\texmf-dist\doc\support\ketcindy
)
set /P STR_INPUT="Do you really copy ketcindy? (y,n):"
if "%STR_INPUT%" == "y" (
  if exist "%pathT%%kind%%scripts%\." (
    echo Deleting "%pathT%%scripts%"
    rd /s "%pathT%%scripts%"
  )
  echo Copying ketcindy to "%pathT%%scripts%"
  %xcp% /Y /Q /S /E /R "%ketsrc%\scripts\*.*" "%pathT%%scripts%\"
)
set docsrc=doc
if exist "%pathT%%doc%\." (
  echo Deleting docs to "%pathT%%doc%"
  rd /s "%pathT%%doc%"
)
echo Copying doc to "%pathT%%doc%"
%xcp% /Y /Q /S /E /R "%ketsrc%\%docsrc%\*.*" "%pathT%%doc%\"
set stylesrc=style
if exist "%pathT%%styles%\." (
  echo Deleting "%pathT%%styles%"
  rd /s "%pathT%%styles%"
)
echo Copying ketcindy styles to "%pathT%%styles%
%xcp% /Y /Q /S /E /R "%ketsrc%\%stylesrc%\*.*" "%pathT%%styles%\"
"%pathT%%bin%\mktexlsr"

set cindyplug=%prgcin%\Cinderella\Plugins
echo Setting of "%cindyplug%\"
cd "%pathT%%scripts%"
copy /Y "ketjava\KetCindyPlugin.jar" "%cindyplug%\"
cd "%cindyplug%"
set homehead=C:\Users
set /P STR_INPUT="Input head of user home d(efault)=C:\Users :"
if not "%STR_INPUT%" == "d" (
  homehead=%STR_INPUT%
)
echo %homehead%
echo PathThead="%pathT%%bin%\"; > dirhead.txt
echo Homehead="%homehead%"; >> dirhead.txt
echo Dirhead="%pathT%%scripts%"; >> dirhead.txt
echo setdirectory(Dirhead); >> dirhead.txt
echo import("setketcindy.txt"); >> dirhead.txt
echo import("ketoutset.txt"); >> dirhead.txt
set /P STR_INPUT="Input version of R d(efault)=3.4.2 :"
if "%STR_INPUT:~0,1%" == "d" (
  set verR=3.4.2
) else (
  set verR=%STR_INPUT%
)
echo %verR%
set prg=C:\Program Files
if exist "%prg%\R\R-%verR%\bin\" (
  echo PathR="%prg%\R\R-%verR%\bin"; >> dirhead.txt
) else (
  if exist "%prg% (x86)\R\R-%verR%\bin\" (
    echo "%prg% (x86)\R\R-%verR%\bin"; >> dirhead.txt
  ) else (
    echo "R-%verR% not found"
  )
)
set /P STR_INPUT="Input version of Maxima d(efault)=5.37.3 :"
if "%STR_INPUT:~0,1%" == "d" (
  set verM=5.37.3
) else (
  set verM=%STR_INPUT%
)
echo %verM%
set prg=C:\maxima-%verM%\bin\maxima.bat
if exist "%prg%" (
  echo PathM="%prg%"; >> dirhead.txt
) else (
  echo "Maxima-%verM% not found"
  )
)
set prgSm=C:\Program Files (x86)\SumatraPDF\SumatraPDF.exe
if not exist "%prgSm%" (
  set prgSm=C:\Program Files\SumatraPDF\SumatraPDF.exe
)
echo Pathpdf="%prgSm%"; >> dirhead.txt
echo "Plugins of Cindy has been set"
pause
