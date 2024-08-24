extends Node

#FINALLY HEALTH
var score = 0

#song info
@export var bpm: float
@export var crotchetsperbar: int
@export var songlengthbeats: int
@export var leveldata: Node
@export var perfectscore: int
var chart
var crotchet

@export var clown: Node
@export var you: Node
@export var Subtitles: Node
@export var SongTitle: Node
@export var txtscore: Node
@export var finalscore: Node

@export var frown: Node
@export var tick: Node

#where are we
var songposition
var currentbar = 0
var currentcrotchet = -1
var realcurrentcrotchet = 0
var lastcrotchet = 0.0
var time_begin
var time_delay

var lasthit = 0

#modifiers
var inputoffset = 0.5
var lenience = 0.3 #plus or minus in seconds
#var pitch #pitch is technically speed for a possible hard mode?

#cueing stuff
var lastcue = -999
var lastpulse = -999

func clown_pulse():
	$Drumstick.play()
	Subtitles.text += chart[currentbar][realcurrentcrotchet]

func miss():
	$Cough.play()
	frown.restart()
	frown.emitting = true
	score-=1

# Called when the node enters the scene tree for the first time.
func _ready():
	chart = leveldata.chart
	
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
	$Song.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	songposition = (Time.get_ticks_usec() - time_begin) / 1000000.0
	songposition -= time_delay
	songposition = max(0, songposition)
	
	crotchet = 60.0/bpm
	
	if songposition > lastcrotchet + crotchet and songposition > 0:
		lastcrotchet += crotchet
		currentcrotchet += 1
		currentbar = floor(currentcrotchet / crotchetsperbar)
		realcurrentcrotchet = currentcrotchet % crotchetsperbar
	
	if currentcrotchet < songlengthbeats: # if in game
		if chart[currentbar][realcurrentcrotchet] != null and lastpulse < currentcrotchet and currentcrotchet >= 0:
			lastpulse = currentcrotchet
			if currentbar%2==0:
				clown_pulse()
			else:
				# GIVE PLAYER A CUE!!
				$Kick.play()
				pass
	
		# end of bar cue
		if realcurrentcrotchet==7 and lastcue < currentcrotchet - 7:
			lastcue = currentcrotchet
			Subtitles.text = ""
			$Triangle.play()
			if chart[currentbar][8]:
				$Laughter.play()
		txtscore.text = "score: "+str(score)
	else:
		Subtitles.hide()
		SongTitle.hide()
		txtscore.hide()
		
		var comment
		
		if score<=0:
			comment = "Try Again..."
		elif score<=60:
			comment = "OK"
		elif score<=perfectscore:
			comment = "Superb!"
		elif score>=perfectscore:
			comment="Perfect!"
		
		finalscore.text = 'Score:\n'+str(score)+"\n"+comment
		finalscore.show()
		
		if currentcrotchet > songlengthbeats + 16:
			get_tree().root.get_node("TitleScreen").show()
			get_tree().root.get_node("Node2D").free()

func _input(event):
	if event.is_action_pressed("Press") and currentcrotchet < songlengthbeats:
		var press = songposition/crotchet
		var lastinput = chart[currentbar][realcurrentcrotchet]
		var nextinput = chart[floor((currentcrotchet+1) / crotchetsperbar)][(currentcrotchet+1) % crotchetsperbar]
		
		if (lastinput!=null and press<floor(press)+lenience and floor(press)!=lasthit and currentbar%2!=0):
				#print("LPERFECT")
				lasthit = floor(press)
				score+=1
				tick.restart()
				tick.emitting = true
				$Sidestick.play()
				Subtitles.text += chart[currentbar][realcurrentcrotchet]
		elif (nextinput!=null and press>floor(press+1)-lenience and floor(press+1)!=lasthit and floor((currentcrotchet+1) / crotchetsperbar)%2!=0):
					#print("EPERFECT")
					lasthit = floor(press+1)
					score+=1
					tick.restart()
					tick.emitting = true
					$Sidestick.play()
					Subtitles.text += chart[floor((currentcrotchet+1) / crotchetsperbar)][(currentcrotchet+1) % crotchetsperbar]
		else:
			miss()
