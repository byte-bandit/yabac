Building = Class{}

function Building:init(x, y, name, gfx)
  self.x = x or 0
  self.y = y or 0
  self.name = name or "Unknown"
  self.gfx = gfx or nil
  self.quadMatrix.x = 2
  self.quadMatrix.y = 2
end