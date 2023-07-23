class_name GameState
extends Node2D

@export var player : Player
@export var action : ActionScene
@export var minerals = {
  Mineral.Kind.Bronze: 0,
  Mineral.Kind.Silver: 0,
  Mineral.Kind.Gold: 0,
}
#@export var weapons : Array[Weapon]
