extends KinematicBody2D

class_name player

export (float) var gravity = 2500.0
export (float) var speed = 100
export (float) var jump = -900
export (float) var hp = 100
export (float) var tim = 0.5
export (bool) var move = true

var dir = Vector2()
# Coyote time
var jump_bool = false

onready var spr = $spr
onready var jump_timer = $j_tim
onready var hit_col = $player_sword/col


func _ready():
	spr.play("idle")
	hit_col.disabled = true


func _physics_process(delta):
	_get_input()
	get_new_animation()
	#attack()
	_jump()
	dir.y += gravity * delta
	dir = move_and_slide(dir,Vector2(0,-1))


func _get_input():
	dir.x = 0
	
	if Input.is_action_pressed("right"):
		if is_on_floor():
			if hit_col.scale.x < 0:
				hit_col.scale.x *= -1
		dir.x = speed
	
	if Input.is_action_pressed("left"):
		if is_on_floor():
			if hit_col.scale.x > 0:
				hit_col.scale.x *= -1
		dir.x -= speed
	
	if Input.is_action_just_pressed("click"):
		attack()
		hit_col.disabled = false
	else:
		hit_col.disabled = true


func _jump():
	if is_on_floor():
		jump_bool = true
	elif jump_bool == true and jump_timer.is_stopped():
		jump_timer.start()
	
	if jump_bool and  Input.is_action_just_pressed("jump"):
		dir.y = jump


func attack():
	move = false
	yield(get_tree().create_timer(tim), "timeout")
	move = true


func get_new_animation():
	if move:
		if is_on_floor():
			if dir.x != 0:
				spr.animation = "run"
				spr.flip_h = false
				spr.flip_h = dir.x < 0
			else:
				spr.animation = "idle"
		else:
			spr.animation = "jump"
	else:
		spr.animation = "attack"


func _on_j_tim_timeout():
	jump_bool = false
