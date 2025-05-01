-- creates a stored procedure ComputeAverageWeightedScoreForUsers that
-- computes and stores the average weighted score for all students
DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
	UPDATE users user
	SET average_score = (
		SELECT
		COALESCE(
			SUM(corrections.score * projects.weight) /
			NULLIF(SUM(projects.weight), 0), 0
		)
		FROM
		corrections
		JOIN
		projects ON corrections.project_id = projects.id
		WHERE
		corrections.user_id = user.id
	);
END//

DELIMITER ;
