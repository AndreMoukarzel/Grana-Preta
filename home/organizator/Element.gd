extends Control

var value
var date

func setup(value : float, date = null):
	self.value = value
	self.date = date
	
	if value > 0.00:
		$Value.text = "+" + str(stepify(value, 0.01))
		$Value.modulate = Color(0.2, 1.0, 0.0)
	else:
		$Value.text = str(stepify(value, 0.01))
		$Value.modulate = Color(1, 0, 0)
	
	if not date:
		$Date.hide()
	else:
		$Date.text = date


func _on_Delete_pressed():
	queue_free()
