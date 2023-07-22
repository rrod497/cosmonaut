extends Node2D

@onready var bullet = preload("res://scenes/missile.tscn")

func _on_player_fired():
  var b = bullet.instantiate()
  get_tree().root.add_child(b)
  b.start($muzzle.global_position)
