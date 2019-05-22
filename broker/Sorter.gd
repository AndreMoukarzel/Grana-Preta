extends Control

const TWN_TIME = .7

var last_sort = ""


func get_all_bonds():
	var bonds = []
	
	for b in $Bonds.get_children():
		bonds.append(b)
	return bonds


func tween_bonds(bonds):
	var i = 0
	for b in bonds:
		$Tween.interpolate_property(b, "rect_position:y", null, 100 * i, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		i += 1
	$Tween.start()


func _on_Value_pressed():
	var bonds = get_all_bonds()
	
	if not last_sort == "value":
		bonds.sort_custom(self, "value_sort")
		last_sort = "value"
	else:
		bonds.sort_custom(self, "inverse_value_sort")
		last_sort = ""
	tween_bonds(bonds)


func _on_Expiration_pressed():
	var bonds = get_all_bonds()
	
	if not last_sort == "expiration":
		bonds.sort_custom(self, "expiration_sort")
		last_sort = "expiration"
	else:
		bonds.sort_custom(self, "inverse_expiration_sort")
		last_sort = ""
	tween_bonds(bonds)


func _on_Rentability_pressed():
	var bonds = get_all_bonds()
	
	if not last_sort == "rentability":
		bonds.sort_custom(self, "rentability_sort")
		last_sort = "rentability"
	else:
		bonds.sort_custom(self, "inverse_rentability_sort")
		last_sort = ""
	tween_bonds(bonds)


func _on_Type_pressed():
	var bonds = get_all_bonds()
	
	if not last_sort == "type":
		bonds.sort_custom(self, "type_sort")
		last_sort = "type"
	else:
		bonds.sort_custom(self, "inverse_type_sort")
		last_sort = ""
	tween_bonds(bonds)


func _on_BoughtTime_pressed():
	var bonds = get_all_bonds()
	
	if not last_sort == "bought_time":
		bonds.sort_custom(self, "bought_time_sort")
		last_sort = "bought_time"
	else:
		bonds.sort_custom(self, "inverse_bought_time_sort")
		last_sort = ""
	tween_bonds(bonds)


func value_sort(a, b):
	if a.ammount < b.ammount:
		return true
	return false


func inverse_value_sort(a, b):
	if a.ammount < b.ammount:
		return false
	return true


func expiration_sort(a, b):
	var time_diff = Save.get_time_difference(a.expiration, b.expiration)
	if time_diff[0] >= 0 and time_diff[1] > 0:
		return true
	return false


func inverse_expiration_sort(a, b):
	var time_diff = Save.get_time_difference(a.expiration, b.expiration)
	if time_diff[0] >= 0 and time_diff[1] > 0:
		return false
	return true


func rentability_sort(a, b):
	if a.display_rentability < b.display_rentability:
		return true
	return false


func inverse_rentability_sort(a, b):
	if a.display_rentability < b.display_rentability:
		return false
	return true


func type_sort(a, b):
	if a.rentability_type == "Pre-fixada" or  b.rentability_type == "Prov":
		return true
	return false


func inverse_type_sort(a, b):
	if a.rentability_type == "Pre-fixada" or  b.rentability_type == "Prov":
		return false
	return true


func bought_time_sort(a, b):
	var time_diff = Save.get_time_difference(a.bought_time, b.bought_time)
	if time_diff[0] >= 0 and time_diff[1] > 0:
		return true
	return false


func inverse_bought_time_sort(a, b):
	var time_diff = Save.get_time_difference(a.bought_time, b.bought_time)
	if time_diff[0] >= 0 and time_diff[1] > 0:
		return false
	return true