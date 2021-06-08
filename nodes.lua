local function find(value, key, list)
	for _, i in  pairs(list) do
		if i[key] == value then
			return _
		end
	end
	return false
end

minetest.register_node("jelys_pizzaria:dough", {
	description = "Pizza dough",
	tiles = {
		"jelys_pizzaria_pizza_dough.png",
	},
	groups = {rolling_pin=2, oddly_breakable_by_hand=3, attached_node = 1},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	--node_dig_prediction = "jelys_pizzaria:dough_rolled",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, -0.25, 0.125},
			{-0.25, -0.5, -0.125, 0.25, -0.25, 0.0625},
			{-0.125, -0.5, -0.25, 0.125, -0.25, 0.1875},
			{-0.125, -0.5, -0.1875, 0.125, -0.1875, 0.125},
		}
	},
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if digger:get_wielded_item():get_name() == "jelys_pizzaria:rolling_pin" then
			minetest.set_node(pos, {name = "jelys_pizzaria:dough_rolled"})
		end
	end,
	sounds = {
		footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},--https://freesound.org/people/JanKoehl/sounds/85604/
		dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
	},
})

jpizza.register_pizza("jelys_pizzaria:dough_rolled", {
	description = "Rolled Pizza dough",
	texture = {
		"jelys_pizzaria_pizza_dough.png",
		"jelys_pizzaria_pizza_dough.png"
	},
	drop = "jelys_pizzaris:dough",
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if itemstack:get_name() == "jelys_pizzaria:sauce" then
			minetest.set_node(pos, {name="jelys_pizzaria:dough_with_sauce"})
		end
	end,
})

jpizza.register_pizza("jelys_pizzaria:dough_with_sauce", {
	description = "Pizza dough with Sauce",
	texture = {
		"jelys_pizzaria_pizza_dough.png^jelys_pizzaria_pizza_sauce.png",
		"jelys_pizzaria_pizza_dough.png"
	},
	drop = "jelys_pizzaris:dough",
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if itemstack:get_name() == "jelys_pizzaria:cheese" then
			minetest.set_node(pos, {name="jelys_pizzaria:raw_cheese_pizza"})
		end
	end,
})


jpizza.register_pizza("jelys_pizzaria:raw_cheese_pizza", {
	description = "Raw Cheese Pizza",
	texture = {
		"jelys_pizzaria_pizza_dough.png^jelys_pizzaria_pizza_sauce.png^jelys_pizzaria_pizza_cheese.png",
		"jelys_pizzaria_pizza_dough.png"
	},
	cook_time = {min=50, max = 100},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local name = itemstack:get_name()
		local fetch = find(name, "item", jpizza.toppings)
		if fetch then
			local stuff = jpizza.toppings[fetch]
			if not minetest.is_creative_enabled(player:get_player_name()) then
				itemstack:take_item()
			end
			minetest.set_node(pos, {name = "jelys_pizzaria:raw_pizza_"..stuff.name})
			return itemstack
		end
	end,
})


jpizza.register_pizza("jelys_pizzaria:cheese_pizza", {
	description = "Cheese Pizza",
	texture = {
		"jelys_pizzaria_cooked_dough.png^jelys_pizzaria_pizza_cooked_sauce.png^jelys_pizzaria_pizza_cooked_cheese.png",
		"jelys_pizzaria_cooked_dough.png"
	},
	done = true,
	on_punch = function(pos, oldnode, digger)
		--if not digger:is_player() then return end
		local itemstack = digger:get_wielded_item()
		--minetest.chat_send_all(itemstack:get_name())
		if itemstack:get_name() == "jelys_pizzaria:pizza_cutter" then
			jpizza.spawn_slices(pos, "jelys_pizzaria:cheese_pizza_slice")
			minetest.remove_node(pos)
		end
	end,
})


local function punch_pepperoni(pos, oldnode, digger)
	local num = 0
	local below = {x=pos.x, y=pos.y, z=pos.z}
	local inv = digger:get_inventory()
	if minetest.is_protected(pos, digger:get_player_name()) then return end
	local name = minetest.get_node(below).name
	while minetest.registered_nodes[name].groups ~= nil and minetest.registered_nodes[name].groups.pepperoni == 1 do
		minetest.remove_node(below)
		minetest.add_item(below, name)
		below.y = below.y - 1
		num = num + 1
		name = minetest.get_node(below).name
	end
	if num == 0 then return end
	return true
end

minetest.register_node("jelys_pizzaria:pepperoni_uncured", {
	description = "Uncured Pepperoni",
	inventory_image = "jelys_pizzaria_meat_pepperoni_uncured_inv.png",
	wield_image = "jelys_pizzaria_meat_pepperoni_uncured_inv.png",
	tiles = {
		"jelys_pizzaria_meat_pepperoni_uncured.png",
		"jelys_pizzaria_meat_pepperoni_uncured.png^[transformFX",
		"jelys_pizzaria_meat_pepperoni_uncured.png",
		"jelys_pizzaria_meat_pepperoni_uncured.png",
		"jelys_pizzaria_meat_pepperoni_uncured.png^[transformFX",
		"jelys_pizzaria_meat_pepperoni_uncured.png^[transformFX"
	},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {pepperoni = 1},
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(100, 200))
	end,
	on_timer = function(pos)
		minetest.swap_node(pos, {name="jelys_pizzaria:pepperoni_cured"})
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "node" then
			local pos = pointed_thing.above
			local upnode = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
			if minetest.is_protected(upnode, placer:get_player_name()) then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
			if minetest.registered_nodes[upnode.name].walkable == false then
				if placer:is_player() then minetest.chat_send_player(placer:get_player_name(), "Pepperoni has to be hung up to dry!") end
				return minetest.item_place(itemstack, placer, pointed_thing)
			else
				local name = minetest.get_node(pos).name
				if minetest.registered_nodes[name].buildable_to == true or name == "air" then
					minetest.set_node(pos, {name="jelys_pizzaria:pepperoni_uncured"})
					if not minetest.is_creative_enabled(placer:get_player_name()) then
						itemstack:take_item()
					end
				end
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing)
	end,
	on_punch = punch_pepperoni,
	node_box = {
		type = "fixed", 
		fixed = {
			{-0.125, -0.437, 0.125, 0.125, 0.125, -0.125},
			{-0.125, 0.5, 0, 0.125, -0.5, 0},
			{0, 0.5, -0.125, 0, -0.5, 0.125},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.437, 0.125, 0.125, 0.125, -0.125},
		}
	},
})

minetest.register_node("jelys_pizzaria:pepperoni_cured", {
	description = "Cured Pepperoni",
	inventory_image = "jelys_pizzaria_meat_pepperoni_cured_inv.png",
	wield_image = "jelys_pizzaria_meat_pepperoni_cured_inv.png",
	tiles = {
		"jelys_pizzaria_meat_pepperoni_cured.png",
		"jelys_pizzaria_meat_pepperoni_cured.png^[transformFX",
		"jelys_pizzaria_meat_pepperoni_cured.png",
		"jelys_pizzaria_meat_pepperoni_cured.png",
		"jelys_pizzaria_meat_pepperoni_cured.png^[transformFX",
		"jelys_pizzaria_meat_pepperoni_cured.png^[transformFX"
	},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {pepperoni = 1},
	on_place = function(itemstack, placer, pointed_thing)
		local pizzzzaa = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].groups
		minetest.chat_send_all(pointed_thing.type.." "..tostring(pizzzzaa.pizza==nil))
		if pointed_thing.type == "node" then
			local pos = pointed_thing.above
			local upnode = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
			if minetest.is_protected(upnode, placer:get_player_name()) then
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
			if minetest.registered_nodes[upnode.name].walkable == false then
				return minetest.item_place(itemstack, placer, pointed_thing)
			else
				local name = minetest.get_node(pos).name
				if minetest.registered_nodes[name].buildable_to == true or name == "air" then
					minetest.set_node(pos, {name="jelys_pizzaria:pepperoni_cured"})
					if not minetest.is_creative_enabled(placer:get_player_name()) then
						itemstack:take_item()
					end
				end
				return minetest.item_place(itemstack, placer, pointed_thing)
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing)
	end,
	on_punch = punch_pepperoni,
	node_box = {
		type = "fixed", 
		fixed = {
			{-0.125, -0.437, 0.125, 0.125, 0.125, -0.125},
			{-0.125, 0.5, 0, 0.125, -0.5, 0},
			{0, 0.5, -0.125, 0, -0.5, 0.125},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.437, 0.125, 0.125, 0.125, -0.125},
		}
	},
})

minetest.register_node("jelys_pizzaria:pizza_box", {
	description = "Pizza Box",
	drawtype = "nodebox",
	paramtype2 = "facedir",
	tiles = {
		"jelys_pizzaria_pizza_box.png",
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.501, -0.5, -0.501, 0.501, -0.375, 0.501}
		},
	},
})

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
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local name = itemstack:get_name()
		local def = minetest.registered_nodes[name]
		if def and def.raw and def.cook_time and def.cooked then
			local up = {x = pos.x, y = pos.y+1, z = pos.z}
			local itemdef = minetest.registered_nodes[name]
			local cook_time = itemdef.cook_time
			minetest.set_node(up, {name = name})
			minetest.get_node_timer(pos):start(math.random(cook_time.min, cook_time.max))
			if not minetest.is_creative_enabled(player:get_player_name()) then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
	on_timer = function(pos)
		local uppos = {x = pos.x, y = pos.y+1, z = pos.z}
		local up = minetest.get_node(uppos)
		local def = minetest.registered_nodes[up.name]
		if def.cooked then
			minetest.set_node(uppos, {name=def.cooked})
			minetest.get_node_timer(pos):start(70)
		end
		if def.done then
			minetest.set_node(uppos, {name="jelys_pizzaria:burnt_pizza"})
		end
	end,
})
