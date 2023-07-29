extends Node2D


@export var damage = 1
@export var speed = 600
@export var max_targets = 3
var _dir = Vector2(0,-1)
var _targets = Array()

func start(pos, dir):
  global_position = pos
  _dir = dir.normalized()
  $sparks.emitting = true
  select_targets()
  launch()

func select_targets():
  var foes = get_tree().get_nodes_in_group("asteroids")
  var last_pos = global_position
  for n in min(foes.size(), max_targets):
    foes.sort_custom(func (a, b): return last_pos.distance_to(a.global_position) < last_pos.distance_to(b.global_position))
    _targets.append(foes.pop_front())
    last_pos = _targets[-1].global_position
  print(_targets)

func launch():
  for target in _targets:
    $line.add_point($line.to_local(target.global_position))
    target.hit()
  await get_tree().create_timer(0.5).timeout
  queue_free()

#  foes = game_state.action.get_tree

#func _process(delta):
#  translate(global_position.direction_to(_target.global_position) * trail_speed * delta)
#      $trail.set_point_position($trail.get_point_count() - 1 , global_position)
#      if _frame % 5 == 0:
#        $trail.add_point(global_position)
