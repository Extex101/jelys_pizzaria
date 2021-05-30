minetest.register_node("jelys_pizzaria:dough_rolled", {
	description = "Rolled Pizza dough",
	tiles = {
		"jelys_pizzaria_pizza_dough.png",
	},
	groups = {attached_node = 1},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	drop = "jelys_pizzaria:dough",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.1875, 0.5, -0.4375, 0.1875},
			{-0.1875, -0.5, -0.5, 0.1875, -0.4375, 0.5},
			{-0.3125, -0.5, -0.4375, 0.3125, -0.4375, 0.4375},
			{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
		}
	},
	sounds = {
		footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
	},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if itemstack:get_name() == "jelys_pizzaria:sauce" then
			minetest.set_node(pos, {name="jelys_pizzaria:sauced_dough"})
		end
	end,
})

minetest.register_node("jelys_pizzaria:sauced_dough", {
	description = "Pizza dough with Sauce",
	tiles = {
		"jelys_pizzaria_pizza_dough.png^jelys_pizzaria_pizza_sauce.png",
	},
	groups = {oddly_breakable_by_hand=3, crumbly=3, attached_node = 1},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	drop = "jelys_pizzaria:dough",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.1875, 0.5, -0.4375, 0.1875},
			{-0.1875, -0.5, -0.5, 0.1875, -0.4375, 0.5},
			{-0.3125, -0.5, -0.4375, 0.3125, -0.4375, 0.4375},
			{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
		}
	},
	sounds = {
		footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
	},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		if itemstack:get_name() == "jelys_pizzaria:cheese" then
			minetest.set_node(pos, {name="jelys_pizzaria:cheesed_dough"})
		end
	end,
})

minetest.register_node("jelys_pizzaria:cheesed_dough", {
	description = "Pizza dough with Sauce",
	tiles = {
		"jelys_pizzaria_pizza_dough.png^jelys_pizzaria_pizza_sauce.png^jelys_pizzaria_pizza_cheese.png",
	},
	groups = {oddly_breakable_by_hand=3, crumbly=3, attached_node = 1},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	drop = "jelys_pizzaria:dough",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.1875, 0.5, -0.4375, 0.1875},
			{-0.1875, -0.5, -0.5, 0.1875, -0.4375, 0.5},
			{-0.3125, -0.5, -0.4375, 0.3125, -0.4375, 0.4375},
			{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
		}
	},
	sounds = {
		footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
	},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local name = itemstack:get_name()
		local fetch = jpizza.find(name, "item", jpizza.toppings)
		if fetch then
			local stuff = jpizza.toppings[fetch]
			minetest.set_node(pos, {name = "jelys_pizzaria:raw_pizza_"..stuff.name})
		end
	end,
})

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
		else
			--minetest.
		end
	end,
	sounds = {
		footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},--https://freesound.org/people/JanKoehl/sounds/85604/
		dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
	},
})



minetest.register_node("jelys_pizzaria:rolling_pin", {
	description = "Rolling Pin",
	--inventory_image = "jelys_pizzaria_rolling_pin.png",
	tiles={"default_wood.png"},
	drawtype = "nodebox",
	groups={oddly_breakable_by_hand=3},
	visual_size = 2,
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			rolling_pin = {times={[2]=3.00, [3]=5.60}, uses=500, maxlevel=1},
		},
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.125, -0.5, 0.125, 0.125, 0.5},
			{-0.0625, -0.0625, -0.6875, 0.0625, 0.0625, 0.6875},
		}
	},
	sound = {breaks = "default_tool_breaks"},
	on_place = function() return end,
	node_placement_prediction = "",
})
