local oats = {}

--- @class tag
--- @field name string

--- @overload fun(table): tag
local tag = setmetatable({}, {__call = function(self, new)
	if not new.name then
		error("Attempting to create a tag without a name", 2)
	end
	setmetatable(new, self)
end})
tag.__index = tag

local t1 = tag { name = "tester" }

--- @alias node string|tag
--- @alias callback fun(event: "text"|"open"|"close"|"warn", content: string|nil): nil

--- @param callback callback
--- @param last number
--- @param current number
--- @param number number
local function handledepth(callback, last, current, number)
	for _ = current, last do
		callback("close")
	end
	if current > last+1 then
		error(string.format("Line %i: Indentation increased by more than one level: %i -> %i", number, last, current))
	end
end

--- @param callback callback
--- @param line string
--- @param number number Line number currently being processed
local function parseline(callback, line, lastdepth, number)
	local depth, name, text

	depth, name = line:match("^\t*()%[([^%s]+)%]$")
	if depth then
		handledepth(callback, lastdepth, depth, number)
		callback("open", name)
		return depth
	end

	depth, name, text = line:match("^\t*()%[([^%s]+)%]%s*(.*)$")
	if depth then
		handledepth(callback, lastdepth, depth, number)
		callback("open", name)
		callback("text", text)
		callback("close")
		return depth-1 -- Minus one because the tag is already closed
	end

	if line:match("^%s*$") then
		return lastdepth
	end

	depth, text = line:match("^\t*()(.*)$")
	if depth then
		handledepth(callback, lastdepth, depth, number)
		callback("text", text)
		return depth-1 -- Minus one because text doesn't get closed
	end
end

--- Decodes a stream of lines
--- @param callback callback
function oats.parse(callback, ...)
	local line = 1
	local depth = 0
	for content in ... do
		depth = parseline(callback, content, depth, line)
		line = line + 1
	end
end

--- @return (node)[]
--- @return callback
local function consumer(document)
	document = document or {}
	local current = document
	local path = {current}
	local function callback(event, content)
		if event == "text" then
			table.insert(current, content)
		elseif event == "open" then
			local next = {name=content}
			table.insert(current, next)
			table.insert(path, next)
			current = next
		elseif event == "close" then
			local i = #path
			path[i] = nil
			current = path[i-1]
		end
	end
	return document, callback
end

--- Decodes a string
--- @param input string An entire OATS document contained in a string
--- @return (node)[] # A list of top-level elements
--- @overload fun(path:string): nil,string
function oats.decode(input)
	local document, callback = consumer()
	oats.parse(callback, input:gmatch("[^\n]+"))
	return document
end

--- Decodes a file
--- @param path string Path to the file to decode
--- @return (node)[] # A list of top-level elements
--- @overload fun(path:string): nil,string
function oats.decodefile(path)
	local file, err = io.open(path)

	if not file then
		err = err or "Unknown error opening file"
		return nil, err
	end

	local document, callback = consumer()

	oats.parse(callback, file:lines())

	return document
end

return oats
