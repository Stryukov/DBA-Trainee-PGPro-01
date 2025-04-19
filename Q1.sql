WITH questions AS (
  SELECT
    q.Id AS question_id,
    q.CreationDate AS question_time,
    unnest(string_to_array(trim(BOTH '|' FROM q.Tags), '|')) AS tag,
    q.AcceptedAnswerId,
    q.OwnerUserId
  FROM posts q
  WHERE q.PostTypeId = 1 AND q.Tags LIKE '%postgresql%'
),
answers AS (
  SELECT Id, CreationDate, ParentId, OwnerUserId
  FROM posts
  WHERE PostTypeId = 2
),
qa AS (
  SELECT
    q.question_id,
    q.tag,
    q.question_time,
    a.Id AS answer_id,
    a.CreationDate AS answer_time,
    EXTRACT(EPOCH FROM (a.CreationDate - q.question_time)) / 60 AS response_minutes,
    u.Reputation AS user_reputation
  FROM questions q
  JOIN answers a ON a.Id = q.AcceptedAnswerId
  LEFT JOIN users u ON u.Id = a.OwnerUserId
  WHERE q.OwnerUserId IS DISTINCT FROM u.Id
),
aggregated AS (
  SELECT
    tag,
    COUNT(*) AS question_count,
    ROUND(AVG(response_minutes), 2) AS avg_response_minutes,
    ROUND(AVG(user_reputation), 2) AS avg_user_reputation
  FROM qa
  WHERE tag <> 'postgresql'
  GROUP BY tag
)
SELECT *
FROM aggregated
WHERE avg_response_minutes < 250000
ORDER BY question_count DESC;
