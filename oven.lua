minetest.register_node("jelys_pizzaria:pizza_oven_slot", {
	drawtype = "none",
	on_construct = function(pos)
		local down = {x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.get_node(down).name ~= "jelys_pizzaria:pizza_oven" then
			minetest.remove_node(pos)
		end
	end,
})


local function start_timer(pos, tick, mode)
	local up = {x=pos.x, y=pos.y+1, z=pos.z}
	local node = minetest.get_node(up)
	local meta = minetest.get_meta(pos)
	
	local cook_time = meta:get_float("cook_time")
	local elapsed = meta:get_float("cook_time_elapsed")
	meta:set_float("cook_time_elapsed", elapsed+tick)
	elapsed = meta:get_float("cook_time_elapsed")
	local timer = minetest.get_node_timer(pos)
	if mode == "cooking" then
		if not minetest.registered_nodes[node.name].cooked then
			minetest.set_node(up, "jelys_pizzaria:pizza_oven_slot")
			meta:set_string("infotext", "Empty Pizza Oven")
		end
		local percentage = (elapsed/cook_time)*100
		meta:set_string("infotext", "Pizza is "..math.floor(percentage+0.5).."% cooked")
		timer:start(100/cook_time)
	elseif mode == "burning" then
		if not minetest.registered_nodes[node.name].done then
			minetest.set_node(up, "jelys_pizzaria:pizza_oven_slot")
			meta:set_string("infotext", "Empty Pizza Oven")
		end
		local time= math.floor(50.5-elapsed)
		meta:set_string("infotext", "Pizza is ready. "..time.."s until pizza burns")
		timer:start(2)
	end
end


minetest.register_node("jelys_pizzaria:pizza_oven", {
	description = "Pizza Oven",
	drawtype = "mesh",
	paramtype2 = "facedir",
	tiles = {
		"jelys_pizzaria_pizza_oven.png",
	},
	mesh = "jelys_pizzaria_pizza_oven.obj",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.3125, 0.5, 0.5}, -- NodeBox1
			{-0.5, -0.5, -0.5, 0.5, -0.3125, 0.5}, -- NodeBox2
			{0.3125, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox3
			{-0.5, 0.125, -0.5, 0.5, 0.5, 0.5}, -- NodeBox4
			{-0.5625, -0.5, -0.4375, 0.5625, 0.5, 0.5}, -- NodeBox5
			--{-0.4375, 0.5, -0.0625, 0.4375, 1.0625, 0.5}, -- NodeBox6
			--{-0.5625, 0.5, -0.4375, -0.3125, 1.0625, 0.4375}, -- NodeBox7
			--{0.3125, 0.5, -0.4375, 0.5625, 1, 0.5}, -- NodeBox8
			--{-0.5625, 0.75, -0.4375, 0.5625, 1.0625, 0.5}, -- NodeBox9
			--{-0.5625, 0.5, -0.4375, 0.5625, 0.625, -0.375}, -- NodeBox10
		}
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_float("cook_time_elapsed", 0)
		meta:set_float("cook_time", 0)
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local name = itemstack:get_name()
		local def = minetest.registered_nodes[name]
		if def and def.cook_time and def.cooked then
			local up = {x = pos.x, y = pos.y+1, z = pos.z}
			local itemdef = minetest.registered_nodes[name]
			local cook_time = itemdef.cook_time
			minetest.set_node(up, {name = name})
			minetest.get_meta(pos):set_float("cook_time", math.random(cook_time.min, cook_time.max))
			start_timer(pos, 0, "cooking")
			if not minetest.is_creative_enabled(player:get_player_name()) then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
	on_timer = function(pos, elapsed)
		local uppos = {x = pos.x, y = pos.y+1, z = pos.z}
		local up = minetest.get_node(uppos)
		local def = minetest.registered_nodes[up.name]
		local meta = minetest.get_meta(pos)
		if def.cooked and def.cook_time then
			if meta:get_float("cook_time_elapsed") >= meta:get_float("cook_time")then
				minetest.set_node(uppos, {name=def.cooked})
				meta:set_float("cook_time_elapsed", 0)
				start_timer(pos, 0, "burning")
			else
				start_timer(pos, elapsed, "cooking")
			end
		end
		if def.done then
			if meta:get_float("cook_time_elapsed") >= 50 then
				minetest.set_node(uppos, {name="jelys_pizzaria:burnt_pizza"})
				meta:set_string("infotext", "The Pizza is burnt")
			else
				start_timer(pos, elapsed, "burning")
			end
		end
	end,
})
