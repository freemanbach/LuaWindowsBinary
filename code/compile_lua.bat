@echo off
::
:: Compiles Lua
::

::
:: Set up environment
::

:: Lua windows Binary
:: https://luabinaries.sourceforge.net/download.html

:: Start local variable scope
setlocal

set vsdevcmd="C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"

:: Start the search and variable execution Process
:start_me
  if not exist %vsdevcmd% (
    echo. There is no Visual Studio 2022 Community edition installed.
    echo. Please first Download and install VS-2022 Community edition.
    echo. https://visualstudio.microsoft.com/vs/compare/
    goto end
    ) else (
      echo. Executing VsDevCmd.bat variables
      call %vsdevcmd%
      echo.
      echo.
    )

:: Identify the target architecture
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" set ARCH=x86
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set ARCH=amd64
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set ARCH=arm64
if /i "%ARCH%"=="" goto end

::
:: Process files
:: 
:: the Below portion was copied from here:
:: https://github.com/Pharap/CompilingLua/blob/master/Compile.bat

:: Move down into 'src'
@pushd src

:: This batch file will show details Windows 10
echo.
echo. ============================
echo. Compiling Object File
echo. ============================
echo.
:: Clean up files from previous builds
@if EXIST *.o @del *.o
@if EXIST *.obj @del *.obj
@if EXIST *.dll @del *.dll
@if EXIST *.exe @del *.exe

:: Compile all .c files into .obj
@CL /MD /O2 /c /DLUA_BUILD_AS_DLL *.c

:: Rename two special files
@ren lua.obj lua.o
@ren luac.obj luac.o

echo.
echo. Finished Compiling
echo. 

echo.
echo. ============================
echo. Linking Object Files
echo. ============================
echo.
:: Link up all the other .objs into a .lib and .dll file
@LINK /DLL /IMPLIB:lua.lib /OUT:lua.dll *.obj

:: Link lua into an .exe
@LINK /OUT:lua.exe lua.o lua.lib

:: Create a static .lib
@LIB /OUT:lua-static.lib *.obj

:: Link luac into an .exe
@LINK /OUT:luac.exe luac.o lua-static.lib

:: Move back up out of 'src'
@popd

echo.
echo. Finished Linking Object Files
echo. 

:: Copy the library and executable files out from 'src'
@copy /Y src\lua.exe lua.exe
@copy /Y src\luac.exe luac.exe
@copy /Y src\lua.dll lua.dll

:: Deleting the files in src
@del /q /f src\*.exe
@del /q /f src\*.dll

:: End local variable scope
:end
