local defaultDatabase = "https://locai-abc48-default-rtdb.firebaseio.com/";
local authenticationToken = "BGA6dm1UuvlKSpZB8KORsNtxcnAsUqhUIwZfprAn";

local HttpService = game:GetService("HttpService");
local DataStoreService = game:GetService("DataStoreService");

local FirebaseService = {};
local UseFirebase = true;


function FirebaseService:SetUseFirebase(value)
	UseFirebase = value and true or false;
end

FirebaseService.GetFireBase = {
	method = function(parsed)
		database = parsed.database or defaultDatabase;
		local datastore = DataStoreService:GetDataStore(parsed.name);
		
		local databaseName = database..HttpService:UrlEncode(parsed.name);
		local authentication = ".json?auth="..authenticationToken;
		
		local Firebase = {};
		function Firebase.GetDatastore()
			return datastore;
		end
		function Firebase:GetAsync(directory)
			local data = nil;
			
			local getTick = tick();
			local tries = 0; repeat until pcall(function() tries = tries +1;
				data = HttpService:GetAsync(databaseName..HttpService:UrlEncode(directory and "/"..directory or "")..authentication, true);
			end) or tries > 2;
			if type(data) == "string" then
				if data:sub(1,1) == '"' then
					return data:sub(2, data:len()-1);
				elseif data:len() <= 0 then
					return nil;
				end
			end
			return tonumber(data) or data ~= "null" and data or nil;
		end
		function Firebase:SetAsync(directory, value, header)
			if not UseFirebase then return end
			if value == "[]" then self:RemoveAsync(directory); return end;
			
			header = header or {["X-HTTP-Method-Override"]="PUT"};
			local replyJson = "";
			if type(value) == "string" and value:len() >= 1 and value:sub(1,1) ~= "{" and value:sub(1,1) ~= "[" then
				value = '"'..value..'"';
			end
			local success, errorMessage = pcall(function()
			replyJson = HttpService:PostAsync(databaseName..HttpService:UrlEncode(directory and "/"..directory or "")..authentication, value,
				Enum.HttpContentType.ApplicationUrlEncoded, false, header);
			end);
			if not success then
				warn("FirebaseService>> [ERROR] "..errorMessage);
				pcall(function()
					replyJson = HttpService:JSONDecode(replyJson or "[]");
				end)
			end
		end
		
		function Firebase:RemoveAsync(directory)
			if not UseFirebase then return end
			self:SetAsync(directory, "", {["X-HTTP-Method-Override"]="DELETE"});
		end
		
		function Firebase:IncrementAsync(directory, delta)
			delta = delta or 1;
			if type(delta) ~= "number" then warn("FirebaseService>> increment delta is not a number for key ("..directory.."), delta(",delta,")"); return end;
			local data = self:GetAsync(directory) or 0;
			if data and type(data) == "number" then
				data = data+delta;
				self:SetAsync(directory, data);
			else
				warn("FirebaseService>> Invalid data type to increment for key ("..directory..")");
			end
			return data;
		end
		
		function Firebase:UpdateAsync(directory, callback)
			local data = self:GetAsync(directory);
			local callbackData = callback(data);
			if callbackData then
				self:SetAsync(directory, callbackData);
			end
		end
		
		return Firebase;
	end
}

return FirebaseService;