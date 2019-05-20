extends Control

const BOUGHT_BOND_SCN = preload("res://broker/bond/BoughtBond.tscn")

var total_height = 100


func _ready():
	update_bought_bonds()


func update_bought_bonds():
	for b in $Sorter/Bonds.get_children():
		b.queue_free()
	for b in Save.bought_bonds:
		var Bond = add_bond($Sorter/Bonds)
		Bond.setup(b.name, b.display_rentability, b.rentability_type, b.expiration, b.min_investment, b.min_time, b.taxes, b.creation_time)
		Bond.setup_owned(b.ammount, b.bought_time, b.id)
		
		total_height += 100


func add_bond(parent):
	var Bond = BOUGHT_BOND_SCN.instance()
	Bond.rect_position.y =  parent.get_child_count() * 100
	Bond.set_name(str(parent.get_child_count()))
	Bond.connect("opened", self, "bond_opened")
	Bond.connect("closed", self, "bond_closed")
	parent.add_child(Bond)
	
	return Bond
