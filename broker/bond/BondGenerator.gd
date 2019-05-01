extends Node

onready var BondDisplay = get_parent()


func generate():
	randomize()
	# Generate pre-fixated bonds
	generate_safe_bond(["LCI", "LCA"], "Inflation")
	generate_safe_bond(["CRI", "CRA", "CDB"], "Inflation")
	generate_safe_bond(["TES"], "Selic")
	# Generate pos-fixated bonds
	generate_moderate_bonds(["S-1", "I-1"])
	generate_moderate_bonds(["S-2", "I-2"])
	generate_moderate_bonds(["S-3", "I-3"])


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
	
	if index_name == "Selic":
		index = Save.selic_last100
		
	if expiration[1] > 23: # Correct expiration
		expiration[1] -= 24
		expiration[0] += 1
	
	for i in range(expiration[0]): # Calculate index tendencies
		avg += index[99 - i] - index[98 - i]
	avg /= expiration[0]
	rentability = index[99] + avg + rand_range(-2.0, 2.0) + ((min_time[0] * 24) + min_time[1]) * 0.1
	Bond.setup(bond_name, rentability, "Pre-fixada", expiration, min_investment, min_time, taxes, OS.get_datetime())


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
	
	Bond.setup(bond_name, rentability, "Pos-fixada", expiration, min_investment, min_time, taxes, OS.get_datetime())


func generate_chanceful_bonds(possible_names):
	var Bond = BondDisplay.add_bond(BondDisplay.ChanceBonds)
	var bond_name = possible_names[randi() % possible_names.size()]
	var min_investment = 200 + randi() % 4801
	var min_time = [round(rand_range(.0, 1.6)), (1 + randi() % 4) * 4]
	var expiration = [min_time[0] + 2 + randi() % 12, min_time[1] + (randi() % 6) * 4]
	var taxes = [22.5, rand_range(0.0, 2.5), 0] # IR, Adm, Performance
	var rentability = rand_range(0.5, 6.0)
	
	if expiration[1] > 23: # Correct expiration
		expiration[1] -= 24
		expiration[0] += 1
	
	Bond.setup(bond_name, rentability, "Pos-fixada", expiration, min_investment, min_time, taxes, OS.get_datetime())

