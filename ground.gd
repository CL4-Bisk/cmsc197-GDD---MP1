extends Node2D
class_name Ground

var speed : float

@onready var ground: Node2D = $"."
@onready var g1: TileMapLayer = $ground1
@onready var g2: TileMapLayer = $ground2

var tile_size
var scale_x

func _ready() -> void:
	tile_size = g1.tile_set.tile_size
	scale_x = g1.scale.x
	attach_to_end(g2, g1)
	
	setup_notifier(g1, g2)
	setup_notifier(g2, g1)

func _process(delta: float) -> void:
	g1.global_position.x += speed * delta
	g2.global_position.x += speed * delta

func setup_notifier(layer : TileMapLayer, other) -> void:
	var n : VisibleOnScreenNotifier2D = layer.get_node("notifier")
	
	var rect = layer.get_used_rect()
	n.rect = Rect2(
		rect.position.x * tile_size.x, 
		rect.position.y * tile_size.y,
		rect.size.x * tile_size.x, 
		rect.size.y * tile_size.y
	)
	n.screen_exited.connect(func(): attach_to_end(layer, other))

func attach_to_end(item : TileMapLayer, ref : TileMapLayer) -> void:
	var rect = item.get_used_rect()
	var width = rect.size.x * tile_size.x * g1.scale.x
	item.global_position.x = ref.global_position.x + width


func stop() -> void:
	speed = 0
