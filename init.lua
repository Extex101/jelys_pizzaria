jpizza = {}
jpizza.toppings = {}

jpizza.op_depends = {"hunger_ng", "hbhunger"}
jpizza.has_depends = {}
for _, i in pairs(jpizza.op_depends) do
	if minetest.get_modpath(i) then
		jpizza.has_depends[i] = true
	else
		jpizza.has_depends[i] = false
	end
end

jpizza.path = minetest.get_modpath("jelys_pizzaria")
dofile(jpizza.path.."/functions.lua")

minetest.register_tool("jelys_pizzaria:pizza_cutter", {
	description = "Pizza Cutter",
	inventory_image = "jelys_pizzaria_pizza_cutter.png",
	wield_image = "jelys_pizzaria_pizza_cutter.png^[transformFX"
})

dofile(jpizza.path.."/mutation_backup.lua")

dofile(jpizza.path.."/nodes.lua")--nodes

dofile(jpizza.path.."/items.lua")

jpizza.register_topping({
	item = "jelys_pizzaria:olives",
	name = "olives",
	topping_inv = {
		"jelys_pizzaria_topping_olives_inv_1.png",
		"jelys_pizzaria_topping_olives_inv_2.png"
	},
	texture = "jelys_pizzaria_topping_olives.png",
	cooked_texture = "jelys_pizzaria_topping_olives_cooked.png",
	eat = 2,
})

jpizza.register_topping({
	item = "jelys_pizzaria:pepperoni_cured",
	name = "pepperoni",
	topping_inv = {
		"jelys_pizzaria_topping_pepperoni_inv_1.png", 
		"jelys_pizzaria_topping_pepperoni_inv_2.png"
	},
	texture = "jelys_pizzaria_topping_pepperoni.png",
	cooked_texture = "jelys_pizzaria_topping_pepperoni_cooked.png",
	eat = 4,
})

jpizza.register_topping({
	item = "jelys_pizzaria:meatball",
	name = "meatballs",
	topping_inv = {
		"jelys_pizzaria_topping_meatball_inv_1.png", 
		"jelys_pizzaria_topping_meatball_inv_2.png"
	},
	texture = "jelys_pizzaria_topping_meatball.png",
	cooked_texture = "jelys_pizzaria_topping_meatball_cooked.png",
	eat = 4,
})

jpizza.register_topping({
	item = "flowers:mushroom_brown",
	name = "mushrooms",
	topping_inv = {
		"jelys_pizzaria_topping_mushroom_inv_1.png",
		"jelys_pizzaria_topping_mushroom_inv_2.png",
	},
	texture = "jelys_pizzaria_topping_mushrooms.png",
	cooked_texture = "jelys_pizzaria_topping_mushrooms_cooked.png",
	eat = 1,
})

jpizza.register_topping({
	item = "jelys_pizzaria:pineapple",
	name = "pineapple",
	topping_inv = {
		"jelys_pizzaria_topping_pineapple_inv_1.png",
		"jelys_pizzaria_topping_pineapple_inv_2.png",
	},
	texture = "jelys_pizzaria_topping_pineapple.png",
	cooked_texture = "jelys_pizzaria_topping_pineapple_cooked.png",
	eat = 3,
})

jpizza.make_pizzas()
