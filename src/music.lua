Music = Class {}

function Music:init()
    self.tracks = {}
    self.tracks[0] = love.audio.newSource("assets/music/calm.ogg")
    self.tracks[1] = love.audio.newSource("assets/music/fields.ogg")
    self.currentTrack = 0

    love.audio.play(self.tracks[0])
end

function Music:update(dt)
    if self.tracks[self.currentTrack]:isStopped() then
        self.tracks[self.currentTrack]:rewind()
        self.currentTrack = self.currentTrack + 1
        if self.currentTrack == 1 then self.currentTrack = 0 end
        love.audio.play(self.tracks[self.currentTrack])
    end

    if love.keyboard.isDown('m') then
        if not self.muteSwitch then
            self.muteSwitch = true
            local vol = 1
            if self.tracks[self.currentTrack]:getVolume() == 0 then vol = 1 else vol = 0 end
            for k,v in pairs(self.tracks) do
                v:setVolume(vol)
            end
        end
    else
        self.muteSwitch = false
    end
end