extends Button

signal opened(parent)
signal closed(parent)

const FONT_WIDTH = 15
const BASE_HEIGHT = 80
const TWN_TIME = .2
const TRADE_CONFIRM_SCN = preload("res://broker/TradeConfirmation.tscn")

var is_open = false
var bond_name : String
var display_rentability : float # Expected rentability of bond in 5 days
var rentability : float # How much the bond returns each 4 hours ( or each day, in case of provisioned bonds )
var rentability_type : String # Pre, Pos index or Pos provisioned 
var expiration
var min_investment : int
var min_time
var taxes
var creation_time
var time_left


func setup(bond_name : String, five_day_rentability : float, rentability_type : String, expiration, min_investment : int, min_time : Array, taxes : Array, creation_time):
	self.bond_name = bond_name
	self.display_rentability = five_day_rentability
	self.rentability_type = rentability_type
	self.expiration = expiration
	self.min_investment = min_investment
	self.min_time = min_time
	self.taxes = taxes
	self.creation_time = creation_time
	self.time_left = Save.get_time_difference(OS.get_datetime(), expiration)
	
	if rentability_type == "Pre-fixada":
		self.rentability = calculate_safebond_rentability(self.display_rentability)
	elif rentability_type == "Pos-fixada":
		self.rentability = calculate_moderatebond_rentability(self.display_rentability)
	elif rentability_type == "Prov":
		self.rentability = self.display_rentability
	$Name.text = bond_name
	$MinTime.text = "Carencia: "
	if min_time[0] > 0:
		$MinTime.text += str(min_time[0], " dias")
		if min_time[1] > 0:
			$MinTime.text += str(" e\n", min_time[1], " horas")
	elif min_time[1] > 0:
		$MinTime.text += str(min_time[1], " horas")
	$Taxes.text = str("Taxas:\nIR(", taxes[0], "%), Adm(", stepify(taxes[1], 0.1), "%),\nPerf(", stepify(taxes[2], 0.1), "%)")
	expand_info() # used here to adapt labels to correct size
	resume_info()


func resume_info():
	$Rentability.rect_scale = Vector2(1, 1)
	if rentability_type == "Pre-fixada":
		$Rentability.text = str("PRE", stepify(display_rentability, 0.1))
	elif rentability_type == "Pos-fixada":
		$Rentability.text = str("POS", stepify(display_rentability, 0.1))
		$Name.text = bond_name
	elif rentability_type == "Prov":
		$Rentability.text = str("PR", stepify(display_rentability, 0.1))
		$Name.text = bond_name
		
	
	
	$Expiration.rect_scale = Vector2(1, 1)
	if time_left[0] > 0: # days left
		$Expiration.text = str(time_left[0], "D")
	elif time_left[1] > 0: # hours left
		$Expiration.text = str(time_left[1], "H")
	
	$MinInvestment.rect_scale = Vector2(1, 1)
	resume_min_investment()


func expand_info():
	$Rentability.rect_scale = Vector2(.7, .7)
	$Rentability.text = "Rentabilidade:\n"
	if rentability_type == "Pre-fixada":
		$Rentability.text += str("Pre-fixada em ", stepify(display_rentability, 0.1) , "%")
	elif rentability_type == "Pos-fixada":
		var index_name
		var name_split = bond_name.split("-")
		
		if name_split[0] == "S":
			index_name = "Selic"
		elif name_split[0] == "I":
			index_name = "Inflação"
		$Rentability.text += str(stepify(display_rentability * 100, 0.1) , "% da ", index_name)
		$Name.text = str(index_name, " - ", name_split[1])
	elif rentability_type == "Prov":
		var index_name
		
		if bond_name == "R":
			index_name = "Riscado"
		elif bond_name == "X":
			index_name = "Xtremo"
		$Rentability.text += str(stepify(display_rentability, 0.1) , "% em ", index_name)
		$Name.text = index_name
	
	$Expiration.rect_scale = Vector2(.7, .7)
	$Expiration.text = "Vencimento:\n"
	if time_left[0] > 0: # days left
		$Expiration.text += str(time_left[0], " dias")
		if time_left[1] > 0: # hours left
			$Expiration.text += str("\ne ", time_left[1], " horas")
	elif time_left[1] > 0: # hours left
		$Expiration.text += str(time_left[1], " horas")
	
	$MinInvestment.rect_scale = Vector2(.7, .7)
	expand_min_investment()


func resume_min_investment(): # Overwritten in BoughtBond.gd
	$MinInvestment.text = str(min_investment)


func expand_min_investment(): # Overwritten in BoughtBond.gd
	$MinInvestment.text = str("Requisito:\nG$ ", min_investment)


func close():
	resume_info()
	$MinTime.hide()
	$Taxes.hide()
	$Tween.interpolate_property(self, "rect_size:y", null, 70, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Name, "rect_position:x", null, 10, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Rentability, "rect_position", null, Vector2(110, -20), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if time_left[0] > 0 and time_left[1] > 0:
		$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(260, -45), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	else:
		$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(260, -20), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MinInvestment, "rect_position", null, Vector2(320, -20), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_position", null, Vector2(425, 5), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_size", null, Vector2(147, 64), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = false
	emit_signal("closed", self)


func open():
	expand_info()
	$MinTime.show()
	$Taxes.show()
	$Tween.interpolate_property(self, "rect_size:y", null, 360, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Name, "rect_position:x", null, (rect_size.x - $Name.rect_size.x)/2, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Rentability, "rect_position", null, Vector2(10, 50), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(300, 50), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MinInvestment, "rect_position", null, Vector2(10, 130), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_position", null, Vector2((rect_size.x - 350)/2, 290), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Apply, "rect_size:x", null, 350, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($MinTime, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2*TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Taxes, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2*TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = true
	emit_signal("opened", self)


# Look at "Working out interest rates" at https://www.mathsisfun.com/money/compound-interest.html
func calculate_safebond_rentability(five_day_rentability):
	var fdr = (100 + five_day_rentability)/100
	var four_hour_rentability = pow(fdr, 1.0/30.0)
	
	return four_hour_rentability


# Look at "Working out interest rates" at https://www.mathsisfun.com/money/compound-interest.html
func calculate_moderatebond_rentability(five_day_rentability):
	var four_hour_rentability = pow(five_day_rentability, 1.0/30.0)
	
	return four_hour_rentability


func _on_Bond_pressed():
	if is_open:
		close()
	else:
		open()


func _on_Apply_pressed():
	var TradeConfirm = TRADE_CONFIRM_SCN.instance()
	var Canvas = get_tree().get_root().get_node("Broker/HUD")
	var Swipe = get_parent().get_parent().get_parent().get_node("SwipeHandler")
	
	TradeConfirm.setup(Swipe, min_investment) 
	Canvas.add_child(TradeConfirm)
	TradeConfirm.connect("trade_confirmed", self, "_on_trade_confirmed")


func _on_trade_confirmed(ammount):
	Save.money -= ammount
	Save.save_bought_bond(self, ammount)
