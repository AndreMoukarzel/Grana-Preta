extends Control

const BOUGHT_BOND_SCN = preload("res://broker/bond/BoughtBond.tscn")

var total_height = 0


func clear_bonds():
	total_height = 0
	for b in $Sorter/Bonds.get_children():
		b.queue_free()


func sell_expired_bonds():
	for b in $Sorter/Bonds.get_children():
		var time_diff = Save.get_time_difference(OS.get_datetime(), b.expiration)
		
		if time_diff[0] <= 0 and time_diff[0] <= 0:
			b._on_trade_confirmed(b.ammount)
			b.queue_free()


func update_bought_bonds():
	clear_bonds()
	for b in Save.bought_bonds:
		var iteration_number = get_iteration_number(b)
		var Bond = add_bond($Sorter/Bonds)
		
		Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time, b.index_value)
		Bond.setup_owned(b.ammount, b.bought_time, b.id)
		if iteration_number > 0:
			print("iterating, ", iteration_number, " times")
			Bond.iterate(iteration_number)
			Bond.queue_free()
		else:
			total_height += 100
	sell_expired_bonds()


func add_bond(parent):
	var Bond = BOUGHT_BOND_SCN.instance()
	Bond.rect_position.y =  total_height
	Bond.set_name(str(parent.get_child_count()))
	Bond.connect("opened", self, "bond_opened")
	Bond.connect("closed", self, "bond_closed")
	parent.add_child(Bond)
	
	return Bond


func get_iteration_number(bond_save):
	var t1 = bond_save.bought_time
	var t2 = Save.get_min_datetime(bond_save.expiration, OS.get_datetime())
	var time_diff = Save.get_time_difference(t1, t2)
	
	time_diff = 24 * time_diff[0] + time_diff[1]
	
	return int(time_diff/4)
