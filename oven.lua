local fuel = 260

local oven_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, -0.3125, 0.5, 0.4375}, -- bottom_left
		{0.3125, -0.5, -0.5, 0.5, 0.5, 0.4375}, -- bottom_right
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.4375}, -- bottom_bottom
		{-0.5, -0.5, -0.125, 0.5, 0.5, 0.4375}, -- bottom_inside
		{-0.5, 0.125, -0.5, 0.5, 0.5, 0.4375}, -- bottom_top
		{-0.5, -0.5, -0.5, 0.5, -0.1875, -0.4375}, -- bottom_front
		{-0.4375, 0.5, 0.25, 0.4375, 1.125, 0.4375}, -- top_back
		{-0.5, 0.5, -0.4375, -0.3125, 1.125, 0.4375}, -- top_left
		{0.3125, 0.5, -0.4375, 0.5, 1.125, 0.4375}, -- top_right
		{-0.5, 0.625, -0.4375, 0.5, 1.125, 0.4375}, -- top_front
		{-0.25, -0.5, 0, 0.25, 1.375, 0.5}, -- stack_thing
	}
}

minetest.register_node("jelys_pizzaria:pizza_oven_slot", {
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	floodable = true,
	air_equivalent = true,
	drop = "",
	groups = {not_in_creative_inventory=1},
	on_construct = function(pos)
		local down = {x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.get_node(down).name ~= "jelys_pizzaria:pizza_oven" then
			minetest.remove_node(pos)
		end
	end,
})

local function pizza_above(pos)
	local up = {x=pos.x, y=pos.y+1, z=pos.z}
	local node = minetest.get_node(up)
	local def = minetest.registered_nodes[node.name]
	if def then
		if def.cooked then
			return "raw", def.cooked
		end
		if def.done then
			return "cooked", "jelys_pizzaria:burnt_pizza"
		end
		if node.name == "jelys_pizzaria:burnt_pizza" then
			return "burnt", nil
		end
	end
	return false, nil
end

local function get_oven_state(pos)
	local node = minetest.get_node(pos)
	if node.name == "jelys_pizzaria:pizza_oven" then
		return "empty"
	elseif node.name == "jelys_pizzaria:pizza_oven_fueled" then
		return "fueled"
	elseif node.name == "jelys_pizzaria:pizza_oven_active" then
		return "active"
	end
	return false
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if name == node.name or not name then
		return
	end
	node.name = name
	local timer = minetest.get_node_timer(pos)
	local timeout = timer:get_timeout()
	local elapsed = timer:get_elapsed()
	minetest.swap_node(pos, node)
	timer = minetest.get_node_timer(pos)
	timer:set(timeout, elapsed)
end

local function start_timer(pos, elapsed)
	--Pizza pos
	local pizza_pos = {x=pos.x, y=pos.y+1, z=pos.z}

	--Meta values
	local meta = minetest.get_meta(pos)
	local cook_time_elapsed = meta:get_float("cook_time_elapsed")
	local cook_time = meta:get_float("cook_time")
	local fuel_time = meta:get_float("fuel_time")
	local timer = minetest.get_node_timer(pos)

	--Node States
	local pizza, cooked = pizza_above(pos)
	local oven = get_oven_state(pos)

	--Mode specification
	local mode = ""

	if not pizza and oven == "empty" then
		mode = "empty"
	elseif pizza == "raw" and oven == "active" then
		mode = "cooking"
	elseif cooked == "jelys_pizzaria:burnt_pizza" then
		mode = "burning"
	elseif oven == "empty" and pizza then
		mode = "fuel_empty"
	elseif not pizza and oven ~= "empty" then
		mode = "nopizza"
	end

	--Run timers based on mode
	if pizza and oven == "active" and cook_time > 0 then
		meta:set_float("cook_time_elapsed", cook_time_elapsed+elapsed)
	end
	if oven == "active" and fuel_time > 0 then
		meta:set_float("fuel_time", fuel_time-elapsed)
	end

	--Update values
	cook_time_elapsed = meta:get_float("cook_time_elapsed")
	fuel_time = meta:get_float("fuel_time")
	if not pizza then
		meta:set_float("cook_time_elapsed", 0)
		meta:set_float("cook_time", 0)
		minetest.set_node(pizza_pos, {name = "jelys_pizzaria:pizza_oven_slot"})
	end

	--Make a change
	if cook_time_elapsed > cook_time and cooked then
		minetest.set_node(pizza_pos, {name=cooked})
		meta:set_float("cook_time_elapsed", 0)
		meta:set_float("cook_time", 50)
	end
	if fuel_time <= 1 then
		swap_node(pos, "jelys_pizzaria:pizza_oven")
		if mode == "burning" then
			meta:set_float("cook_time_elapsed", 0)
			meta:set_float("cook_time", 0)
		end
	end

	--Infotext
	local infotext = "Pizza: 100%\nFuel: none;"

	local fuel_percentage = math.max(math.ceil(0.5+fuel_time/fuel*98), 0)
	local cook_percentage = math.floor(0.5+cook_time_elapsed/cook_time*99)

	if mode == "nopizza" then
		infotext = "Pizza: none;\n"..
				"Fuel: ".. fuel_percentage.. "%"
	elseif mode == "cooking" then
		infotext = "Pizza: "..cook_percentage.."%\n"..
				"Fuel: ".. fuel_percentage.. "%"
	elseif mode == "fuel_empty" then
		infotext = "Pizza: "..cook_percentage.."%\n"..
		"Fuel: none;"
	elseif mode == "empty" then
		infotext = "Pizza: none;\nFuel: none;"
	elseif oven == "fueled" and pizza ~= "cooked" then
		infotext = "Pizza: "..cook_percentage.."%\n"..
				"Fuel: ".. fuel_percentage.. "%"
	elseif mode == "burning" then
		infotext = "Pizza will burn in: ".. math.floor(cook_time-cook_time_elapsed).."s\n"..
				"Fuel: ".. fuel_percentage.. "%"
	elseif pizza == "cooked" and oven == "empty" then
		infotext = "Pizza: 100%\n"..
				"Fuel: none;"
	elseif pizza == "burnt" then
		infotext = "Pizza: Burnt"
	end
	local oven_state = ""
	if oven == "active" then
		oven_state = "Active"
	else
		oven_state = "Extinguished"
	end
	meta:set_string("infotext", infotext.."\n"..oven_state)

	--Start next timer
	local tick = cook_time/fuel
	timer:start(tick)
end


local function rightclick(pos, node, player, itemstack, pointed_thing)
	local name = itemstack:get_name()
	local def = minetest.registered_nodes[name]
	local pizzaspace = pizza_above(pos)
	if def and def.cook_time and def.cooked and not pizzaspace then
		local meta = minetest.get_meta(pos)
		local up = {x = pos.x, y = pos.y+1, z = pos.z}
		local itemdef = minetest.registered_nodes[name]
		local cook_time = itemdef.cook_time
		minetest.set_node(up, {name = name})
		meta:set_float("cook_time", math.random(cook_time.min, cook_time.max))
		if node.name == "jelys_pizzaria:pizza_oven_active" then
			start_timer(pos, 0)
			meta:set_float("cook_time_elapsed", 0)
		end
		if not minetest.is_creative_enabled(player:get_player_name()) then
			itemstack:take_item()
		end
	end
	return itemstack
end

local function after_destruct(pos, oldnode)
	local up = {x = pos.x, y = pos.y+1, z = pos.z}
	local pizza = pizza_above(pos)
	local oven = oldnode.name
	minetest.dig_node(up)
	if jpizza.has_depends.fire and oven == "jelys_pizzaria:pizza_oven_active" then
		if minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name = "fire:basic_flame"})
		end
	end
end

minetest.register_node("jelys_pizzaria:pizza_oven_active", {
	drawtype = "mesh",
	paramtype2 = "facedir",
	paramtype = "light",
	light_source = 8,
	drop = "jelys_pizzaria:pizza_oven",
	groups = {cracky = 3, level = 1, pizza_oven = 1, not_in_creative_inventory=1},
	tiles = {
		{
			name = "jelys_pizzaria_pizza_oven_active_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 64,
				aspect_h = 64,
				length = 3.0,
			},
		},
	},
	mesh = "jelys_pizzaria_pizza_oven.obj",
	selection_box = oven_box,
	collision_box = oven_box,
	on_rightclick = rightclick,
	after_destruct = after_destruct,
	on_timer = start_timer,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("jelys_pizzaria:pizza_oven_fueled", {
	drawtype = "mesh",
	paramtype2 = "facedir",
	groups = {cracky = 3, level = 1, pizza_oven = 1, not_in_creative_inventory=1},
	tiles = {
		"jelys_pizzaria_pizza_oven_fueled.png",
	},
	mesh = "jelys_pizzaria_pizza_oven.obj",
	drop = "jelys_pizzaria:pizza_oven",
	selection_box = oven_box,
	collision_box = oven_box,
	after_destruct = after_destruct,
	on_punch = function(pos, node, player)
		local itemstack = player:get_wielded_item()
		if itemstack:get_name() == "default:torch" or itemstack:get_name() == "fire:flint_and_steel" then
			swap_node(pos, "jelys_pizzaria:pizza_oven_active")
			start_timer(pos, 0)
		end
	end,
	on_rightclick = rightclick,
	on_timer = start_timer,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("jelys_pizzaria:pizza_oven", {
	description = "Pizza Oven",
	drawtype = "mesh",
	paramtype2 = "facedir",
	groups = {cracky = 3, level = 1, pizza_oven = 1},
	tiles = {
		"jelys_pizzaria_pizza_oven.png",
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_float("cook_time_elapsed", 0)
		meta:set_float("cook_time", 0)
		meta:set_float("fuel_time", 0)

		start_timer(pos, 0)
	end,
	mesh = "jelys_pizzaria_pizza_oven.obj",
	selection_box = oven_box,
	collision_box = oven_box,
	after_destruct = after_destruct,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local itemstack = player:get_wielded_item()

		if minetest.get_item_group(itemstack:get_name(), "tree") > 0 then
			if not minetest.is_creative_enabled(player:get_player_name()) then
				itemstack:take_item()
			end
			swap_node(pos, "jelys_pizzaria:pizza_oven_fueled")
			minetest.get_meta(pos):set_float("fuel_time", fuel)
		end
		return rightclick(pos, node, player, itemstack, pointed_thing)
	end,
	on_timer = start_timer,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "jelys_pizzaria:reinforced_brick",
	recipe = {
		{"default:clay_brick", "default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick", "default:clay_brick"},
	}
})

minetest.register_craft({
	output = "jelys_pizzaria:pizza_oven",
	recipe = {
		{"jelys_pizzaria:reinforced_brick", "jelys_pizzaria:reinforced_brick", "jelys_pizzaria:reinforced_brick"},
		{"jelys_pizzaria:reinforced_brick", "", "jelys_pizzaria:reinforced_brick"},
		{"jelys_pizzaria:reinforced_brick", "jelys_pizzaria:reinforced_brick", "jelys_pizzaria:reinforced_brick"},
	}
})
