extends CharacterBody2D

signal fired
signal destroyed
signal damaged

@export var speed = 500
@export var hp = 3
@export var alive = true

func _input(event):
  if !alive: return
  if event.is_action_pressed("fire"):
    fired.emit()

func _process(delta):
  if !alive: return
  var dir = Input.get_vector("left", "right", "forward", "backward")
  velocity = dir * speed
  move_and_slide()

func destroy():
  if !alive: return
  alive = false
  destroyed.emit()
  set_deferred("monitoring", false)
  $collider.set_deferred("disabled", true)
  $anime.play("destroy")
  await $anime.animation_finished
  queue_free()

func damage():
  if !alive: return
  hp -= 1
  if hp > 0:
    $anime.play("damage")
  else:
    destroy()
