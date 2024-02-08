extends CanvasLayer

const SCORE_LABEL = "treats monched: "

func update_score(score):
	$ScoreLabel.text = SCORE_LABEL + str(score)
