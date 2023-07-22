extends Area2D

@export var speed = 600

func start(pos):
  position = pos
  $spawn.emitting = true

func _process(delta):
  position.y -= delta * speed

func _on_visible_screen_exited():
  queue_free()


func _on_area_entered(area):
  destroy()

func destroy():
  speed = 0
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $explosion.emitting = true
  $anime.play("destroy")
  await $anime.animation_finished
  queue_free()
