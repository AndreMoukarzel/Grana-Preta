extends Button

signal opened(parent)
signal closed(parent)

const FONT_WIDTH = 15
const BASE_HEIGHT = 80
const TWN_TIME = .2
const SUBJECT_LESSON_SCN = preload("res://school/Subjects/SubjectLesson.tscn")

var is_open = false
var bond_name : String
var rentability : float
var rentability_type : String # Pre, Pos index or Pos provisioned 
var expiration
var min_investment : int
var min_time
var taxes


func setup(bond_name : String, rentability : float, rentability_type : String, expiration : Array, min_investment : int, min_time : Array, taxes : Array):
#	rect_size = Vector2(get_parent().rect_size.x, 70)
	self.bond_name = bond_name
	self.rentability = rentability
	self.rentability_type = rentability_type
	self.expiration = expiration
	self.min_investment = min_investment
	self.min_time = min_time
	self.taxes = taxes
	
	$Name.text = bond_name
	if rentability_type == "Pré-fixada":
		$Rentability.text = str("PRE", rentability)
	elif rentability_type == "Pós-fixada":
		$Rentability.text = str("POS", rentability)
	# expiration
	$MinInvestment.text = min_investment
	# min_time
	$Taxes.text = str("IR(", taxes[0], "), Adm(", taxes[1], "),\nPerf(", taxes[2], ")")


func close():
	$MinTime.hide()
	$Taxes.hide()
	$Tween.interpolate_property(self, "rect_size:y", null, 70, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Name, "rect_position:x", null, 10, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Rentability, "rect_position", null, Vector2(130, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(260, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MinInvestment, "rect_position", null, Vector2(320, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_position", null, Vector2(425, 2), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_size", null, Vector2(147, 64), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = false
	emit_signal("closed", self)


func open():
	$MinTime.show()
	$Taxes.show()
	$Tween.interpolate_property(self, "rect_size:y", null, 300, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Name, "rect_position:x", null, (rect_size.x - $Name.rect_size.x)/2, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Rentability, "rect_position", null, Vector2(10, 50), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(350, 50), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MinInvestment, "rect_position", null, Vector2(10, 100), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_position", null, Vector2((rect_size.x - 350)/2, 230), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_size:x", null, 350, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MinTime, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2*TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Taxes, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2*TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = true
	emit_signal("opened", self)


func _on_Bond_pressed():
	if is_open:
		close()
	else:
		open()
