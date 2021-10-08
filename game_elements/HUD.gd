extends CanvasLayer

export var heart_icon : Texture
export var coin_icon : Texture
export var no_coin_icon : Texture

func _init():
	PlayerStats.set("HUD", self)
	
func _ready():
	PlayerStats.initialize_HUD()

func hide():
	$ScoreBox.hide()

func show():
	$ScoreBox.show()
	
func update_hp(hp):
	var heart_box = $hearts/vbox
	for heart in heart_box.get_children():
		heart.queue_free()
	var y = 0
	for _h in range(hp):
		var heart = TextureRect.new()
		heart.texture = heart_icon
		heart.set_position(Vector2(0, y))
		heart_box.add_child(heart)
		y += 15
			
#pass [coin1, coin2, coin3] boolean lit
func update_bigcoins(coins=[false, false, false]):
	var coin_box = $big_coins/vbox
	for coin in coin_box.get_children():
		coin.queue_free()
	var y = 0
	for c in coins:
		var coin = TextureRect.new()
		if c:
			coin.texture = coin_icon
		else:
			coin.texture = no_coin_icon
		coin.set_position(Vector2(16, y))
		coin_box.add_child(coin)
		y+= 15
		
func show_only_score():
	$hearts.visible = false
	$MarginContainer.rect_position = Vector2(150, 12)

func level_cleared():
	$levelclear.visible = true

func update_score(value):
	$MarginContainer/HBoxContainer/Score.text = (str(value)).pad_zeros(8)
