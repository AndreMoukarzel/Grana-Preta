extends Control

const ELEMENT_SCN = preload("res://home/organizator/Element.tscn")

var total_value : float = 0.01


func _ready():
	update_total()


func update_total():
	for child in $Elements.get_children():
		total_value += child.value
	$Total.text = "Total: " + str(stepify(total_value, 0.01))


func _on_AddElement_pressed():
	var Element = ELEMENT_SCN.instance()
	var element_count = $Elements.get_child_count()
	
	Element.name = str(element_count)
	Element.rect_position.y = element_count * 80
	$Elements.rect_size.y = (element_count + 1) * 80
	$Elements.add_child(Element)
	Element.setup(100.31)
	
	$AddElement.rect_position.y = $Elements.rect_size.y
	$Total.rect_position.y = $Elements.rect_size.y + 80