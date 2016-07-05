Stack = Class {}

function Stack:init(items)
	self.items = items or {}
end

function Stack:getSize()
	return #self.items
end

function Stack:top()
	return self.items[#self.items]
end

function Stack:pop()
	return table.remove(self.items)
end

function Stack:push(item)
	table.insert(self.items, item)
	return self
end