extends CanvasLayer

const SCORE_LABEL = "score: "

func update_score(score):
	$ScoreLabel.text = SCORE_LABEL + str(score)
