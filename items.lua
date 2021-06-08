minetest.register_node("jelys_pizzaria:rolling_pin", {
	description = "Rolling Pin",
	--inventory_image = "jelys_pizzaria_rolling_pin.png",
	tiles={"default_wood.png"},
	drawtype = "nodebox",
	groups={oddly_breakable_by_hand=3},--just in case somebody places it
	visual_size = 2,
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			rolling_pin = {times={[2]=3.00, [3]=5.60}, uses=500, maxlevel=1},
		},
		damage_groups = {}
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
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("jelys_pizzaria:burnt_pizza_slice", {
	description = "Burnt Pizza Slice",
	inventory_image = "jelys_pizzaria_burnt_pizza_slice.png",
})

minetest.register_craftitem("jelys_pizzaria:cheese_pizza_slice", {
	description = "Burnt Pizza Slice",
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