extends Node

var completed_lessons = []
var completed_subjects = []
var completed_themes = []

func save():
	var themes_completed = []
	var subjects_completed = []
	var lessons_completed = []
	var questions_failed = []
	var questions_failed_time = []
	var money = 0
#	var total_units = []
#	# O vetor abaixo indica o tamanho do vetor de armas,
#	# sequencialmente, para cada unidade do vetor de   
#	# unidades total, e o vetor de armas total tem todas
#	# as armas sequencialmente, na ordem do total_units
#	var weapons_vector_size_per_unit = []
#	var total_weapons = []
#	var items_vector_size_per_unit = []
#	var total_items = []
#
#	var i = 0
#	for unit in units_vector:
#		if unit == null:
#			units_vector.remove(i)
#		else:
#			total_units.append(unit)
#		i += 1
#	for unit in barracks:
#		total_units.append(unit)
#
#	for unit in total_units:
#		for weapon in unit.wpn_vector:
#			total_weapons.append(weapon)
#		for item in unit.item_vector:
#			total_items.append(item)
#
#	var units = []
#	var weapons = []
#	var items = []
#
#	var storage_weapons = []
#	var storage_items = []
#
#	for unit in total_units:
#		# O numero de armas e items de cada unidade esta guardado ai mesmo
#		units.append( { id = unit.id, level = unit.level, wpn_num = unit.wpn_vector.size(), item_num = unit.item_vector.size() })
#	for weapon in total_weapons:
#		weapons.append( { id = weapon.id, durability = weapon.durability })
#	for item in total_items:
#		items.append( { id = item.id, amount = item.amount })
#
#	print("Storage weapons:")
#	print(storage_wpn)
#	for weapon in storage_wpn:
#		storage_weapons.append( { id = weapon.id, durability = weapon.durability })
#	print("Storage items:")
#	print(storage_itm)
#	for item in storage_itm:
#		storage_items.append( { id = item.id, amount = item.amount })
#
#	# Begin dictionary
#	var savedict = {
#		first_play = first_play,
#		stage = stage,
#		quesha = quesha,
#		victory = victory,
#
#		active_units_size = units_vector.size(),
#		barracks_units_size = barracks.size(),
#
#		units = units,
#		weapons = weapons,
#		items = items,
#
#		storage_weapons = storage_weapons,
#		storage_items = storage_items
#		}
#
#	return savedict



#func save_game():
#	var savegame = File.new()
#	var savedata = save()
#	savegame.open("user://savegame.save", File.WRITE)
#	savegame.store_line(savedata.to_json())
#	savegame.close()
#
#
#func load_game():
#	var savegame = File.new()
#	if !savegame.file_exists("user://savegame.save"):
#		return #Error!  We don't have a save to load
#
#	savegame.open("user://savegame.save", File.READ)
#	var savedata = {}
#	savedata.parse_json(savegame.get_as_text())
#	savegame.close()
#
#	first_play = savedata.first_play
#
#	if first_play == 1:
#		return #Just came back from a party wipe
#
#	stage = savedata.stage
#	quesha = savedata.quesha
#	victory = savedata.victory
#
#	var wpns_iter
#	var current_wpn = 0
#	var items_iter
#	var current_item = 0
#
#	for i in range(0, savedata.active_units_size):
#		wpns_iter = 0
#		items_iter = 0
#
#		var u = savedata.units[i]
#		units_vector.append(Unit.new(u.id, u.level, char_database))
#		while (wpns_iter < u.wpn_num):
#			units_vector[i].wpn_vector.append(weapon.new(savedata.weapons[current_wpn].id, wpn_database))
#			units_vector[i].wpn_vector[wpns_iter].durability = savedata.weapons[current_wpn].durability
#			wpns_iter += 1
#			current_wpn += 1
#		while (items_iter < u.item_num):
#			units_vector[i].item_vector.append(item.new(savedata.items[current_item].id, item_database))
#			units_vector[i].item_vector[items_iter].amount = savedata.items[current_item].amount
#			items_iter += 1
#			current_item += 1
#
#	for i in range(savedata.active_units_size, savedata.active_units_size + savedata.barracks_units_size):
#		print (savedata.active_units_size)
#		print (savedata.barracks_units_size)
#		wpns_iter = 0
#		items_iter = 0
#
#		var u = savedata.units[i]
#		barracks.append(Unit.new(u.id, u.level, char_database))
#		while (wpns_iter < u.wpn_num):
#			barracks[i - savedata.active_units_size].wpn_vector.append(weapon.new(savedata.weapons[current_wpn].id, wpn_database))
#			barracks[i - savedata.active_units_size].wpn_vector[wpns_iter].durability = savedata.weapons[current_wpn].durability
#			wpns_iter += 1
#			current_wpn += 1
#		while (items_iter < u.item_num):
#			barracks[i - savedata.active_units_size].item_vector.append(item.new(savedata.items[current_item].id, item_database))
#			barracks[i - savedata.active_units_size].item_vector[items_iter].amount = savedata.items[current_item].amount
#			items_iter += 1
#			current_item += 1
#
#	if (current_wpn != savedata.weapons.size() or current_item != savedata.items.size()):
#		#Error handler, did not load correctly
#		print("Error loading data!")
#
#	current_wpn = 0
#	current_item = 0
#
#	for wpn in savedata.storage_weapons:
#		storage_wpn.append(weapon.new(wpn.id, wpn_database))
#		storage_wpn[current_wpn].durability = wpn.durability
#		current_wpn += 1
#	for itm in savedata.storage_items:
#		storage_itm.append(item.new(itm.id, item_database))
#		storage_itm[current_item].amount = itm.amount
#		current_item += 1
#
#	if (current_wpn != savedata.storage_weapons.size() or current_item != savedata.storage_items.size()):
#		#Error handler, did not load correctly
#		print("Error loading data!")
#
#	print ("Finished loading data!")
#
#	scn = management_scn
#	get_node("Music").set_stream(load("res://resources/sounds/bgm/Management.ogg"))
#	get_node("Music").set_loop(true)
#	get_node("Music").play()
#
#	var level = scn.instance()
#	get_node("level").set_name("old")
#	level.set_name("level")
#
#	level.active_units = units_vector
#	level.barracks_units = barracks
#	level.storage_weapons = storage_wpn
#	level.storage_items = storage_itm
#	add_child(level)
#	get_node("old").queue_free()
#	# Continue population weapons and items, need more details on unit maybe
