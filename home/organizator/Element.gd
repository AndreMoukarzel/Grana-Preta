extends Control

signal deleted(Self)

onready var creation_date = OS.get_datetime()
var value : String
var date

func setup(value : String, date = null, creation_date = null):
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
		$Date.text = "no dia " + date
	
	if not creation_date:
		Save.save_element(self)
	else:
		self.creation_date = creation_date


func _on_Delete_pressed():
	Save.delete_element(self)
	emit_signal("deleted", self) # Here value is set to 0, so must be deleted before
	queue_free()
