extends Control

const ELEMENT_SCN = preload("res://home/organizator/Element.tscn")

var total_value : float = 0.01


func _ready():
	update_total()


func update_total():
	for child in $Elements.get_children():
		total_value += child.value
	
	$Total/Value.text = str(stepify(total_value, 0.01))
	if total_value > 0.00:
		$Total/Value.modulate = Color(.2, 1, 0)
	else:
		$Total/Value.modulate = Color(1, 0, 0)


func add_element(value : float, date = null):
	var Element = ELEMENT_SCN.instance()
	var element_count = $Elements.get_child_count()
	
	Element.name = str(element_count)
	Element.rect_position.y = element_count * 80
	$Elements.rect_size.y = (element_count + 1) * 80
	$Elements.add_child(Element)
	Element.setup(value, date)
	
	$AddElement.rect_position.y = $Elements.rect_size.y
	$Total.rect_position.y = $Elements.rect_size.y + 80
	update_total()


func _on_AddElement_pressed():
	add_element(-100.31)
