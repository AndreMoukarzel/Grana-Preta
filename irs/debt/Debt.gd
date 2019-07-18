extends Button

var source_name : String
var strikes : int = 0 # with 3 strikes the debt is automatically charged
var value : int # ammount to be paid (profit * taxes)
var buy_date
var sell_date # date the debt was generated
var ammount_sold : int # total ammount sold that produced current debt
var profit : int
var taxes : Array # Array of tuples ["Tax Name", ammount_taxed]


func setup(source_name : String, buy_date, sell_date, ammount_sold : int, profit : int, taxes : Array):
	self.source_name = source_name
	self.buy_date = buy_date
	self.sell_date = sell_date
	self.ammount_sold = ammount_sold
	self.profit = profit
	self.taxes = taxes

	$SourceName.text = source_name
	# calculate strikes ( difference between sell_date and current time)
	self.value = calculate_value(profit, taxes)
	$Value.text = str("G$", self.value)
	self.buy_date = buy_date
	$BuyDate.text = parse_datetime(buy_date)
	self.sell_date = sell_date
	$SellDate.text = parse_datetime(sell_date)
	$AmmountSold.text = str("G$", ammount_sold)
	$Profit.text = str("G$", profit)
	#taxes

func calculate_value(profit, taxes):
	var total_taxes = (taxes[0] + taxes[1] + taxes[2])/100.0
	
	return int(profit * (total_taxes + (self.strikes * 0.1)))

func parse_datetime(datetime):
	var year_last_two_digits = str(datetime.year).right(-2)
	return str(datetime.day, "/", datetime.month, "/", year_last_two_digits)


func resume_info():
	pass


func expand_info():
	pass

#func close():
#	resume_info()
#	$MinTime.hide()
#	$Taxes.hide()
#	$Tween.interpolate_property(self, "rect_size:y", null, 70, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Name, "rect_position:x", null, 10, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Rentability, "rect_position", null, Vector2(110, -20), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	if time_left[0] > 0 and time_left[1] > 0:
#		$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(260, -45), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	else:
#		$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(260, -20), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($MinInvestment, "rect_position", null, Vector2(320, -20), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Apply, "rect_position", null, Vector2(425, 5), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Apply, "rect_size", null, Vector2(147, 64), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.start()
#
#	is_open = false
#	emit_signal("closed", self)
#
#
#func open():
#	expand_info()
#	$MinTime.show()
#	$Taxes.show()
#	$Tween.interpolate_property(self, "rect_size:y", null, 360, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Name, "rect_position:x", null, (rect_size.x - $Name.rect_size.x)/2, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Rentability, "rect_position", null, Vector2(10, 50), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Expiration, "rect_position", null, Vector2(300, 50), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($MinInvestment, "rect_position", null, Vector2(10, 130), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Apply, "rect_position", null, Vector2((rect_size.x - 350)/2, 290), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Apply, "rect_size:x", null, 350, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($MinTime, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2*TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.interpolate_property($Taxes, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2*TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	$Tween.start()
#
#	is_open = true
#	emit_signal("opened", self)

func _on_Pay_pressed():
	var HUD = get_tree().get_root().get_node("IRS/HUD")
	
	if Save.money >= value:
		HUD.subtract_money(value)
		queue_free()
