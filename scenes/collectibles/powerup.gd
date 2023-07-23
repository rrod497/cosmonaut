class_name PowerUp
extends Area2D

@export var kind : String
@export var content : Resource
@export var speed = 100
var _next_pos = Vector2()
var _last_pos = Vector2()
var inter = 1

func _process(delta):
  if inter >= 1:
    _next_position()
  else:
    inter += (delta * speed) / _last_pos.distance_to(_next_pos)
  position = _last_pos.lerp(_next_pos, inter)

func _next_position():
  inter = 0
  _last_pos = position
  var x = randi_range(game_state.action.left, game_state.action.right)
  var y = randi_range(game_state.action.bottom, game_state.action.top)
  _next_pos = Vector2(x, y)

func _on_body_entered(body):
  if body.is_in_group("player"):
    (body as Player).collect(self, 1)
  queue_free()

func _on_lifespan_timeout():
  queue_free()

func _on_hurryup_timeout():
  $anime.play("hurryup")
