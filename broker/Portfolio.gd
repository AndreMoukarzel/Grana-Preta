extends Control

const BOND_SCN = preload("res://broker/bond/Bond.tscn")

var total_height = 10


func _ready():
	update_bought_bonds()


func update_bought_bonds():
	for b in Save.bought_bonds:
		var Bond = add_bond(self)
		Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time)
		Bond.setup_owned(b.ammount, b.bought_time)


func add_bond(parent):
	var Bond = BOND_SCN.instance()
	Bond.rect_position.y =  parent.get_child_count() * 100
	Bond.set_name(str(parent.get_child_count()))
	Bond.connect("opened", self, "bond_opened")
	Bond.connect("closed", self, "bond_closed")
	parent.add_child(Bond)
	
	return Bond