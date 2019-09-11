extends Panel

signal add_element_date(ammount)
signal no_date()

var ammount : String = "0"

func _ready():
	$Confirm.disabled = true

func _on_Pad_value_changed(value):
	if value == "0":
		$Confirm.disabled = true
	else:
		$Confirm.disabled = false
	
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
