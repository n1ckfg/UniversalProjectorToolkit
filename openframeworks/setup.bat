@echo off

set DIR=%cd%
cd ..\..\addons

git clone https://github.com/n1ckfg/KinectProjectorToolkit
git clone https://github.com/n1ckfg/KinectProjectorToolkitV2

cd %DIR%

@pause
