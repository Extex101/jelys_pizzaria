function jpizza.register_topping(def)
	local newdef = def
	--minetest.register_craft(newdef.craft)
	--minetest.register_craftitem(name, def)
	table.insert(jpizza.toppings, {name=def.name, texture=def.texture, item=def.item})
end

function jpizza.find(value, key, list)
	for _, i in  pairs(list) do
		if i[key] == value then
			return _
		end
	end
	return false
end

function jpizza.register_pizza(name, def)
	local newDef = def
	newDef.tiles = {
		def.texture[0],
		def.texture[1],
	}
	newDef.groups = {oddly_breakable_by_hand=3, crumbly=3, attached_node = 1}
	newDef.drawtype = "nodebox"
	newDef.paramtype = "light"
	newDef.sunlight_propagates = true
	newDef.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		}
	}
	newDef.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.1875, 0.5, -0.4375, 0.1875},
			{-0.1875, -0.5, -0.5, 0.1875, -0.4375, 0.5},
			{-0.3125, -0.5, -0.4375, 0.3125, -0.4375, 0.4375},
			{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
			{-0.375, -0.5, -0.375, 0.375, -0.4375, 0.375},
		}
	}
	newDef.sounds = {
		footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
	}
	minetest.register_node(name, newDef)
end

local raw_texture = "jelys_pizzaria_pizza_dough.png^"..
	"jelys_pizzaria_pizza_sauce.png^"..
	"jelys_pizzaria_pizza_cheese.png^"
				
local cooked_texture = "jelys_pizzaria_cooked_dough.png^"..
	"jelys_pizzaria_pizza_cooked_sauce.png^"..
	"jelys_pizzaria_pizza_cooked_cheese.png^"

function jpizza.make_pizzas()
	for i, base in pairs(jpizza.toppings) do
		minetest.log(dump(jpizza.toppings))
		jpizza.register_pizza("jelys_pizzaria:raw_pizza_"..base.name, {
			description = "Raw Pizza with "..base.name,
			texture = {
				raw_texture..base.texture,
				"jelys_pizzaria_pizza_dough.png"
			},
			on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				local name = itemstack:get_name()
				local fetch = jpizza.find(name, "item", jpizza.toppings)
				if fetch then
					local stuff = jpizza.toppings[fetch]
					if minetest.registered_nodes["jelys_pizzaria:raw_pizza_"..base.name.."_"..stuff.name] then
						minetest.set_node(pos, {name = "jelys_pizzaria:raw_pizza_"..base.name.."_"..stuff.name})
					end
				end
			end,
		})
		jpizza.register_pizza("jelys_pizzaria:pizza_"..base.name, {
			description = "Pizza with "..base.name,
			texture = {
				cooked_texture..base.texture,
				"jelys_pizzaria_cooked_dough.png"
			},
			on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				local name = itemstack:get_name()
				local fetch = jpizza.find(name, "item", jpizza.toppings)
				if fetch then
					local stuff = jpizza.toppings[fetch]
					minetest.set_node(pos, {name = "jelys_pizzaria:raw_pizza_"..base.name.."_"..stuff.name})
				end
			end,
		})
		for j = i, #jpizza.toppings, 1 do
			local side = jpizza.toppings[j]
			if side.name ~= base.name then
				local pizza_name = "jelys_pizzaria:raw_pizza_"..base.name.."_"..side.name
				local pizza_name2 = "jelys_pizzaria:raw_pizza_"..side.name.."_"..base.name
				minetest.register_alias(pizza_name2, pizza_name)
				jpizza.register_pizza(pizza_name, {
					description = "Raw Pizza with "..base.name.." and "..side.name,
					texture = {
						raw_texture..base.texture.."^("..side.texture.."^[transformR90)",
						"jelys_pizzaria_pizza_dough.png"
					},
				})
			end
		end
		
		for j = i, #jpizza.toppings, 1 do
			local side = jpizza.toppings[j]
			if side.name ~= base.name then
				local pizza_name = "jelys_pizzaria:pizza_"..base.name.."_"..side.name
				
				jpizza.register_pizza(pizza_name, {
					description = "Pizza with "..base.name.." and "..side.name,
					texture = {
						cooked_texture..base.texture.."^("..side.texture.."^[transformR90)",
						"jelys_pizzaria_cooked_dough.png"
					},
				})
			end
		end
	end
end


