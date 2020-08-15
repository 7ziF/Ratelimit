-- Created by Lelance @ 15th August
-- RateLimit requests
-- Example Usage:
--[[
  local RateLimiter = require(script:WaitForChild("RateLimit"));
  RateLimiter:New("RemoteRequest-1", 3)
  local ReturnValue = "hello"
  game.ReplicatedStorage.RemoteRequest.OnServerInvoke:Connect(function(Player)
      local OnCooldown = RateLimiter:Add(Player, "RemoteRequest-1")
      if OnCooldown then
          return "CoolDown"
      else
          return ReturnValue
      end
  end)
]]
local ratelimit = {}

function ratelimit:New(name, limit)
	if typeof(name) ~= 'string' then return nil end
	if limit == nil then
		limit = 5;
	end
	
	if ratelimit[name] == nil then
		ratelimit[name] = {Limit = limit}
	end
end

function ratelimit:Add(player,name, lim)
	if typeof(name) ~= 'string' then return nil end
	local uid = tostring(player.UserId)
	if not (ratelimit[name]) then
		ratelimit[name] = {Limit = lim or .5}
	end
	
	if ratelimit[name][uid] == nil then
		ratelimit[name][uid] = 0
	end
	local CompareTime = ratelimit[name][uid]
	local CurrentTime = tick()
	local LimitNumber = ratelimit[name].Limit
	
	if (CurrentTime - CompareTime) <= LimitNumber then
		return true
	else
		ratelimit[name][uid] = tick()
	end
	return false
end

function ratelimit:Remove(player)
	for _,v in next, ratelimit do
		if v[tostring(player.UserId)] then
			table.remove(v, tostring(player.UserId))
		end
	end
end

return ratelimit
