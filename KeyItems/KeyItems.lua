_addon.name = 'KeyItems'
_addon.author = 'Brax'
_addon.version = '1.0.0.0'
_addon.command = 'ki'

require('chat')
require('logger')
require('tables')
res = require('resources')

KI = windower.ffxi.get_key_items()

function search_ki(term)
	for i,v in pairs(KI) do
		if string.lower(res.key_items[v].en):find(string.lower(term)) then
		windower.add_to_chat(2,res.key_items[v].category..':'..res.key_items[v].en)
		end
	end
end

windower.register_event('addon command',function (...)
    local term = table.concat({...}, ' ')
	broken = term:split(' ',4)
	if #term > 0 then
		search_ki(term)
	end
end)
