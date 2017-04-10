call ipconfig /release
call ipconfig /renew
call ipconfig /flushdns
call ipconfig /registerdns
call nbtstat -rr
call netsh int ip reset all
call netsh winsock reset