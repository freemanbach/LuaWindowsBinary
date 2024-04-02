#NSIS Modern User Interface

#--------------------------------
#Include Modern UI
#--------------------------------

  !include "MUI2.nsh"

#--------------------------------
#General
#--------------------------------

  #Name and file
  Name "Lua Installer"
  OutFile "lua_v5.4.6.exe"
  Unicode True
  AllowRootDirInstall True

  #Default installation folder
  InstallDir "$PROFILE\lua_5.4.6"
  
  RequestExecutionLevel admin

#--------------------------------
#Interface Configuration
#--------------------------------

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\nsis.bmp" ; optional
  !define MUI_ABORTWARNING

#--------------------------------
#Pages
#--------------------------------

  !insertmacro MUI_PAGE_LICENSE "C:\Users\flo1\Downloads\lua\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

#--------------------------------
#Languages
#--------------------------------

  !insertmacro MUI_LANGUAGE "English"

#--------------------------------
#Installer Sections
#--------------------------------

Section "Default" SecDefault

  SetOutPath "$INSTDIR"
  
  #ADD YOUR OWN FILES HERE...
  File /r lua-5.4.6\*.*

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

#--------------------------------
#Descriptions
#--------------------------------

  #Language strings
  #LangString DESC_SecDummy ${LANG_ENGLISH} "A test section."

#--------------------------------
#Uninstaller Section
#--------------------------------

Section "Uninstall"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

SectionEnd