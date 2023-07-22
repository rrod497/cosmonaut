extends Node2D

@export var asteroids : Array[PackedScene]



func _on_asteroid_spawn_timeout():
  var a = settings.get_asteroids().pick_random().instantiate()
  add_child(a)
#  get_parent().call_deferred("add_child", a)
  var xposA = $player_area/bounds/top.shape.a.x
  var xposB = $player_area/bounds/top.shape.b.x
  a.position.y = $player_area/bounds/top.shape.a.y - 100
  a.position.x = randf_range(xposA, xposB)
  a.rotation = rotation
  a.direction = Vector2(0, 1)
#  a.direction = Vector2(randf_range(-1, 1), 1).normalized()

