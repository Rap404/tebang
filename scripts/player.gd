extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing_sword: AudioStreamPlayer2D = $swingSword
@onready var hitbox: Area2D = $Hitbox

const SPEED = 200.0
const SPRINT_SPEED = 400.0 # Kecepatan saat sprint (sesuaikan kebutuhan)

var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var hitbox_offset: Vector2
var strength: int = 20

func _ready() -> void:
	
	#Initialize hitbox offset
	hitbox_offset = hitbox.position
	hitbox.monitoring = false

func _physics_process(_delta: float) -> void:
	
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
	
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	process_movement()
	process_animation()
	move_and_slide()

#-------------------------------------
# MOVEMENT & ANIMATION
#-------------------------------------

func process_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	# Cek apakah tombol sprint sedang ditahan
	var current_speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
	
	if direction != Vector2.ZERO:
		velocity = direction * current_speed
		last_direction = direction
		update_hitbox()
	else:
		velocity = Vector2.ZERO

func process_animation() -> void:
	if is_attacking:
		return
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play(prefix + "_right")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_down")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")

#-------------------------------------
# ATTACKING
#-------------------------------------

func attack() -> void:
	is_attacking = true
	hitbox.monitoring = true
	swing_sword.play()
	play_animation("attack", last_direction)


func _on_animated_sprite_2d_animation_finished() -> void:
	hitbox.monitoring = false
	if is_attacking:
		is_attacking = false
		

#-------------------------------------
# HITBOX
#-------------------------------------

func update_hitbox() -> void:
	var x := hitbox_offset.x
	var y := hitbox_offset.y
	
	match last_direction:
		Vector2.LEFT:
			hitbox.position = Vector2(-x, y)
		Vector2.RIGHT:
			hitbox.position = Vector2(x, y)
		Vector2.UP:
			hitbox.position = Vector2(y, -x)
		Vector2.DOWN:
			hitbox.position = Vector2(-y, x)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_attacking and body.name.begins_with("Slime"):
		print("Hit!")
		body.take_damage(strength, position)
