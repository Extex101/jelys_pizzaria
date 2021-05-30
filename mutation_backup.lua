local mutagen = "jelys_pizzaria:mese_mutator"
minetest.register_craftitem("jelys_pizzaria:mese_mutator", {
	description = "Mese Mutation Crystal",
	inventory_image = "jelys_pizzaria_mese_mutation_crystal.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:tomato",
	recipe = {"default:apple", mutagen},
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:sauce",
	recipe = {"jelys_pizzaria:tomato", "vessels:glass_bottle"},
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:olives",
	recipe = {"default:blueberries", mutagen},
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:pineapple",
	recipe = {"default:pine_needles","default:pine_needles","default:apple", mutagen, mutagen},
})
minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:meat 9",
	recipe = {mutagen, mutagen, mutagen, mutagen, "bones:bones", mutagen, mutagen, mutagen, mutagen},
})

minetest.register_craftitem("jelys_pizzaria:tomato", {
	description = "Tomato",
	inventory_image = "jelys_pizzaria_tomato.png",
})

minetest.register_craftitem("jelys_pizzaria:cheese", {
	description = "Cheese",
	inventory_image = "jelys_pizzaria_cheese.png",
})
minetest.register_craftitem("jelys_pizzaria:olives", {
	description = "Olives",
	inventory_image = "jelys_pizzaria_olives.png",
})

minetest.register_craftitem("jelys_pizzaria:olives", {
	description = "Olives",
	inventory_image = "jelys_pizzaria_olives.png",
})

minetest.register_craftitem("jelys_pizzaria:sauce", {
	description = "Tomato Sauce",
	inventory_image = "jelys_pizzaria_sauce.png",
})

minetest.register_craftitem("jelys_pizzaria:meat", {
	description = "Meat",
	inventory_image = "jelys_pizzaria_meat.png",
})

minetest.register_craftitem("jelys_pizzaria:pepperoni_uncured", {
	description = "Uncured Pepperoni",
	inventory_image = "jelys_pizzaria_meat_pepperoni_uncured.png",
})

minetest.register_craftitem("jelys_pizzaria:pepperoni_cured", {
	description = "Cured Pepperoni",
	inventory_image = "jelys_pizzaria_meat_pepperoni_cured.png",
})

minetest.register_node("jelys_pizzaria:pineapple", {
	description = "Pineapple",
	drawtype = "plantlike",
	tiles = {"jelys_pizzaria_pineapple.png"},
	inventory_image = "jelys_pizzaria_pineapple_inv.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),
})


