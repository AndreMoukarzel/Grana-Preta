extends Node

onready var BondDisplay = get_parent()


func generate():
	randomize()
	# Generate pre-fixated bonds
	generate_safe_bond(["LCI", "LCA"], "Inflation")
	generate_safe_bond(["CRI", "CRA", "CDB"], "Inflation")
	generate_safe_bond(["TES"], "Selic")


func generate_safe_bond(possible_names, index_name):
	var Bond = BondDisplay.add_bond(BondDisplay.SafeBonds)
	var bond_name = possible_names[randi() % possible_names.size()]
	var min_investment = 200 + randi() % 4801
	var min_time = [round(rand_range(.0, .6)), randi() % 16]
	var expiration = [min_time[0] + 4 + randi() % 4, min_time[1] + randi() % 20]
	var taxes = [22.5, rand_range(0.0, 2.5), 0] # IR, Adm, Performance
	var rentability
	var avg = 0
	var index = Save.inflation_last100
	
	if index_name == "Selic":
		index = Save.selic_last100
	
	for i in range(expiration[0]):
		avg += index[99 - i] - index[98 - i]
	avg /= expiration[0]
	rentability = index[99] + avg + rand_range(-2.0, 2.0)
	Bond.setup(bond_name, rentability, "Pre-fixada", expiration, min_investment, min_time, taxes)
