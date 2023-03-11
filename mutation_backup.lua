local mutagen = "jelys_pizzaria:mese_mutator"
minetest.register_craftitem("jelys_pizzaria:mese_mutator", {
	description = "Mese Mutation Crystals",
	inventory_image = "jelys_pizzaria_mese_mutation_crystal.png",
})

local f = "default:mese_crystal_fragment"
local m = "default:mese_crystal"
minetest.register_craft({
	output = "jelys_pizzaria:mese_mutator 4",
	recipe = {
		{"", f, ""},
		{f, m, f},
	}
})

local tomato = "jelys_pizzaria:tomato"
if farming and farming.mod == "redo" then
	tomato = "farming:tomato"
else
	minetest.register_craftitem("jelys_pizzaria:tomato", {
		description = "Tomato",
		inventory_image = "jelys_pizzaria_tomato.png",
	})
	minetest.register_craft({
		type = "shapeless",
		output = "jelys_pizzaria:tomato",
		recipe = {"default:apple", mutagen},
	})
end

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:sauce",
	recipe = {tomato, "vessels:glass_bottle"},
})
minetest.register_craft({
	output = "jelys_pizzaria:pepperoni_uncured",
	recipe = {
		{"jelys_pizzaria:meat"},
		{"jelys_pizzaria:meat"},
		{"jelys_pizzaria:meat"}
	},
})
minetest.register_craft({
	output = "jelys_pizzaria:sausage",
	recipe = {
		{"","",""},
		{"jelys_pizzaria:meat","jelys_pizzaria:meat","jelys_pizzaria:meat"},
		{"","",""}
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:olives",
	recipe = {"default:blueberries", mutagen},
})

minetest.register_craftitem("jelys_pizzaria:cheese", {
	description = "Cheese",
	inventory_image = "jelys_pizzaria_cheese.png",
})
minetest.register_craft({
	type = "shapeless",
	output = "jelys_pizzaria:cheese 2",
	recipe = {"default:gold_ingot", mutagen},
})

minetest.register_craftitem("jelys_pizzaria:olives", {
	description = "Olives",
	inventory_image = "jelys_pizzaria_olives.png",
})

minetest.register_craftitem("jelys_pizzaria:olives", {
	description = "Olives",
	inventory_image = "jelys_pizzaria_olives.png",
})

minetest.register_craftitem("jelys_pizzaria:sausage_raw", {
	description = "Raw Sausage",
	inventory_image = "jelys_pizzaria_sausage_raw.png",
})
minetest.register_craft({
	type = "cooking",
	output = "jelys_pizzaria:sausage",
	recipe = "jelys_pizzaria:sausage_raw",
	cooktime = 20,
})
minetest.register_craftitem("jelys_pizzaria:sausage", {
	description = "Sausage",
	inventory_image = "jelys_pizzaria_sausage.png",
})

minetest.register_craftitem("jelys_pizzaria:sauce", {
	description = "Tomato Sauce",
	inventory_image = "jelys_pizzaria_sauce.png",
})

local meat = "jelys_pizzaria:meat"
if jpizza.has_depends.mobs then
	meat = "mobs:meat_raw"
elseif jpizza.has_depends.creatures then
	meat = "creatures:flesh"
else
	minetest.register_craft({
		type = "shapeless",
		output = "jelys_pizzaria:meat 9",
		recipe = {mutagen, mutagen, mutagen, mutagen, "bones:bones", mutagen, mutagen, mutagen, mutagen},
	})
	minetest.register_craftitem("jelys_pizzaria:meat", {
		description = "Meat",
		inventory_image = "jelys_pizzaria_meat.png",
	})

end

minetest.register_craft({
	output = "jelys_pizzaria:pepperoni_uncured",
	recipe = {
		{meat},
		{meat},
		{meat}
	},
})
minetest.register_craft({
	output = "jelys_pizzaria:sausage_raw",
	recipe = {
		{meat,meat,meat},
	},
})

local pineapple = "jelys_pizzaria:pineapple"
if jpizza.has_depends.pineapple then
	minetest.register_alias("pineapple:pineapple", "jelys_pizzaria:pineapple")
	pineapple = "pineapple:pineapple"
end
if farming and farming.mod == "redo" then
	minetest.register_alias("farming:pineapple_ring", "jelys_pizzaria:pineapple")
	pineapple = "farming:pineapple_ring"
end
if not jpizza.has_depends.pineapple and (not farming or farming and not farming.mod) then
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
	minetest.register_craft({
		type = "shapeless",
		output = "jelys_pizzaria:pineapple",
		recipe = {"default:pine_needles","default:pine_needles","default:apple", mutagen, mutagen},
	})
end
jpizza.register_topping({
	item = pineapple,
	name = "pineapple",
	topping_inv = {
		"jelys_pizzaria_topping_pineapple_inv_1.png",
		"jelys_pizzaria_topping_pineapple_inv_2.png",
	},
	texture = "jelys_pizzaria_topping_pineapple.png",
	cooked_texture = "jelys_pizzaria_topping_pineapple_cooked.png",
	eat = 3,
})
