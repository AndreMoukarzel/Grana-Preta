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


func _ready():
	for i in range(2):
		var Bond = BOND_SCN.instance()
		Bond.rect_position.y = i * 100
		SafeBonds.add_child(Bond)
		Bond.setup("POP-I", 12.1, "Pre-fixada", [0, 3], 4000, [2, 1], [15, 2, 0.3])
		Bond.connect("opened", self, "bond_opened")
		Bond.connect("closed", self, "bond_closed")


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
			var pos = child.rect_position.y
			$Tween.interpolate_property(child, "rect_position:y", pos, pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
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
			var pos = child.rect_position.y
			$Tween.interpolate_property(child, "rect_position:y", pos, pos - BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if group != "Chanceful":
		$Tween.interpolate_property($Chanceful, "rect_position:y", null, c_pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if group == "Safe":
		$Tween.interpolate_property($Moderate, "rect_position:y", null, m_pos, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	disable_all_bonds(false)