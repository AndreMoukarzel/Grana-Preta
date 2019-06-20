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
	# calculate value from profit * taxes
	# calculate strikes ( difference between sell_date and current time)
	$Value.text = str("G$", value)
	#buydate
	#selldate
	$InitialPrice.text = str("G$", initial_price)
	$Profit.text = str("G$", profit)
	#taxes


func _on_Pay_pressed():
	var HUD = get_tree().get_root().get_node("HUD")
	
	HUD.subtract_money(value)
