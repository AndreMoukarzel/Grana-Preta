extends Panel

signal add_element_date(ammount)
signal no_date()

var ammount : String = "1"

func _ready():
	$Pad.number = "1"

func _on_Pad_value_changed(value):
	if value == "0":
		value = "1"
	if len(value) > 2 and value[0] == "2":
		value = value[0] + value[-1]
	if int(value) > 28:
		value = "28"
	$Pad.number = value 
	ammount = value
	$Ammount/AmmountLabel.text = ammount

func _on_Cancel_pressed():
	emit_signal("no_date")
	queue_free()

func _on_Confirm_pressed():
	emit_signal("add_element_date", ammount)
	queue_free()
