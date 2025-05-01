-- creates a stored procedure ComputeAverageWeightedScoreForUser that
-- computes and stores the average weighted score for a student
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
	DECLARE total_weighted_score FLOAT DEFAULT 0;
	DECLARE total_weight INT DEFAULT 0;
	DECLARE weighted_average_score FLOAT DEFAULT 0;

	SELECT
	SUM(corrections.score * projects.weight),
	SUM(projects.weight)
	INTO
	total_weighted_score, total_weight
	FROM
	corrections
	INNER JOIN
	projects ON corrections.project_id = projects.id
	WHERE
	corrections.user_id = user_id;

	IF total_weight > 0 THEN
		SET weighted_average_score = total_weighted_score
		/ total_weight;
	ELSE
		SET weighted_average_score = 0;
	END IF;

	UPDATE users
	SET average_score = weighted_average_score
	WHERE id = user_id;
END//

DELIMITER ;
