-- Identifying Active Users
-- SocialHive’s marketing team wants to send a “thank you” message to all users who have interacted with the platform. Define “interaction” as posting, liking a post, or sending a message. Provide a list of users who have engaged in any of these activities.
select u.user_id,u.username from socialhive.users u
join socialhive.posts p
on u.user_id = p.user_id
join socialhive.likes l
on u.user_id = l.user_id
where liked_at is not null

-- Posts Without Engagement
-- Identify all posts that haven’t received any likes to help refine the content strategy.
select p.post_id,p.user_id,u.username
from socialhive.users u
join socialhive.posts p
on u.user_id = p.user_id
join socialhive.likes l
on u.user_id = l.user_id
where p.post_id is not null
 
 
 -- Generate a list of the first recorded likes for each user, along with the corresponding post.
select p.post_id,p.content,p.user_id,u.username
from socialhive.users u
join socialhive.posts p
on u.user_id = p.user_id
join socialhive.likes l
on u.user_id = l.user_id
where p.post_id is not null 

-- Top Engaged Posts
-- The analytics team needs to identify the top 5 most engaging posts based on the number of likes. 
-- Include the usernames of the users who created these posts to analyze content trends
select p.post_id,p.content,p.user_id,u.username
from socialhive.users u
join socialhive.posts p
on u.user_id = p.user_id
join socialhive.likes l
on u.user_id = l.user_id
where p.post_id is not null 
ORDER BY l.like_id DESC
LIMIT 5;

-- Cross-Platform Influencers
-- SocialHive wants to identify content creators who focus solely on posting content but do not engage through messaging. 
-- Find users who have received a significant number of likes on their posts but have not sent or received any messages.
SELECT u.user_id, u.username, SUM(l.like_id) AS total_likes
FROM socialhive.users u
JOIN socialhive.posts p ON u.user_id = p.user_id
JOIN socialhive.likes l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username
HAVING total_likes >= 5

-- User Pair Insights
-- A researcher studying user engagement wants to identify user pairs (sender and receiver) who have exchanged messages with each other more than 3 times.
SELECT 
    LEAST(m.sender_id, m.receiver_id) AS user_1,
    GREATEST(m.sender_id, m.receiver_id) AS user_2,
    COUNT(*) AS message_count
FROM socialhive.messages m
GROUP BY user_1, user_2
HAVING message_count > 3
ORDER BY message_count DESC;

-- Weekly Engagement Metrics
-- Management needs a report summarizing the number of posts created and total likes received weekly. 
-- Focus on weeks with more than 50 posts created to identify high-activity periods.
SELECT
    YEAR(p.created_at) AS year,
    WEEK(p.created_at) AS week,
    COUNT(p.post_id) AS total_posts
FROM socialhive.posts p
GROUP BY year, week
HAVING total_posts > 50
ORDER BY year DESC, week DESC;


-- Engagement Timing
-- A behavioral analyst is studying user activity patterns. 
-- Identify users who liked a post within 5 minutes of its creation to understand content that drives immediate engagement.
SELECT
    l.user_id AS liker_user_id,
    p.user_id AS post_creator_user_id,
    p.post_id,
    p.created_at AS post_created_at,
    l.liked_at AS like_time
FROM socialhive.likes l
JOIN socialhive.posts p ON l.post_id = p.post_id
WHERE TIMESTAMPDIFF(SECOND, p.created_at, l.liked_at) <= 300  
ORDER BY l.liked_at;

-- User Contribution Score
-- SocialHive wants to rank “power users” by calculating a contribution score:
-- +2 points for each post created.
-- +1 point for each like given.
-- +1 point for each message sent. Generate a ranked list of users with their total contribution scores.
SELECT u.user_id,u.username,  
    COALESCE(COUNT(DISTINCT p.post_id) * 2, 0) +  
    COALESCE(COUNT(DISTINCT l.like_id), 0) +  
    COALESCE(COUNT(DISTINCT m.message_id), 0) AS contribution_score
FROM socialhive.users u
LEFT JOIN socialhive.posts p ON u.user_id = p.user_id  
LEFT JOIN socialhive.likes l ON u.user_id = l.user_id  
LEFT JOIN socialhive.messages m ON u.user_id = m.sender_id  
GROUP BY u.user_id, u.username
ORDER BY contribution_score DESC; 

-- Debugging Challenges
-- 1. Identifying Inactive Users
-- Management wants to find users who have never interacted with the platform (no likes, posts, or messages).
-- Flawed Query:
SELECT user_id
FROM socialhive.users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id FROM socialhive.likes
    UNION ALL
    SELECT DISTINCT sender_id FROM socialhive.messages
    UNION ALL
    SELECT DISTINCT user_id FROM socialhive.posts
);


-- 2. Weekly Activity Report
-- The analytics team needs a report showing the number of posts created and the total likes received weekly. 
-- Focus only on weeks where more than 50 posts were created.
-- Flawed Query:
SELECT 
    WEEK(created_at) AS week_number, 
    COUNT(post_id) AS total_posts, 
    (SELECT COUNT(*) FROM socialhive.likes) AS total_likes
FROM socialhive.posts
GROUP BY WEEK(created_at)
HAVING total_posts > 50;