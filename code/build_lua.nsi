; ------------------------------------------------------------------
; NSIS MUI
;
; Documentations
; https://nsis.sourceforge.io/Docs/Modern%20UI/Readme.html
; ------------------------------------------------------------------

# --------------------------------
#   Include Modern UI
# --------------------------------

  !include "MUI2.nsh"

# --------------------------------
#   Compression
# --------------------------------

!if "{{compression}}" == "none"
   SetCompress off
!else
   ; Set the compression algorithm. We default to LZMA.
   SetCompressor /SOLID "lzma"
!endif

# --------------------------------
#   General
# --------------------------------

  ;Name and file
  Name "Lua Installer"
  OutFile "lua-5.5.0-win64.exe"
  Unicode True
  AllowRootDirInstall True

  ;Default installation folder
  InstallDir "$PROFILE\lua_5.5.0"
  
  ;RequestExecutionLevel admin
  RequestExecutionLevel user

# --------------------------------
#   Interface Configuration
# --------------------------------

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\nsis.bmp"
  !define MUI_ABORTWARNING

# --------------------------------
#   Pages
# --------------------------------

  !insertmacro MUI_PAGE_LICENSE "C:\Users\flo1\Downloads\lua\License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

# --------------------------------
#   Languages
# --------------------------------

  !insertmacro MUI_LANGUAGE "English"

# --------------------------------
#   Installer Sections
# --------------------------------

Section "Default" SecDefault

  SetOutPath "$INSTDIR"
  
  ;ADD YOUR OWN FILES HERE...
  File /r lua-5.5.0\*.*

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

# --------------------------------
#   Descriptions
# --------------------------------

  ;Language strings
  LangString DESC_Install ${LANG_ENGLISH} "To install Lua to your home directory."

  ;Assign Language Strings to Sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecDefault} $(DESC_Install)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END


# --------------------------------
#   Uninstaller Section
# --------------------------------

Section "Uninstall"

  Delete "$INSTDIR\Uninstall.exe"

  RMDir "$INSTDIR"

SectionEnd
