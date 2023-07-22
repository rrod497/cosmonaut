extends CharacterBody2D

signal fired

@export var speed = 500

func _input(event):
  if event.is_action_pressed("fire"):
    fired.emit()

func _process(delta):
  var dir = Input.get_vector("left", "right", "forward", "backward")
  velocity = dir * speed
  move_and_slide()
