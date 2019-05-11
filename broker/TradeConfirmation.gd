extends Control

signal trade_confirmed(ammount)

var ammount = 1
var min_ammount = 1
var multiplier = 1
var showing_max = false
var Swipe = null


func setup(min_ammount, Swipe):
	self.Swipe = Swipe
	Swipe.deactivate()
	self.min_ammount = min_ammount
	ammount = min_ammount
	update_ammount()


func update_ammount():
	$Ammount/AmmountLabel.text = str("G$ ", ammount)
	if ammount > Save.money:
		$Ammount/AmmountLabel.modulate = Color(50, 0.0, 0.0)
	else:
		$Ammount/AmmountLabel.modulate = Color(1.0, 1.0, 1.0)


func _on_Minus_pressed():
	ammount -= multiplier
	ammount = max(min_ammount, ammount)
	update_ammount()


func _on_Plus_pressed():
	ammount += multiplier
	update_ammount()


func _on_Multiplier_pressed():
	multiplier *= 10
	$Ammount/Multiplier.text = str("x", multiplier)
	if showing_max:
		multiplier = 1
		showing_max = 0
		$Ammount/Multiplier.text = "x1"
	elif multiplier > 10000: # After x10000, multiplies to maximum buyable
		multiplier = Save.money - ammount
		showing_max = true
		$Ammount/Multiplier.text = str("MAX BUYABLE")


func _on_Cancel_pressed():
	Swipe.activate()
	queue_free()


func _on_Confirm_pressed():
	Swipe.activate()
	emit_signal("trade_confirmed", ammount)
	queue_free()
