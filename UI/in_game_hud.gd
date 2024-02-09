extends CanvasLayer

const SCORE_LABEL = "treats monched: "
const HEALTH_LABEL = "health: "

func update_score(score):
	$ScoreLabel.text = SCORE_LABEL + str(score)

func update_health(health):
	$HealthLabel.text = HEALTH_LABEL + str(health)
