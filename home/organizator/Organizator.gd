extends Control

const ELEMENT_SCN = preload("res://home/organizator/Element.tscn")
const ADDER_SCN = preload("res://home/organizator/ElementAdder.tscn")
const MIN_HEIGHT = 140

var total_value : String = "0"


func _ready():
	update_total()


func add_values(v1 : String, v2 : String):
	var v1_int = int(v1.split(".")[0])
	var v2_int = int(v2.split(".")[0])
	var v1_float = 0
	var v2_float = 0
	
	if len(v1.split(".")) > 1:
		v1_float = int(v1.split(".")[1])
	if len(v2.split(".")) > 1:
		v2_float = int(v2.split(".")[1])
	
	var sum_int = v1_int + v2_int
	var sum_float = v1_float + v2_float
	
	if sum_float >= 100:
		sum_float -= 100
		sum_int += 1
	if sum_float < 10:
		sum_float = "0" + str(sum_float)
	
	return str(sum_int) + "." + str(sum_float)

func update_total():
	total_value = "0"
	for child in $Elements.get_children():
		total_value = add_values(child.value, total_value)
	
	$Total/Value.text = total_value
	if float(total_value) > 0.00:
		$Total/Value.modulate = Color(.2, 1, 0)
	else:
		$Total/Value.modulate = Color(1, 0, 0)


func delete_element(DeletedElement):
	var deleted_index = int(DeletedElement.name)
	
	DeletedElement.name = "old"
	DeletedElement.value = "0"
	for i in range(deleted_index + 1, $Elements.get_child_count()):
		var child = $Elements.get_node(str(i))
		child.name = str(i - 1)
		child.rect_position.y = (i - 1) * 80
	$Elements.rect_size.y = ($Elements.get_child_count() - 1) * 80
	$AddElement.rect_position.y = $Elements.rect_size.y + MIN_HEIGHT
	$Total.rect_position.y = $Elements.rect_size.y + 80 + MIN_HEIGHT
	update_total()


func add_element(value : String, date = null):
	var Element = ELEMENT_SCN.instance()
	var element_count = $Elements.get_child_count()
	
	Element.name = str(element_count)
	Element.rect_position.y = element_count * 80
	Element.connect("deleted", self, "delete_element")
	$Elements.rect_size.y = (element_count + 1) * 80
	$Elements.add_child(Element)
	Element.setup(add_values(value, "0.00"), date)
	
	$AddElement.rect_position.y = $Elements.rect_size.y + MIN_HEIGHT
	$Total.rect_position.y = $Elements.rect_size.y + 80 + MIN_HEIGHT
	update_total()


func _on_AddElement_pressed():
	var Adder = ADDER_SCN.instance()
	
	Adder.connect("add_element", self, "add_element")
	
	add_child(Adder)
