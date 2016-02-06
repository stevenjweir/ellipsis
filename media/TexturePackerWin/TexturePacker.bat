@echo off
cd %~dp0
START /B /WAIT TexturePacker.exe -input ..\Default -output ..\Textures.xbt
cd ../..

