SELECT
  a.Id AS answer_id,
  a.Score AS answer_score,
  a.CreationDate AS answer_date,
  u.DisplayName AS answer_author,
  u.Reputation AS author_reputation,
  q.Id AS question_id,
  q.Title AS question_title,
  q.CreationDate AS question_date,
  q.Tags
FROM posts a
JOIN posts q ON a.Id = q.AcceptedAnswerId
LEFT JOIN users u ON a.OwnerUserId = u.Id
WHERE a.PostTypeId = 2
  AND a.Score < 0
  AND q.PostTypeId = 1
  AND q.Tags LIKE '%postgresql%'
ORDER BY a.Score ASC;