function love.load( ... )
	love.graphics.setBackgroundColor(255,255,255)
	gridUnit = 8
	mx = 0
	my = 0
	k = {0,1,1,1,2}
	organisms = {}
	dead = {}
	t = 0
	mapH = love.graphics.getHeight()/gridUnit
	mapW = love.graphics.getWidth()/gridUnit 
	map = {}
	startSimulation = false

	for i = 0, mapH do
		map[i] = {}
		for j = 0, mapW do
			map[i][j] = 0
		end
	end
end
function resetDead()
	-- for i = 0, mapH do
	-- 	for j = 0, mapW do
	-- 		if map[i][j] == 3 then
	-- 			map[i][j] = 0
	-- 		end
	-- 	end
	-- end
	for i = 1, #dead do 
		if map[dead[i][1]][dead[i][2]] == 3 then
			map[dead[i][1]][dead[i][2]] = 0
		end
	end
	dead = {}
end

function updateOrganisms()
	i = #organisms
	while i > 0 do
		if map[organisms[i][1]][organisms[i][2]] == 0 then
			table.remove(organisms,i)
		else
			map[organisms[i][1]][organisms[i][2]] = 1
		end
		i = i - 1
	end
	-- body
end


function generateBlock(y,x)
		--check bottom
		if map[y+1][x] == 0 then
			table.insert(dead,{y+1,x})
			map[y+1][x] = 3
		end
		--bottom right
		if map[y+1][x+1] == 0 then
			table.insert(dead,{y+1,x+1})
			map[y+1][x+1] = 3
		end 
		-- bottom left
		if map[y+1][x-1] == 0 then
			table.insert(dead,{y+1,x-1})
			map[y+1][x-1] = 3
		end
		-- right
		if map[y][x+1] == 0 then
			table.insert(dead,{y,x+1})
			map[y][x+1] = 3
		end
		-- left
		if map[y][x-1] == 0 then
			table.insert(dead,{y,x-1})
			map[y][x-1] = 3
		end
		--check top
		if map[y-1][x] == 0 then
			table.insert(dead,{y-1,x})
			map[y-1][x] = 3
		end
		--top right
		if map[y-1][x+1] == 0 then
			table.insert(dead,{y-1,x+1})
			map[y-1][x+1] = 3
		end 
		-- top left
		if map[y-1][x-1] == 0 then
			table.insert(dead,{y-1,x-1})
			map[y-1][x-1] = 3
		end
		-- print(#dead)
		-- print(#organisms)
	-- body
end
function countSurrounding(y,x)
	count = 0
	if map[y+1][x] == 1 then
			count = count + 1;
	end
		--bottom right
	if map[y+1][x+1] == 1 then
		count = count + 1;
	end 
	-- bottom left
	if map[y+1][x-1] == 1 then
		count = count + 1;
	end
	-- right
	if map[y][x+1] == 1 then
		count = count + 1;
	end
	-- left
	if map[y][x-1] == 1 then
		count = count + 1;
	end
	--check top
	if map[y-1][x] == 1 then
		count = count + 1;
	end
	--top right
	if map[y-1][x+1] == 1 then
		count = count + 1;
	end 
	-- top left
	if map[y-1][x-1] == 1 then
		count = count + 1;
	end
	-- print(count)
	return count
end

function willDie()
	-- count = 0
	i = #organisms
	-- print('total ' .. tostring(#organisms) .. '\n')
	temp = {}
	while i > 0 do
		oy = organisms[i][1]
		ox = organisms[i][2]
		num = countSurrounding(oy,ox)
		-- print(num)
		--check bottom
		if num > 3  or num < 2 then
			-- print("dead" .. tostring(num))
			table.insert(temp,{organisms[i][1],organisms[i][2]})
			-- map[organisms[i][1]][organisms[i][2]]  = 0
		end
		i = i - 1
	end
	for i=1, #temp do
		map[temp[i][1]][temp[i][2]]  = 0
	end


	-- body
end
function willReproduce()
	resetDead()
	for i=1, #organisms do
		generateBlock(organisms[i][1],organisms[i][2])
	end
	i = #dead
	-- print(tostring(i) .. '\n')
	while i > 0 do
		-- x,y

		num = countSurrounding(dead[i][1],dead[i][2])
		--check bottom
		-- print(num)
		if num == 3 then
			-- map[dead[i][1]][dead[i][2]] = 1
			table.insert(organisms,{dead[i][1],dead[i][2]})
			-- generateBlock(dead[i][1],dead[i][2])
			table.remove(dead,i)
		end
		i = i - 1
	end
end



function love.mousepressed( x, y, button, istouch, presses ) 
	mx = x
	my = y
	mapx = math.floor(mx/gridUnit)
	mapy = math.floor(my/gridUnit)
	if button == 1 then
		-- print(#organisms)
		if map[mapy][mapx] ~= 1 then
			-- resetDead()
			table.insert(organisms,{mapy,mapx})
			map[mapy][mapx] = 1
			generateBlock(mapy,mapx)
			-- for i=1, #organisms do
				-- generateBlock(organisms[i][1],organisms[i][2])
			-- end
			-- generateBlock(mapy,mapx)
			-- print("y" .. tostring(organisms[#organisms][1]) .. " x" .. tostring(organisms[#organisms][2]))
		end
		-- print(math.floor(my/gridUnit))
	end
	if button == 2 then

	end
	-- 	map[mapy][mapx] = 0
	-- 	-- resetDead()
	-- 	updateOrganisms()
	-- 	-- for i=1, #organisms do
	-- 	-- 	generateBlock(organisms[i][1],organisms[i][2])
	-- 	-- end

	-- 	-- updateOrganisms()
	-- end
end
function love.keypressed(key)
	if key == "return" then

		if startSimulation == false then
			startSimulation = true
			print(startSimulation)
		else 
			startSimulation = false
		end

	end
end




function love.update(dt)
	fps = love.timer.getFPS()
	t = t + dt
	updateOrganisms()
	if t > (fps-1)/fps and startSimulation == true and love.mouse.isDown(1) == false then
		willReproduce()
		willDie()
		updateOrganisms()
		resetDead()
		for i=1, #organisms do
			generateBlock(organisms[i][1],organisms[i][2])
		end
		t = 0
	end

end

function love.draw( ... )

	for i = 0, mapH do
		for j = 0, mapW do
			if map[i][j] == 1 then
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("fill",j*gridUnit,i*gridUnit,gridUnit,gridUnit)
			end
			-- if map[i][j] == 3 then
			-- 	love.graphics.setColor(255,0,0)
			-- 	love.graphics.rectangle("fill",j*gridUnit,i*gridUnit,gridUnit,gridUnit)
 		-- 	end
		end
	end
end