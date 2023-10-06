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
    if exist %vsdevcmd% (
        echo. Executing VsDevCmd.bat variables
        call %vsdevcmd%
        echo.
    ) else (
        echo. There is no Visual Studio 2022 Community edition installed.
		echo. Please first Download VS-2022 Community edition.
		goto end
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

:: Copy the library and executable files out from 'src'
@copy /Y src\lua.exe lua.exe
@copy /Y src\luac.exe luac.exe
@copy /Y src\lua.dll lua.dll

:: End local variable scope
:end