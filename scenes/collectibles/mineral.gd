class_name Mineral
extends Area2D

enum Kind {Bronze, Silver, Gold}

#signal collected

@export var kind = Kind.Bronze
@export var speed = 0
@export var trail_speed = 800
@export var amount = 1

var _direction = Vector2()
var _spin = 0
var _target = null
var _frame = 0
var _disappeared = false

func _ready():
  speed = randf_range(10 , 30)
  _direction = Vector2(randf_range(-1, 1) , randf_range(-1, 1)).normalized()
  _spin = randf_range(-10 , 10)
#  collected.connect(game_state.action._on_stuff_collected)
  $trail.set_as_top_level(true)

func _process(delta):
  _frame += 1
  if not _disappeared:
    if _target:
      translate(global_position.direction_to(_target.global_position) * trail_speed * delta)
      $trail.set_point_position($trail.get_point_count() - 1 , global_position)
      if _frame % 5 == 0:
        $trail.add_point(global_position)
    else:
      translate(_direction * speed * delta)
    rotate(_spin * delta)
  else:
    if $trail.get_point_count() > 0:
      $trail.remove_point(0)
    else:
      queue_free()

func collect():
  if _disappeared: return
  _disappeared = true
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $sprite.visible = false
#  collected.emit(self, amount)

func _follow(tgt):
  if tgt:
    _target = tgt
    $trail.add_point(position)

func _on_timer_timeout():
  pass
#  var player = game_state.player
##  var players = get_tree().get_nodes_in_group("player")
#  if player:
#    target = player
#    $trail.add_point(position)
##    $trail.add_point(global_position)

func _on_body_entered(body):
  if body.is_in_group("player"):
    if body.alive:
      (body as Player).collect(self, amount)
      collect()

func _on_area_entered(area):
  if area.is_in_group("magnetic"):
    _follow(game_state.player)
