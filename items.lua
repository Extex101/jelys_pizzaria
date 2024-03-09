
-- Burnt Pizza
jpizza.register_pizza("jelys_pizzaria:burnt_pizza", {
	description = "Burnt Pizza",
	texture = {"jelys_pizzaria_burnt_pizza.png", "jelys_pizzaria_burnt_pizza.png"},
	on_punch = function(pos, oldnode, digger)
		local down = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
		local itemstack = digger:get_wielded_item()
		local downdef = minetest.registered_nodes[down.name]
		if itemstack:get_name() == "jelys_pizzaria:pizza_cutter" and downdef.groups.pizza_oven == nil then
			jpizza.spawn_slices(pos, "jelys_pizzaria:burnt_pizza_slice")
			minetest.remove_node(pos)
		end
	end,
	on_destruct = function(pos)
		local down = {x=pos.x, y=pos.y-1,z=pos.z}
		if minetest.get_node(down).name == "jelys_pizzaria:pizza_oven" then
			minetest.get_meta(down):set_string("infotext", "Empty Pizza Oven")
		end
	end,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("jelys_pizzaria:burnt_pizza_slice", {
	description = "Burned Pizza Slice",
	inventory_image = "jelys_pizzaria_burnt_pizza_slice.png",
	stack_max = 12,
	on_use = function(itemstack, player, pointed_thing)
		minetest.chat_send_player(player:get_player_name(), "Blecht")
		return minetest.do_item_eat(-2, "", itemstack, player, pointed_thing)
	end
})

--Tools

minetest.register_node("jelys_pizzaria:rolling_pin", {
	description = "Rolling Pin",
	inventory_image = "jelys_pizzaria_rolling_pin_inv.png",
	tiles={"default_wood.png"},
	drawtype = "nodebox",
	groups={oddly_breakable_by_hand=3},--just in case somebody places it
	visual_size = 2,
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			rolling_pin = {times={[2]=3.00, [3]=5.60}, uses=1, maxlevel=1},
		},
		damage_groups = {}
	},
	stack_max=1,
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

minetest.register_tool("jelys_pizzaria:pizza_cutter", {
	description = "Pizza Cutter",
	inventory_image = "jelys_pizzaria_pizza_cutter.png",
	wield_image = "jelys_pizzaria_pizza_cutter.png^[transformFX",
	sound = {breaks = "default_tool_breaks"}
})

--Hunger support

if jpizza.has_depends.hunger_ng then
	hunger_ng.add_hunger_data("jelys_pizzaria:burnt_pizza_slice", {satiates = -3, heals = -2})
	hunger_ng.add_hunger_data("jelys_pizzaria:cheese_pizza_slice", {satiates = 1})
end
if jpizza.has_depends.hbhunger and minetest.global_exists("hbhunger") then
	hbhunger.register_food("jelys_pizzaria:burnt_pizza_slice", 0, "", 2)
	hbhunger.register_food("jelys_pizzaria:cheese_pizza_slice", 1)
end


--Craft recipes
minetest.register_craft({
	output = "jelys_pizzaria:rolling_pin",
	recipe = {
		{"", "", "group:stick"},
		{"", "group:wood",""},
		{"group:stick", "",""},
	}
})

minetest.register_craft({
	output = "jelys_pizzaria:pizza_cutter",
	recipe = {
		{"","default:steel_ingot", "default:steel_ingot"},
		{"","group:stick", "default:steel_ingot"},
		{"group:stick", "", ""}
	},
})

minetest.register_craft({
	output = "jelys_pizzaria:pizza_box_closed",
	recipe = {
		{"dye:green", "dye:white","dye:red"},
		{"default:paper", "default:paper","default:paper"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:dough 2",
	recipe = {"farming:flour", "bucket:bucket_water"},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:dough 2",
	recipe = {"farming:flour", "bucket:bucket_river_water"},
	replacements = {
		{"bucket:bucket_river_water", "bucket:bucket_empty"}
	}
})

--Easter Eggs
minetest.register_craftitem("jelys_pizzaria:hainac_slice", {
	description = "Slice of \"Heart attack in a circle\" pizza",
	inventory_image = "jelys_pizzaria_hainac_slice.png",
	groups = {food = 1},
	on_use = function(itemstack, player, pointed_thing)
		minetest.after(1, function(itemstack, player, pointed_thing)
			if player:get_hp() > 0 then
				minetest.do_item_eat(20, "", itemstack, player, pointed_thing)
			end
		end, itemstack, player, pointed_thing)
		return minetest.do_item_eat(-10, "", itemstack, player, pointed_thing)
	end
})


jpizza.register_pizza("jelys_pizzaria:hainac_pizza", {
	description = "Whole \"Heart attack in a circle\" Pizza",
	texture = {"jelys_pizzaria_pizza_hainac.png", "jelys_pizzaria_cooked_dough.png"},
	done = 1,
	on_punch = function(pos, oldnode, digger)
		local down = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
		local itemstack = digger:get_wielded_item()
		local downdef = minetest.registered_nodes[down.name]
		if itemstack:get_name() == "jelys_pizzaria:pizza_cutter" and downdef.groups.pizza_oven == nil then
			jpizza.spawn_slices(pos, "jelys_pizzaria:hainac_slice")
			minetest.remove_node(pos)
		end
	end,
})
local h = "jelys_pizzaria:hainac_slice"
minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:hainac_pizza",
	recipe = {h,h,h,h,h,h},
})

if jpizza.has_depends.dungeon_loot then
	
	--Cheese
	dungeon_loot.register({
		name = "jelys_pizzaria:cheese",
		chance = 0.1,
		count = {1, 2},
		y = {-32768, 0},
	})
	dungeon_loot.register({
		name = "jelys_pizzaria:cheese",
		chance = 0.2,
		count = {3, 7},
		y = {-32768, -500},
	})
	dungeon_loot.register({
		name = "jelys_pizzaria:cheese",
		chance = 0.2,
		count = {3, 7},
		y = {-431, -431},
	})
	
	
	--Heart attack in a circle
	
	dungeon_loot.register({
		name = "jelys_pizzaria:hainac_slice",
		chance = 0.01,
		count = {1,2},
		y = {-608, -400},
	})
	dungeon_loot.register({
		name = "jelys_pizzaria:hainac_slice",
		chance = 0.06,
		count = {1,2},
		y = {-850, -800},
	})
	dungeon_loot.register({
		name = "jelys_pizzaria:hainac_slice",
		chance = 0.85,
		count = {8, 10},
		y = {-431, -431},
	})
	
	
	--Pizza Oven
	
	dungeon_loot.register({
		name = "jelys_pizzaria:pizza_oven",
		chance = 0.006,
		y = {-32768, -500},
	})
end
