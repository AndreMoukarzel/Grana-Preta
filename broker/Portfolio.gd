extends Control

const BOUGHT_BOND_SCN = preload("res://broker/bond/BoughtBond.tscn")
const BOND_EXPANSION = 300
const TWN_TIME = .2

var total_height = 0


func clear_bonds():
	total_height = 0
	for b in $Sorter/Bonds.get_children():
		b.set_name("old")
		b.queue_free()


func sell_expired_bonds():
	for b in $Sorter/Bonds.get_children():
		var time_diff = Save.get_time_difference(OS.get_datetime(), b.expiration)
		
		if time_diff[0] <= 0 and time_diff[0] <= 0:
			b._on_trade_confirmed(b.ammount)
			b.queue_free()


func update_bought_bonds():
	clear_bonds()
	var i = 0
	for b in Save.bought_bonds:
		var iteration_number = get_iteration_number(b)
		var Bond = add_bond($Sorter/Bonds, i)
		
		Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time, b.index_value)
		Bond.setup_owned(b.ammount, b.bought_time, b.last_updated_time, b.profit, b.id)
		if iteration_number > 0:
			print("iterating, ", iteration_number, " times")
			Bond.iterate(iteration_number)
			Bond.set_name("old")
			Bond.queue_free()
		else:
			total_height += 100
			i += 1
	sell_expired_bonds()


func add_bond(parent, name):
	var Bond = BOUGHT_BOND_SCN.instance()
	Bond.rect_position.y =  total_height
	Bond.set_name(str(name))
	Bond.connect("opened", self, "bond_opened")
	Bond.connect("closed", self, "bond_closed")
	parent.add_child(Bond)
	
	$SwipeHandler/SwipingCamera.limit_bottom = max(1024, total_height + 400 + 150)
	$SwipeHandler.update_cam_minmax()
	
	return Bond


func get_iteration_number(bond_save):
	var t1 = bond_save.last_updated_time
	var t2 = Save.get_min_datetime(bond_save.expiration, OS.get_datetime())
	var time_diff = Save.get_time_difference(t1, t2)
	
	time_diff = 24 * time_diff[0] + time_diff[1]
	
	return int(time_diff/4)


func close_all_bonds(exception = null):
	for child in $Sorter/Bonds.get_children():
		if exception and child == exception:
			continue
		if child.is_open:
			child.close()
			bond_closed(child)


func disable_all_bonds(disable = true):
	for child in $Sorter/Bonds.get_children():
		child.disabled = disable


func bond_opened(bond):
	var has_tween = false
	var pos_y = bond.rect_global_position.y
	
	disable_all_bonds()
	close_all_bonds(bond)
	for child in $Sorter/Bonds.get_children():
		if child.rect_global_position.y > pos_y:
			var pos = int(child.get_name()) * 100
			$Tween.interpolate_property(child, "rect_position:y", null, pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			has_tween = true
	if has_tween:
		$Tween.start()
		yield($Tween, "tween_completed")
	disable_all_bonds(false)


func bond_closed(bond):
	var has_tween = false
	var pos_y = bond.rect_global_position.y
	
	disable_all_bonds()
	for child in $Sorter/Bonds.get_children():
		if child.rect_global_position.y > pos_y:
			var pos = int(child.get_name()) * 100
			$Tween.interpolate_property(child, "rect_position:y", null, pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
			has_tween = true
	if has_tween:
		$Tween.start()
		yield($Tween, "tween_completed")
	disable_all_bonds(false)
