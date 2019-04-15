extends Control

const BOND_SCN = preload("res://broker/bond/Bond.tscn")
const BOND_EXPANSION = 380
const TWN_TIME = .2

onready var SafeBonds = $Safe/Bonds
onready var ModerBonds = $Moderate/Bonds
onready var ChanceBonds = $Chanceful/Bonds


func _ready():
	for i in range(3):
		var Bond = BOND_SCN.instance()
		Bond.rect_position.y = i * 100
		SafeBonds.add_child(Bond)
		Bond.setup("POP-I", 12.1, "Pre-fixada", [0, 3], 4000, [2, 1], [15, 2, 0.3])
		Bond.connect("opened", self, "bond_opened")
		Bond.connect("closed", self, "bond_closed")


func bond_opened(bond):
	var pos_y = bond.rect_global_position.y
	var group = bond.get_parent().get_parent().get_name()
	
	for child in bond.get_parent().get_children():
		if child.rect_global_position.y > pos_y:
			var c_pos = child.rect_position.y
			$Tween.interpolate_property(child, "rect_position:y", c_pos, c_pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if group != "Chanceful":
		var g_pos = $Chanceful.rect_position.y
		$Tween.interpolate_property($Chanceful, "rect_position:y", g_pos, g_pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if group == "Safe":
		var g_pos = $Moderate.rect_position.y
		$Tween.interpolate_property($Moderate, "rect_position:y", g_pos, g_pos + BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func bond_closed(bond):
	var pos_y = bond.rect_global_position.y
	var group = bond.get_parent().get_parent().get_name()
	
	for child in bond.get_parent().get_children():
		if child.rect_global_position.y > pos_y:
			var c_pos = child.rect_position.y
			$Tween.interpolate_property(child, "rect_position:y", c_pos, c_pos - BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	if group != "Chanceful":
		var g_pos = $Chanceful.rect_position.y
		$Tween.interpolate_property($Chanceful, "rect_position:y", g_pos, g_pos - BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if group == "Safe":
		var g_pos = $Moderate.rect_position.y
		$Tween.interpolate_property($Moderate, "rect_position:y", g_pos, g_pos - BOND_EXPANSION, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()