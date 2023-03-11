function jpizza.register_topping(def)
	local newdef = def
	table.insert(jpizza.toppings, {name=def.name, texture=def.texture, item=def.item, cooked_texture=def.cooked_texture, topping_inv=def.topping_inv, eat=def.eat})
end

local function find(value, key, list)
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
		def.texture[1],
		def.texture[2]
	}
	newDef.groups = {oddly_breakable_by_hand=3, crumbly=3, attached_node = 1}
	if def.toppings == 1 then
		newDef.groups.pizza = 1
	end
	newDef.use_texture_alpha = "clip"
	newDef.drawtype = "nodebox"
	newDef.paramtype = "light"
	newDef.sunlight_propagates = true
	newDef.selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4, 0.5},
		}
	}
	newDef.stack_max = 1
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
	if newDef.sounds == nil then
		newDef.sounds = {
			footstep = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
			dug = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
			dig = {name = "jelys_pizzaria_pizza_walk", gain = 0.3},
		}
	end
	minetest.register_node(name, newDef)
end

local raw_texture = "jelys_pizzaria_pizza_dough.png^"..
	"jelys_pizzaria_pizza_sauce.png^"..
	"jelys_pizzaria_pizza_cheese.png^"
				
local cooked_texture = "jelys_pizzaria_cooked_dough.png^"..
	"jelys_pizzaria_pizza_cooked_sauce.png^"..
	"jelys_pizzaria_pizza_cooked_cheese.png^"
function jpizza.spawn_slices(pos, item)
	for i = 0, 5, 1 do
		local x = pos.x+math.sin(i*60)/3
		local z = pos.z+math.cos(i*60)/3
		minetest.add_item({x=x, y=pos.y, z=z}, item)
	end
end
function jpizza.make_pizzas()
	for i, base in pairs(jpizza.toppings) do
		jpizza.register_pizza("jelys_pizzaria:raw_pizza_"..base.name, {
			description = "Raw Pizza with "..base.name,
			texture = {
				raw_texture..base.texture,
				"jelys_pizzaria_pizza_dough.png"
			},
			cooked = "jelys_pizzaria:pizza_"..base.name,
			cook_time = {min=100, max=200},
			raw = 1,
			toppings = 1,
			on_rightclick = function(pos, node, player, itemstack, pointed_thing)
				local name = itemstack:get_name()
				
				local fetch = find(name, "item", jpizza.toppings)
				if fetch then
					local stuff = jpizza.toppings[fetch]
					if minetest.registered_nodes["jelys_pizzaria:raw_pizza_"..base.name.."_"..stuff.name] then
						if not minetest.is_creative_enabled(player:get_player_name()) then
							itemstack:take_item()
						end
						minetest.set_node(pos, {name = "jelys_pizzaria:raw_pizza_"..base.name.."_"..stuff.name})
						return itemstack
					end
				end
			end,
		})
		jpizza.register_pizza("jelys_pizzaria:pizza_"..base.name, {
			description = "Pizza with "..base.name,
			texture = {
				cooked_texture..base.cooked_texture,
				"jelys_pizzaria_cooked_dough.png"
			},
			
			on_punch = function(pos, oldnode, digger)
				local down = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
				local itemstack = digger:get_wielded_item()
				local downdef = minetest.registered_nodes[down.name]
				if itemstack:get_name() == "jelys_pizzaria:pizza_cutter" and downdef.groups.pizza_oven == nil then
					jpizza.spawn_slices(pos, "jelys_pizzaria:pizza_"..base.name.."_slice")
					local wear = itemstack:get_wear()
					itemstack:set_wear(wear+(65535/40))
					digger:set_wielded_item(itemstack)
					minetest.remove_node(pos)
				end
			end,
			done = true
		})
		minetest.register_craftitem("jelys_pizzaria:pizza_"..base.name.."_slice", {
			description = "Slice of "..base.name.." Pizza",
			inventory_image = "jelys_pizzaria_pizza_slice.png^"..base.topping_inv[2],
			stack_max = 6,
			on_use = minetest.item_eat(1+base.eat)
		})
		if jpizza.has_depends.hunger_ng then
			hunger_ng.add_hunger_data("jelys_pizzaria:pizza_"..base.name.."_slice", {satiates = 1+base.eat})
		end
		if jpizza.has_depends.hbhunger then
			hbhunger.register_food("jelys_pizzaria:pizza_"..base.name.."_slice", 1+base.eat)
		end
		for j = i, #jpizza.toppings, 1 do
			local side = jpizza.toppings[j]
			if side.name ~= base.name then
				local pizza_name = "jelys_pizzaria:raw_pizza_"..base.name.."_"..side.name
				local pizza_name2 = "jelys_pizzaria:raw_pizza_"..side.name.."_"..base.name
				minetest.register_alias(pizza_name2, pizza_name)
				jpizza.register_pizza(pizza_name, {
					description = "Raw Pizza with "..base.name.." and "..side.name,
					cook_time = {min=200, max=250},
					texture = {
						raw_texture..base.texture.."^("..side.texture.."^[transformR90)",
						"jelys_pizzaria_pizza_dough.png"
					},
					raw = 1,
					cooked = "jelys_pizzaria:pizza_"..base.name.."_"..side.name,
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
						cooked_texture..base.cooked_texture.."^("..side.cooked_texture.."^[transformR90)",
						"jelys_pizzaria_cooked_dough.png"
					},
					on_punch = function(pos, oldnode, digger)
						local down = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
						local itemstack = digger:get_wielded_item()
						local downdef = minetest.registered_nodes[down.name]
						if itemstack:get_name() == "jelys_pizzaria:pizza_cutter" and downdef.groups.pizza_oven == nil then
							jpizza.spawn_slices(pos, pizza_name.."_slice")
							local wear = itemstack:get_wear()
							itemstack:set_wear(wear+(65535/40))
							digger:set_wielded_item(itemstack)
							minetest.remove_node(pos)
						end
					end,
					done=true
				})
				local num1 = math.floor(math.random(1,2)+0.5)
				local num2 = 1
				if num1 == 1 then
					num2 = 2
				end
				minetest.register_craftitem(pizza_name.."_slice", {
					description = "Slice of "..base.name.." and "..side.name.." Pizza",
					inventory_image = "jelys_pizzaria_pizza_slice.png^"..base.topping_inv[num1].."^"..side.topping_inv[num2],
					stack_max = 6,
					on_use = minetest.item_eat(1+base.eat+side.eat)
				})
				minetest.register_alias(pizza_name.."_slice", "jelys_pizzaria:pizza_"..side.name.."_"..base.name)--yeah this shouldn't be a problem except for modders
				if jpizza.has_depends.hunger_ng == true then
					hunger_ng.add_hunger_data(pizza_name.."_slice", {satiates = 1+base.eat+side.eat})
				end
				if jpizza.has_depends.hbhunger == true then
					hbhunger.register_food(pizza_name.."_slice", 1+base.eat+side.eat)
				end
			end
		end
	end
end