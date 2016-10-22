@echo offset
path=%path%;C:\Program Files\7-Zip
::===缓存目录
set filecachepath=C:\Users\kk\AppData\Roaming\com.kaixin001.cj.debug\Local Store\AppCacheResource\
::===资源目录
set resourcepath=..\..\..\shengjiangResource\remoteResource
set iospath=.\ios
set andriodpath=.\andriod

set dolitfile=.\dolist.txt


rd /s /Q %iospath%
rd /s /Q %andriodpath%

md %iospath%
md %andriodpath%
call :copyall

copy "%filecachepath%"\remoteabcdecgcheckfile.json %iospath%
move %iospath%\remoteabcdecgcheckfile.json %iospath%\resmd5.json
copy "%filecachepath%"\remoteabcdecgcheckfile.json %andriodpath%
move %andriodpath%\remoteabcdecgcheckfile.json %andriodpath%\resmd5.json


:copyall
for /R "%resourcepath%" %%i in (*.xml) do (
 call :docopy %%i
)


:docopy
set filename=%~n1
copy %resourcepath%\%filename%.xml %iospath%
copy %resourcepath%\%filename%.atfi %iospath%
copy %resourcepath%\%filename%.xml %andriodpath%
copy %resourcepath%\%filename%.atfa %andriodpath%
