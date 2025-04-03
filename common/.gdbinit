set auto-load safe-path /
set history save on
set history size 10000
set history filename ~/.gdb_history
set history expansion on

define hook-next
	next
	refresh
end

define hook-continue
	continue
	refresh
end

define hook-step
	step
	refresh
end
