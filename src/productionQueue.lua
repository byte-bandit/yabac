ProductionQueue = Class
{
	State = 
	{
		Paused = 1,
		Running = 2,
		Halted = 3,
		Finished = 4,
		Unable = 5
	}
}

function ProductionQueue:init(output, input, duration)
	self.output = output
	self.input = input
	self.environmentalInpact = environmentalInpact
	self.duration = duration
	self.progress = 0
	self.state = ProductionQueue.State.Unable
end

function ProductionQueue:update(dt)
	if self.state == ProductionQueue.State.Running then
		self.progress = self.progress + dt

		if self.progress >= self.duration then
			self.progress = self.duration
			self.state = ProductionQueue.State.Finished
		end
	elseif self.state == ProductionQueue.State.Halted then
		if self.input then
			if resourceManager:tryRemove(self.input) then
				self.state = ProductionQueue.State.Running
			end
		else
			self.state = ProductionQueue.State.Running
		end
	end
end

function ProductionQueue:start()
	self.progress = 0
	self.state = ProductionQueue.State.Halted
end

function ProductionQueue:pause()
	self.bufferedState = self.state
	self.state = ProductionQueue.State.Paused
end

function ProductionQueue:unpause()
	if self.bufferedState then
		self.state = self.bufferedState
		self.bufferedState = nil
	else
		self.state = ProductionQueue.State.Halted
	end
end