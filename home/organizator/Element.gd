extends Control

signal deleted(Self)

var value : String
var date

func setup(value : String, date = null):
	self.value = value
	self.date = date
	
	if float(value) > 0.00:
		$Value.text = "+" + value
		$Value.modulate = Color(0.2, 1.0, 0.0)
	else:
		$Value.text = value
		$Value.modulate = Color(1, 0, 0)
	
	if not date:
		$Date.hide()
	else:
		$Date.text = date


func _on_Delete_pressed():
	emit_signal("deleted", self)
	queue_free()
