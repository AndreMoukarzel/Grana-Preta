extends Button

const TWN_TIME = .2

var source_name : String
var strikes : int = 0 # with 3 strikes the debt is automatically charged
var value : int # ammount to be paid (profit * taxes)
var buy_date = OS.get_datetime()
var sell_date = OS.get_datetime() # date the debt was generated
var ammount_sold : int # total ammount sold that produced current debt
var profit : int
var taxes : Array # Array of tuples ["Tax Name", ammount_taxed]
var is_open = false


func setup(source_name : String, buy_date, sell_date, ammount_sold : int, profit : int, taxes : Array):
	self.source_name = source_name
	self.buy_date = buy_date
	self.sell_date = sell_date
	self.ammount_sold = ammount_sold
	self.profit = profit
	self.taxes = taxes

	$SourceName.text = source_name
	self.strikes = max(0, Save.get_time_difference(sell_date, OS.get_date())[0])
	$Strikes/Sprite.frame = min(strikes, 0) 
	self.value = calculate_value(profit, taxes)
	$Value.text = str("G$", self.value)
	self.buy_date = buy_date
	$BuyDate.text = parse_datetime(buy_date)
	self.sell_date = sell_date
	$SellDate.text = parse_datetime(sell_date)
	$AmmountSold.text = str("G$", ammount_sold)
	$Profit.text = str("G$", profit)
	$Taxes.text = parse_taxes(taxes)


func calculate_value(profit, taxes):
	var total_taxes = (taxes[0] + taxes[1] + taxes[2])/100.0
	
	return int(profit * (total_taxes + (self.strikes * 0.1)))


func parse_datetime(datetime):
	var year_last_two_digits = str(datetime.year).right(2)
	return str(datetime.day, "/", datetime.month, "/", year_last_two_digits)


func parse_taxes(taxes):
	var tax_text = 'Impostos:\n'
	
	tax_text += str('       G$', int(taxes[0] * profit), ' (IR ', taxes[0], '%')
	tax_text += str('      +G$', int(taxes[1] * profit), ' (Adm ', taxes[1], '%')
	tax_text += str('      +G$', int(taxes[2] * profit), ' (Perf ', taxes[2], '%')
	
	return tax_text


func close():
	$Tween.interpolate_property(self, 'rect_size', null, Vector2(566, 120), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Value, 'rect_position', null, Vector2(5, 55), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BuyDate, 'rect_position', null, Vector2(50, 5), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($SellDate, 'rect_position', null, Vector2(50, 55), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Strikes, 'modulate', null, Color(1, 1, 1, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AmmountSold, 'modulate', null, Color(1, 1, 1, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Profit, 'modulate', null, Color(1, 1, 1, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Taxes, 'modulate', null, Color(1, 1, 1, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($TaxesLine, 'modulate', null, Color(1, 1, 1, 0), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	$Tween.start()
	
	$Value.text = str('G$', self.value)
	$BuyDate.text = parse_datetime(self.buy_date)
	$SellDate.text = parse_datetime(self.sell_date)
	
	is_open = false
	emit_signal("closed", self)


func open():
	$Tween.interpolate_property(self, 'rect_size', null, Vector2(566, 610), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Value, 'rect_position', null, Vector2(5, 540), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($BuyDate, 'rect_position', null, Vector2(-30, 55), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($SellDate, 'rect_position', null, Vector2(-30, 105), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Strikes, 'modulate', null, Color(1, 1, 1, 1), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AmmountSold, 'modulate', null, Color(1, 1, 1, 1), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Profit, 'modulate', null, Color(1, 1, 1, 1), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Taxes, 'modulate', null, Color(1, 1, 1, 1), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($TaxesLine, 'modulate', null, Color(1, 1, 1, 1), TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
	$Tween.start()
	
	$Value.text = str("Total: G$", self.value)
	$BuyDate.text = str('Compra: ', parse_datetime(self.buy_date))
	$SellDate.text = str('Venda: ', parse_datetime(self.sell_date))
	
	is_open = true
	emit_signal("opened", self)


func _on_Pay_pressed():
	var HUD = get_tree().get_root().get_node("IRS/HUD")
	
	if Save.money >= value:
		HUD.subtract_money(value)
		Save.delete_debt(self)
		queue_free()


func _on_Debt_pressed():
	if is_open:
		close()
	else:
		open()
