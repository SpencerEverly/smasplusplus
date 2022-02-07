cd..
cd..
echo off
for %%a in ("%1\*") do move /y "%%~fa" %2
for /d %%a in ("%1\*") do move /y "%%~fa" %2
exit