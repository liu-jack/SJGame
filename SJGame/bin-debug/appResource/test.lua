-- Override print so results can be displayed in canvas
-- print = as3.makeprinter(output)

-- Test print function
print("Hello from Lua")
print("Another print message")
print("Yet another print message")
print("Goodbye")


print(v1)

function testluaclass(c)
	print(c)
	local v = as3.class.engine_starling.utils.SBitSet.new()
	local v1 = as3.class.SJ.Game.utils.SDateUtil.currentUTCSeconds
	return
		as3.tolua(v),
		as3.tolua(v1)
end

