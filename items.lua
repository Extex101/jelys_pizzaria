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

jpizza.register_pizza("jelys_pizzaria:burnt_pizza", {
	description = "Burnt Pizza",
	texture = {"jelys_pizzaria_burnt_pizza.png", "jelys_pizzaria_burnt_pizza.png"},
	on_punch = function(pos, oldnode, digger)
		--if not digger:is_player() then return end
		local itemstack = digger:get_wielded_item()
		--minetest.chat_send_all(itemstack:get_name())
		if itemstack:get_name() == "jelys_pizzaria:pizza_cutter" then
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
	description = "Burnt Pizza Slice",
	inventory_image = "jelys_pizzaria_burnt_pizza_slice.png",
	on_use = function(itemstack, player, pointed_thing)
		minetest.chat_send_player(player:get_player_name(), "Blecht")
		return minetest.do_item_eat(-2, "", itemstack, player, pointed_thing)
	end
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

minetest.register_tool("jelys_pizzaria:pizza_cutter", {
	description = "Pizza Cutter",
	inventory_image = "jelys_pizzaria_pizza_cutter.png",
	wield_image = "jelys_pizzaria_pizza_cutter.png^[transformFX",
	sound = {breaks = "default_tool_breaks"}
})

if jpizza.has_depends.hunger_ng then
	hunger_ng.add_hunger_data("jelys_pizzaria:burnt_pizza_slice", {satiates = -3, heals = -2})
	hunger_ng.add_hunger_data("jelys_pizzaria:cheese_pizza_slice", {satiates = 1})
end
if jpizza.has_depends.hbhunger then
	hbhunger.register_food("jelys_pizzaria:burnt_pizza_slice", 0, "", 2)
	hbhunger.register_food("jelys_pizzaria:cheese_pizza_slice", 1)
end
minetest.register_craftitem("jelys_pizzaria:cheese_pizza_slice", {
	description = "Slice of Cheese Pizza",
	inventory_image = "jelys_pizzaria_pizza_slice.png",
	on_use = function(itemstack, player, pointed_thing)
		minetest.chat_send_player(player:get_player_name(), "Blecht")
		local number = math.floor(math.random(1,2)+0.5)
		return minetest.do_item_eat(-number, false, itemstack, user, pointed_thing)
	end,
})

minetest.register_craft({
	output = "jelys_pizzaria:rolling_pin",
	recipe = {
		{"", "", "group:stick"},
		{"", "group:wood",""},
		{"group:stick", "",""},
	}
})