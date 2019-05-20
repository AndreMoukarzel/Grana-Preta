extends "res://broker/bond/Bond.gd"

var id
var ammount
var bought_time


func setup_owned(ammount, bought_time, id):
	self.id = id
	self.ammount = ammount
	self.bought_time = bought_time
	$MinInvestment.text = str(ammount)


func resume_min_investment():
	$MinInvestment.text = str(ammount)

func expand_min_investment():
	$MinInvestment.text = str("Valor:\nG$ ", ammount)


func _on_Apply_pressed():
	var TradeConfirm = TRADE_CONFIRM_SCN.instance()
	var Canvas = get_tree().get_root().get_node("Broker/HUD")
	var Swipe = get_parent().get_parent().get_parent().get_node("SwipeHandler")
	
	TradeConfirm.setup(Swipe, 0, ammount) 
	Canvas.add_child(TradeConfirm)
	TradeConfirm.connect("trade_confirmed", self, "_on_trade_confirmed")


func _on_trade_confirmed(ammount):
	var Portfolio = get_tree().get_root().get_node("Broker/PortfolioMenu/Portfolio")
	
	Save.money += ammount
	self.ammount -= ammount
	Save.delete_bought_bond(id)
	if self.ammount > 0:
		Save.save_bought_bond(self, self.ammount)
	Portfolio.call_deferred("update_bought_bonds")
