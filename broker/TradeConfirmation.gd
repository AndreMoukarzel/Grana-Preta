extends Control

signal trade_confirmed(ammount)

var ammount = 1
var min_ammount = 1
var max_ammount # if max_ammount is not null, we know the trade is a sell
var multiplier = 1
var showing_max = false
var Swipe = null


func setup(Swipe, min_ammount, max_ammount = null):
	self.Swipe = Swipe
	Swipe.deactivate()
	self.min_ammount = min_ammount
	ammount = min_ammount
	update_ammount()


func update_ammount():
	$Ammount/AmmountLabel.text = str("G$ ", ammount)
	if max_ammount:
		if ammount > max_ammount:
			ammount = max_ammount
			$Ammount/AmmountLabel.text = str("G$ ", ammount)
	else:
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
	if not max_ammount and ammount > Save.money:
		var Twn = $Warning/Tween
		
		Twn.stop_all()
		$Warning.modulate = Color(1, 1, 1, 1)
		Twn.interpolate_property($Warning, "modulate:a", 1, 0, 2.0, Tween.TRANS_QUAD, Tween.EASE_IN, 3.0)
		Twn.start()
	else:
		Swipe.activate()
		emit_signal("trade_confirmed", ammount)
		queue_free()
