local Class = require("lib.middleclass")

local Stack = Class("Stack")

function Stack:initialize()
	self.items = {}
end

function Stack:push(item)
	self.items[#self.items + 1] = item
end

function Stack:pop()
	local item = self:peek()

	self.items[#self.items] = nil

	return item
end

function Stack:peek()
	return self.items[#self.items]
end

function Stack:count()
	return #self.items
end

function Stack:contains(item)
	for _, other in ipairs(self.items) do
		if (item == other) then
			return true
		end
	end

	return false
end

function Stack:toArray(out)
	out = out or {}

	for _, item in ipairs(self.items) do
		out[#out+1] = item
	end

	return out
end

function Stack:clone()
	local clone = Stack()

	self:cloneInto(clone)

	return clone
end

function Stack:cloneInto(clone)
	for _, item in ipairs(self.items) do
		clone:push(item)
	end

	return clone
end

function Stack:clear()
	for i = 1, #self.items do
		self.items[i] = 0
	end
end

return Stack