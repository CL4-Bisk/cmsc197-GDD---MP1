extends Node

#@export var coin_scene: PackedScene
#@export var powerup_scene: PackedScene

var score: int = 0
var screensize: Vector2 = Vector2.ZERO
var playing: bool = false

func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	$Boss.hide()
	$Enemy.hide()
	#$Pipes.hide()
	$Player/Health_bar.hide()
	
	var hearts_parent = $Player/Health_bar/HBoxContainer
	for child in hearts_parent.get_children():
		$Player.hearts_list.append(child)
	print($Player.hearts_list)

func new_game() -> void:
	playing = true
	score = 0

	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")

	$Player/Health_bar.show()
	$Player.start()
	$Player.show()
	
	await $HUD/Timer.timeout
	
	$Boss.show()
	
	$Enemy.show()
	
	$Pipes.show()

	
	#$GameTimer.start()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not playing:
		return

func game_over() -> void:
	playing = false
	#$EndSound.play()
	$HUD.show_game_over()
	$Player.die()

func take_damage() -> void:
	if $Player.health > 0:
		$Player.health -= 1
		update_heart_display()

func update_heart_display() -> void:
	for i in range($Player.hearts_list.size()):
		$Player.hearts_list[i].visible = i < $Player.health
	
	if $Player.health == 1:
		$Player.hearts_list[0].get_child(0).animation("beating")
	if $Player.health > 1:
		$Player.hearts_list[0].get_child(0).animation("idle")

#func _on_player_pickup(type: String) -> void:
	#match type:
		#"coin":
			#$CoinSound.play()
			#score += 1
			#$HUD.update_score(score)
		#"powerup":
			#time_left += 5
			#$HUD.update_timer(time_left)
			#$PowerupSound.play()
