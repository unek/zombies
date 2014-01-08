local path = ...
-- basic components
require(path .. ".Transformable")

-- physics
require(path .. ".Physics")
require(path .. ".ColliderRectangle")
require(path .. ".ColliderCircle")
require(path .. ".Movement")

-- render
require(path .. ".Sprite")
require(path .. ".RenderCircle")
require(path .. ".RenderRectangle")
require(path .. ".FillColor")
require(path .. ".FillTexture")

-- ai
require(path .. ".SimpleFollowAI")

-- health
require(path .. ".Health")
require(path .. ".HealthIndicator")
require(path .. ".MeleeAttacker")
require(path .. ".Bleeding")
require(path .. ".Explosive")

-- other
require(path .. ".Inventory")

require(path .. ".Pickup")
require(path .. ".Vehicle")
