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
	print(rect_size)
	print(rect_scale)
	print(margin_bottom)

func resume_info():
	pass


func expand_info():
	pass


func calculate_value(profit, taxes):
	var total_taxes = (taxes[0] + taxes[1] + taxes[2])/100.0
	
	return int(profit * (total_taxes + (self.strikes * 0.1)))

func parse_datetime(datetime):
	var year_last_two_digits = str(datetime.year).right(-2)
	return str(datetime.day, "/", datetime.month, "/", year_last_two_digits)

func _on_Pay_pressed():
	var HUD = get_tree().get_root().get_node("IRS/HUD")
	
	if Save.money >= value:
		HUD.subtract_money(value)
		queue_free()
