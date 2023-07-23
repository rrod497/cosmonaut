extends Area2D

@export var prefs : ProjectilePrefs
@onready var damage = prefs.damage
@onready var _speed = prefs.speed
var _dir = Vector2(0,-1)

func start(pos, dir):
  global_position = pos
  _dir = dir.normalized()
#  position = pos
  $spawn.emitting = true

func _process(delta):
  position += delta * _dir * _speed

func _on_visible_screen_exited():
  queue_free()

func _on_area_entered(area):
  destroy()

func destroy():
  _speed = 0
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $explosion.emitting = true
  $anime.play("destroy")
  await $anime.animation_finished
  queue_free()
