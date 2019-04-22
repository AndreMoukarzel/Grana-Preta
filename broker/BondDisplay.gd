extends Control

const BOND_SCN = preload("res://broker/bond/Bond.tscn")
const BOND_EXPANSION = 300
const TWN_TIME = .2

onready var SafeBonds = $Safe/Bonds
onready var ModerBonds = $Moderate/Bonds
onready var ChanceBonds = $Chanceful/Bonds
onready var s_pos = $Safe.rect_position.y
onready var m_pos = $Moderate.rect_position.y
onready var c_pos = $Chanceful.rect_position.y

var total_height = 300


func _ready():
#	for i in range(2):
#		var Bond = add_bond(ModerBonds)
#		Bond.setup("POP-I", 12.1, "Pre-fixada", [0, 3], 4000, [2, 1], [15, 2, 0.3])
	$BondGenerator.generate()
	s_pos = $Safe.rect_position.y
	m_pos = $Moderate.rect_position.y
	c_pos = $Chanceful.rect_position.y


func add_bond(parent):
	var Bond = BOND_SCN.instance()
	Bond.rect_position.y =  parent.get_child_count() * 100
	Bond.set_name(str(parent.get_child_count()))
	Bond.connect("opened", self, "bond_opened")
	Bond.connect("closed", self, "bond_closed")
	parent.add_child(Bond)
	
	if parent != ChanceBonds:
		$Chanceful.rect_position.y += 110
		if parent != ModerBonds:
			$Moderate.rect_position.y += 110
		total_height += 110
	
	return Bond


func close_all_bonds(exception = null):
	for child in $Safe/Bonds.get_children():
		if exception and child == exception:
			continue
		if child.is_open:
			child.close()
			bond_closed(child)
	for child in $Moderate/Bonds.get_children():
		if exception and child == exception:
			continue
		if child.is_open:
			child.close()
			bond_closed(child)
	for child in $Chanceful/Bonds.get_children():
		if exception and child == exception:
			continue
		if child.is_open:
			child.close()
			bond_closed(child)


func disable_all_bonds(disable = true):
	for child in $Safe/Bonds.get_children():
		child.disabled = disable
	for child in $Moderate/Bonds.get_children():
		child.disabled = disable
	for child in $Chanceful/Bonds.get_children():
		child.disabled = disable


func bond_opened(bond):
	var pos_y = bond.rect_global_position.y
	var group = bond.get_parent().get_parent().get_name()
	
	disable_all_bonds()
	close_all_bonds(bond)
	for child in bond.get_parent().get_children():
		if child.rect_global_position.y > pos_y:
			var pos = int(child.get_name()) * 100
			$Tween.interpolate_property(child, "rect_position:y", null, pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if group != "Chanceful":
		$Tween.interpolate_property($Chanceful, "rect_position:y", null, c_pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if group == "Safe":
		$Tween.interpolate_property($Moderate, "rect_position:y", null, m_pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	disable_all_bonds(false)


func bond_closed(bond):
	var pos_y = bond.rect_global_position.y
	var group = bond.get_parent().get_parent().get_name()
	
	disable_all_bonds()
	for child in bond.get_parent().get_children():
		if child.rect_global_position.y > pos_y:
			var pos = int(child.get_name()) * 100
			$Tween.interpolate_property(child, "rect_position:y", null, pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if group != "Chanceful":
		$Tween.interpolate_property($Chanceful, "rect_position:y", null, c_pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if group == "Safe":
		$Tween.interpolate_property($Moderate, "rect_position:y", null, m_pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	disable_all_bonds(false)