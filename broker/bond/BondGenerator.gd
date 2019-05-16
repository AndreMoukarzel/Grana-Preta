extends Node

onready var BondDisplay = get_parent()


func generate():
	randomize()
	load_bonds()
	generate_missing_bonds()


func load_bonds():
	var safe_names = ["LCI", "LCA", "CRI", "CRA", "CDB", "TES"]
	var moderate_names = ["S", "I"]
	var chanceful_names = ["R", "X"]
	var to_remove_bonds = []
	
	for b in Save.available_bonds:
		var time_diff = Save.get_time_difference(add_time(OS.get_datetime(), b.min_time), b.expiration)
		
		if time_diff[0] < 0 or time_diff[1] < 0: # Bond expired, skip it and add it to remove list
			to_remove_bonds.append(b)
			continue
		
		if safe_names.has(b.name):
			var Bond = BondDisplay.add_bond(BondDisplay.SafeBonds)
			Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time)
		else:
			var split = b.name.split("-")[0]
			
			if moderate_names.has(split):
				var Bond = BondDisplay.add_bond(BondDisplay.ModerBonds)
				Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time)
			elif chanceful_names.has(split):
				var Bond = BondDisplay.add_bond(BondDisplay.ChanceBonds)
				Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time)
	
	for b in to_remove_bonds: # remove obsolete bonds
		var index = Save.available_bonds.find(b)
		Save.available_bonds.remove(index)


func generate_missing_bonds():
	var has_LC = false
	var has_CR = false
	var has_TRE = false
	
	# Check for missing safe bonds
	for bond in BondDisplay.SafeBonds.get_children():
		if ["LCI", "LCA"].has(bond.bond_name):
			has_LC = true
		elif ["CRI", "CRA", "CDB"].has(bond.bond_name):
			has_CR = true
		elif "TES" == bond.bond_name:
			has_TRE = true
	
	# Generate pre-fixated bonds
	if not has_LC:
		generate_safe_bond(["LCI", "LCA"], "Inflation")
	if not has_CR:
		generate_safe_bond(["CRI", "CRA", "CDB"], "Inflation")
	if not has_TRE:
		generate_safe_bond(["TES"], "Selic")
	
	var has_1 = false
	var has_2 = false
	var has_3 = false
	
	# Check for missing moderate bonds
	for bond in BondDisplay.ModerBonds.get_children():
		if ["S-1", "I-1"].has(bond.bond_name):
			has_1 = true
		elif ["S-2", "I-2"].has(bond.bond_name):
			has_2 = true
		elif ["S-3", "I-3"].has(bond.bond_name):
			has_3 = true
	
	# Generate moderate bonds
	if not has_1:
		generate_moderate_bonds(["S-1", "I-1"])
	if not has_2:
		generate_moderate_bonds(["S-2", "I-2"])
	if not has_3:
		generate_moderate_bonds(["S-3", "I-3"])
	
	var has_R = false
	var has_X = false
	
	# Check for missing chanceful bonds
	for bond in BondDisplay.ChanceBonds.get_children():
		if "R" == bond.bond_name:
			has_R = true
		elif "X" == bond.bond_name:
			has_X = true
	
	# Generate moderate bonds
	if not has_R:
		generate_chanceful_bonds(["R"])
	if not has_X:
		generate_chanceful_bonds(["X"])


func generate_safe_bond(possible_names, index_name):
	var Bond = BondDisplay.add_bond(BondDisplay.SafeBonds)
	var bond_name = possible_names[randi() % possible_names.size()]
	var min_investment = 200 + (randi() % 49) * 100
	var min_time = [round(rand_range(.0, .6)), (1 + randi() % 4) * 4]
	var expiration = [min_time[0] + 4 + randi() % 4, min_time[1] + (randi() % 6) * 4]
	var taxes = [22.5, rand_range(0.0, 2.5), 0] # IR, Adm, Performance
	var rentability
	var avg = 0
	var index = Save.inflation_last100
	
	if bond_name == "LCI" or bond_name == "LCA":
		taxes[0] = 0
	if index_name == "Selic":
		index = Save.selic_last100
	if expiration[1] > 23: # Correct expiration
		expiration[1] -= 24
		expiration[0] += 1
	
	for i in range(expiration[0]): # Calculate index tendencies
		avg += index[99 - i] - index[98 - i]
	avg /= expiration[0]
	rentability = index[99] + avg + rand_range(-2.0, 2.0) + ((min_time[0] * 24) + min_time[1]) * 0.06
	Bond.setup(bond_name, rentability, "Pre-fixada", add_time(OS.get_datetime(), expiration), min_investment, min_time, taxes, OS.get_datetime())
	Save.save_available_bond(Bond)


func generate_moderate_bonds(possible_names):
	var Bond = BondDisplay.add_bond(BondDisplay.ModerBonds)
	var bond_name = possible_names[randi() % possible_names.size()]
	var min_investment = 200 + (randi() % 49) * 100
	var min_time = [round(rand_range(0, 1.8)), (1 + randi() % 4) * 4]
	var expiration = [min_time[0] + 2 + randi() % 12, min_time[1] + (randi() % 6) * 4]
	var taxes = [22.5, rand_range(0.0, 2.5), 0] # IR, Adm, Performance
	var rentability = rand_range(0.8, 1.10) + ((min_time[0] * 24) + min_time[1]) * 0.005
	
	if expiration[1] > 23: # Correct expiration
		expiration[1] -= 24
		expiration[0] += 1
	
	Bond.setup(bond_name, rentability, "Pos-fixada", add_time(OS.get_datetime(), expiration), min_investment, min_time, taxes, OS.get_datetime())
	Save.save_available_bond(Bond)


func generate_chanceful_bonds(possible_names):
	var Bond = BondDisplay.add_bond(BondDisplay.ChanceBonds)
	var bond_name = possible_names[randi() % possible_names.size()]
	var min_investment = 200 + randi() % 4801
	var min_time = [1, 0]
	var expiration = [min_time[0] + 2 + randi() % 12, 0]
	var taxes = [22.5, rand_range(0.0, 2.5), 20 + (5 * (randi() % 2))] # IR, Adm, Performance
	var rentability
	var simulation = [0.0]
	var avg = 0.0
	
	for i in range(7):
		simulation.append(simulation[i] + ((randf() - randf()) * 20))
		avg += simulation[i]
	avg += simulation[7]
	avg /= 8
	rentability = avg
	
	
	Bond.setup(bond_name, rentability, "Prov", add_time(OS.get_datetime(), expiration), min_investment, min_time, taxes, OS.get_datetime())
	Save.save_available_bond(Bond)


# adds time_added's hours and days to base_time
func add_time(base_time, time_added):
	var final_time = base_time
	
	final_time.hour = base_time.hour + time_added[1]
	if final_time.hour > 23:
		final_time.hour -= 24
		final_time.day += 1
	final_time.day += time_added[0]
	
	if final_time.day > 31 and int(final_time.month) % 2 == 1:
		final_time.day -= 31
		final_time.month += 1
	elif final_time.day > 28 and int(final_time.month) % 2 == 0:
		if final_time.month == 2:
			if int(final_time.year) % 4 == 0: # leap year
				if final_time.day > 29:
					final_time.day -= 29
					final_time.month += 1
			else:
				final_time.day -= 28
				final_time.month += 1
		elif final_time.day > 30:
			final_time.day -= 30
			final_time.month += 1
	
	if final_time.month > 12:
		final_time.month -= 12
		final_time.year += 1
	
	return final_time
