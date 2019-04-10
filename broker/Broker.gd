extends Control

const SCREEN_SIZE = Vector2(576, 1024)
const TWN_TIME = 1


func _ready():
	$Background/Panel.rect_size = SCREEN_SIZE
	$Menu.rect_size = self.rect_size * 0.8
	$Menu.rect_position.y = self.rect_size.y * 0.2
	$Turtle.rect_position.x = self.rect_size.x * 0.8


func tween_menus(middle_position):
	$Tween.interpolate_property($Menu, "rect_position:x", null, middle_position, TWN_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($InvestmentMenu, "rect_position:x", null, middle_position + SCREEN_SIZE.x, TWN_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($PortfolioMenu, "rect_position:x", null, middle_position - SCREEN_SIZE.x, TWN_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Investments_pressed():
	tween_menus(-SCREEN_SIZE.x)


func _on_Portfolio_pressed():
	tween_menus(SCREEN_SIZE.x)