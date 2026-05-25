--- a short description
-- @classmod long_range_sensor
local long_range_sensor = {}

-- class table
local LongRangeSensor = {}

function LongRangeSensor:LongRangeSensor()
end

function long_range_sensor.new(...)
  local self = {}
  setmetatable(self, { __index = LongRangeSensor })
  self:LongRangeSensor(...)
  return self
end

return long_range_sensor
