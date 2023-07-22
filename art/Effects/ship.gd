extends CharacterBody2D

@export var speed = 500
@onready var bullet = preload("res://fireball.tscn")

func _input(event):
  if event.is_action_pressed("fire"):
    var b = bullet.instantiate()
    get_tree().root.add_child(b)
    b.start($muzzle.global_position)

func _process(delta):
  var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
  velocity = dir * speed
  move_and_slide()
