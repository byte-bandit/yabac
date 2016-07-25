ProductionQueue = Class{}

ProductionQueue.State.Paused = 0
ProductionQueue.State.Running = 1
ProductionQueue.State.Halted = 2
ProductionQueue.State.Finished = 3

function ProductionQueue:init()
	self.output = {}
	self.input = {}
	self.duration = 0
	self.progress = 0
	self.state = ProductionQueue.State.Halted
end

function ProductionQueue:init(output, input, duration)
	self.output = output
	self.input = input
	self.duration = duration
	self.progress = 0
	self.state = ProductionQueue.State.Halted
end

function ProductionQueue:update(dt)
	if self.state == ProductionQueue.State.Running then
		self.progress = self.progress + dt

		if self.progress >= self.duration then
			self.progress = self.duration
			self.state = ProductionQueue.State.Finished
		end
	elseif self.state == ProductionQueue.State.Halted then
		-- check if input resource is available and start queue
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