require 'src.math'

CameraManager = Class{}

function CameraManager:init()
  self.camera = Camera(0,0)
  self.camera.smoother = Camera.smooth.damped(2)
  self.scrollspeed = 4
end

function CameraManager:attach()
  self.camera:attach()
end

function CameraManager:detach()
  self.camera:detach()
end

function CameraManager:update(dt)
  if love.keyboard.isDown('up') then
    self.camera:move(0, -self.scrollspeed)
  end

  if love.keyboard.isDown('down') then
    self.camera:move(0, self.scrollspeed)
  end

  if love.keyboard.isDown('right') then
    self.camera:move(self.scrollspeed, 0)
  end

  if love.keyboard.isDown('left') then
    self.camera:move(-self.scrollspeed, 0)
  end

  self.camera.x = math:clamp(0, self.camera.x, world.size.x * world.grain)
  self.camera.y = math:clamp(0, self.camera.y, world.size.y * world.grain)

  Debug:print("Camera position: "..self.camera.x..", "..self.camera.y)
end

function CameraManager:handleMouseWheel(x, y)
  local x = x or 0
  local y = y or 0
  local s = math:clamp(0.5, self.camera.scale + x, 1)

  self.camera:zoomTo(s)
  self.scrollspeed = math:round(8 / s, 1)
end

function CameraManager:getCamera()
  return self.camera
end