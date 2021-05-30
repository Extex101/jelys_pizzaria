jpizza = {}
jpizza.toppings = {}

jpizza.path = minetest.get_modpath("jelys_pizzaria")
dofile(jpizza.path.."/functions.lua")

dofile(jpizza.path.."/mutation_backup.lua")

dofile(jpizza.path.."/nodes.lua")--nodes

jpizza.register_topping({
	item = "jelys_pizzaria:olives",
	name = "olives",
	topping_inv = "jelys_pizzaria_pizza_olives_inv.png",
	texture = "jelys_pizzaria_topping_olives.png",
})

jpizza.register_topping({
	item = "flowers:mushroom_brown",
	name = "mushrooms",
	topping_inv = "jelys_pizzaria_pizza_mushroom_inv.png",
	texture = "jelys_pizzaria_topping_mushrooms.png",
})

jpizza.register_topping({
	item = "jelys_pizzaria:pineapple",
	name = "pineapple",
	topping_inv = "jelys_pizzaria_pizza_pineapple_inv.png",
	texture = "jelys_pizzaria_topping_pineapple.png",
})

jpizza.make_pizzas()
