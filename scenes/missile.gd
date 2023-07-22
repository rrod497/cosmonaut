extends Area2D

@export var speed = 600

func start(pos):
  position = pos
  $spawn.emitting = true

func _process(delta):
  position.y -= delta * speed

func _on_visible_screen_exited():
  queue_free()
