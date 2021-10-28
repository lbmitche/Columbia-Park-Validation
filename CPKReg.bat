@echo OFF

REM Setup weekly task to run regression
SCHTASKS /CREATE /SC WEEKLY /TN "MyTasks\CPKWeeklyReg" /TR "C:\Temp\CPKRegAuto\CopyProc.ps1" /ST 5:00

REM === arguments ===
SET PEER=172.30.53.234
SET SUT=172.30.53.155
SET AUT=8086:1592,1
SET AIP=192.168.150.1
SET BUT=8086:1592,1
SET BIP=192.168.150.2
SET OUTPUT="C:\AGAT_framework_log\CPK_RegressionV3"
SET BUILD="C:\berta\var\builds\Release_26.4_Reference\56_643"

REM === test names ===
SET PING=ping_test
SET MULTI=multiprotocol_stress
SET RSSTSS=rss_tss_multi_queue
SET JUMBO=jumbo
SET BRAND=branding_string
SET DATACORR=data_corruption
SET RSSDIS=rss_disabled
SET MEMLEAK=mem_leak_win

mkdir "%OUTPUT%"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html

REM === list of tests to run ===
CALL :ping_test
CALL :multiprotocol_stress
CALL :rss_tss_multi_queue
CALL :execute_jumbo_full_set
CALL :branding_string
CALL :data_corruption
CALL :rss_disabled
CALL :mem_leak_win
EXIT 0

REM === test sets ===
:execute_jumbo_full_set
ECHO Jumbo test: SUT "default" and Client "default"
CALL :jumbo default default
ECHO Jumbo test: SUT "default" and Client "4k"
CALL :jumbo default 4k
ECHO Jumbo test: SUT "default" and Client "9k"
CALL :jumbo default 9k
ECHO Jumbo test: SUT "4k" and Client "default"
CALL :jumbo 4k default
ECHO Jumbo test: SUT "4k" and Client "4k"
CALL :jumbo 4k 4k
ECHO Jumbo test: SUT "4k" and Client "9k"
CALL :jumbo 4k 9k
ECHO Jumbo test: SUT "9k" and Client "default"
CALL :jumbo 9k default
ECHO Jumbo test: SUT "9k" and Client "4k"
CALL :jumbo 9k 4k
ECHO Jumbo test: SUT "9k" and Client "9k"
CALL :jumbo 9k 9k
EXIT /B 0

REM === test functions ===
:mem_leak_win
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t mem_leak_win iteration=1 -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%MEMLEAK%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%MEMLEAK%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:ping_test
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t ping_test -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%PING%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%PING%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:multiprotocol_stress
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t multiprotocol_stress duration=600 tr_type=iperf tcp=True udp=True icmp=True sctp=False ip_ver=4 -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%MULTI%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%MULTI%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:rss_tss_multi_queue
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t rss_tss_multi_queue traffic_proto=tcp traffic_duration=30 -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%RSSTSS%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%RSSTSS%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:jumbo
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t jumbo jumbo_sut=%~1 jumbo_client=%~2 -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\jumbo_sut_%~1_client_%~2.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\jumbo_sut_%~1_client_%~2_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:branding_string
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t branding_string static=FILE -m %SUT% -a %AUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%BRAND%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%BRAND%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:data_corruption
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t data_corruption direction=rxtx iteration=0 duration=3600 ports=1 min_size=300 max_size=1000 -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%DATACORR%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%DATACORR%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

:rss_disabled
C:\Python37-AGAT\python.exe C:\AGAT_TRY\main.py test -t rss_disabled traffic_proto=tcp ip_ver=4 -m %SUT% -a %AUT% -p %PEER% -b %BUT% -d %BUILD%
copy C:\AGAT_framework_log\current.log "%OUTPUT%\%RSSDIS%.log"
copy C:\AGAT_framework_log\target.log "%OUTPUT%\%RSSDIS%_target.log"
del C:\AGAT_framework_log\*.log
del C:\AGAT_framework_log\*.html
EXIT /B 0

REM To Do: Automatically call the log parser 
C:\log-parser\summary.py -r "%OUTPUT%"