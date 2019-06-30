extends Button

var source_name : String
var strikes : int = 0 # with 3 strikes the debt is automatically charged
var value : int
var buy_date
var sell_date
var initial_price : int
var profit : int
var taxes : Array # Array of tuples ["Tax Name", ammount_taxed]


func setup(source_name : String, buy_date, sell_date, profit : int, taxes : Array):
	self.source_name = source_name
	self.buy_date = buy_date
	self.sell_date = sell_date
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
	$InitialPrice.text = str("G$", initial_price)
	$Profit.text = str("G$", profit)
	#taxes

func calculate_value(profit, taxes):
	var total_taxes = 1.0 + (taxes[0] + taxes[1] + taxes[2])/100.0
	
	return profit * (total_taxes + (self.strikes * 0.1))


func parse_datetime(datetime):
	var year_last_two_digits = str(datetime.year).right(-2)
	return str(datetime.day, "/", datetime.month, "/", year_last_two_digits)

func _on_Pay_pressed():
	var HUD = get_tree().get_root().get_node("HUD")
	
	HUD.subtract_money(value)
