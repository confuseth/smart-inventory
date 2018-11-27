local file = {}
file.input = "file"
file.color = Color(200,200,200,255)
--file.whitelist = {"control" , "external", "multiple"}
file.description = "Create a file. Usage: file + 'string'."
function file:runcmd(text, panel, entity)
	local cmd = string.match(text, "file%s+(%w+)") or ""
	cmd = string.Trim(cmd)

	self.color = Color(255,30,30,255)
	local output = "ERROR: Incorrect usage of command. Usage: file + 'string'."

	if !entity.files then
		entity.files = entity.files or {}
	end
	local pass = true
	for k, v in pairs(entity.files) do
		if v.name == cmd then
			pass = false
			break
		end
	end
	if pass then
		table.insert( entity.files, { name = cmd, content = "" } )
		self.color = Color(200,200,200,255)
		output = "File created under the name of " .. cmd .. "."
	end
	return output
end

CONSOLE:addCommand( "file" , file )

local write = {}
write.input = "write"
write.color = Color(200,200,200,255)
--write.whitelist = {"control" , "external", "multiple"}
write.description = "Write content for a file. Usage: write + 'file' + 'string'."
function write:runcmd(text, panel, entity)

	self.color = Color(255,30,30,255)
	local output = "ERROR: Incorrect usage of command. Usage: write + 'file' + 'string'."

	local cmd = string.match(text, "write%s+(.+)") or ""
	cmd = string.Trim(cmd)

	local file = string.match(cmd, "(%a+)%s+(.+)") or ""
	file = string.Trim(file)
	if entity.files then
		for k, file_table in pairs(entity.files) do
			if file_table.name == file then
				self.color = Color(200,200,200,255)
				output = "File " .. file .. " has been written to."
				local cont = string.match(cmd,  file .. "%s+(.+)")
				cont = string.Trim(cont)

				file_table.contents = cont
				break
			end
		end
	end

	return output
end

CONSOLE:addCommand( "write" , write )

local read = {}
read.input = "read"
read.color = Color(200,200,200,255)
--file.whitelist = {"control" , "external", "multiple"}
read.description = "Read a file. Usage: read + 'string'."
function read:runcmd(text, panel, entity)

	self.color = Color(255,30,30,255)
	local output = "ERROR: Incorrect useage of command. Usage: read + 'file'."

	local cmd = string.match(text, "read%s+(%w+)") or ""
	cmd = string.Trim(cmd)
	for k, file_table in pairs(entity.files) do
		if file_table.name == cmd then
			self.color = Color(200,200,200,255)
			output = file_table.contents
			break
		end
	end

	return output
end
CONSOLE:addCommand( "read" , read )