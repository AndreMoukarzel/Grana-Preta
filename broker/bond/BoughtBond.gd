extends "res://broker/bond/Bond.gd"

var ammount
var bought_time


func setup_owned(ammount, bought_time):
	self.ammount = ammount
	self.bought_time = bought_time
	
	$MinInvestment.text = str(ammount)


func _on_Apply_pressed():
	var TradeConfirm = TRADE_CONFIRM_SCN.instance()
	var Canvas = get_tree().get_root().get_node("Broker/HUD")
	var Swipe = get_parent().get_parent().get_parent().get_node("SwipeHandler")
	
	TradeConfirm.setup(0, ammount, Swipe) 
	Canvas.add_child(TradeConfirm)
	TradeConfirm.connect("trade_confirmed", self, "_on_trade_confirmed")


func _on_trade_confirmed(ammount):
	var Portfolio = get_tree().get_root().get_node("Broker/PortfolioMenu/Portfolio")
	
	Save.money += ammount
	Save.save_bought_bond(self, ammount)
	Portfolio.update_bought_bonds()
