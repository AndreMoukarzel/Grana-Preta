extends Control

signal trade_confirmed(ammount)

var ammount = 1
var min_ammount = 1
var multiplier = 1
var showing_max = false
var price_per_unit = 1


func setup(min_ammount, price_per_unit):
	self.min_ammount = min_ammount
	self.price_per_unit = price_per_unit
	ammount = min_ammount
	update_price_and_ammout()


func update_price_and_ammout():
	var price = price_per_unit * ammount
	$Price/AmmountLabel.text = str("G$ ", price)
	$Ammount/AmmountLabel.text = str(ammount)
	if price > Save.money:
		$Price/AmmountLabel.modulate = Color(50, 0.0, 0.0)
	else:
		$Price/AmmountLabel.modulate = Color(1.0, 1.0, 1.0)


func _on_Minus_pressed():
	ammount -= multiplier
	ammount = max(min_ammount, ammount)
	update_price_and_ammout()


func _on_Plus_pressed():
	ammount += multiplier
	update_price_and_ammout()


func _on_Multiplier_pressed():
	multiplier *= 10
	$Ammount/Multiplier.text = str("x", multiplier)
	if showing_max:
		multiplier = 1
		showing_max = 0
		$Ammount/Multiplier.text = "x1"
	elif multiplier == 10000: # After x10000, multiplies to maximum buyable
		var money_dif = Save.money - (price_per_unit * ammount)
		multiplier= money_dif/price_per_unit
		showing_max = true
		$Ammount/Multiplier.text = str("MAX BUYABLE")


func _on_Cancel_pressed():
	queue_free()


func _on_Confirm_pressed():
	emit_signal("trade_confirmed", ammount)
	queue_free()
