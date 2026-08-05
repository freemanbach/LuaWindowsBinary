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

set vsdev22="C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
set vsdev26="C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\VsDevCmd.bat"

:: Start the search and variable execution Process
:check_vs26
  if exist %vsdev26% (
    call %vsdev26%
    goto arch_type
  ) else (
        echo.
        echo. There is no Visual Studio 2026 Community edition installed.
        echo. Please first Download and install VS-2026 Community edition.
        echo. https://visualstudio.microsoft.com/vs/compare/
        echo.
      goto check_vs22
  )

:check_vs22 
  if exist %vsdev22% (
    call %vsdev22%
    goto arch_type
    ) else (
        echo.
        echo. There is no Visual Studio 2022 Community edition installed.
        echo. Please first Download and install VS-2022 Community edition.
        echo. https://visualstudio.microsoft.com/vs/compare/
        echo.
        goto end
    )

:arch_type
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

: handle_file
  echo.
  echo. ============================
  echo.  Making directory
  echo. ============================
  echo.
  :: Make a Directory for exe and dll files
  @mkdir bin

  :: Move down into 'src'
  @pushd src

:compile_it
  :: This batch file will show details Windows 10
  echo.
  echo. ============================
  echo.  Compiling Object File
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

:finish_compile
  echo.
  echo. ===========================
  echo.  Finished Compiling
  echo. ===========================
  echo.

:linking_files
  echo.
  echo. ============================
  echo.  Linking Object Files
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

:completed_linking
  echo.
  echo. ===============================
  echo.  Finished Linking Object Files
  echo. ===============================
  echo.

:moving_files
  :: Copy the library and executable files out from 'src'
  echo.
  echo. ===============================
  echo.  Moving some files around
  echo. ===============================
  echo.
  @copy /Y src\lua.exe lua.exe
  @copy /Y src\luac.exe luac.exe
  @copy /Y src\lua.dll lua.dll

:copying_files
  echo.
  echo. =============================
  echo.  Copy binary files to Bin dir
  echo. =============================
  echo.
  @copy /Y lua.exe .\bin
  @copy /Y luac.exe .\bin
  @copy /Y lua.dll .\bin

:wrapping_up
  :: Deleting the files in src
  @del /q /f src\*.exe
  @del /q /f *.exe
  @del /q /f src\*.dll
  @del /q /f *.dll

:done
  echo.
  echo. Finished.
:: End local variable scope
:end
