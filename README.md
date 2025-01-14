# SQL-Assignment-for-SocialHive-Company
SQL Assignment 
Company Background
SocialHive, a mid-tier social media platform with over 2 million users, enables individuals and businesses to connect through content sharing, private messaging, and user engagement analytics. As SocialHive continues to expand, its data team is tasked with providing insights that improve platform performance and user experience.
To ensure the team’s SQL proficiency, SocialHive's leadership has created real-world scenarios that test their ability to write, debug, and optimize SQL queries. These scenarios are based on real challenges encountered while managing the platform's user data.
________________________________________
Case Study Objectives
The goal is to evaluate the team’s ability to:
1.	Write efficient SQL queries.
2.	Debug flawed SQL code.
3.	Generate actionable insights from complex datasets.
4.	Apply advanced SQL concepts.
________________________________________
Data Context
SocialHive maintains the following key datasets:
1.	Users Table: Contains user profiles.
2.	Posts Table: Tracks all posts created by users.
3.	Likes Table: Logs user interactions with posts.
4.	Messages Table: Tracks private messages exchanged between users.
________________________________________


1.	Identifying Active Users
SocialHive’s marketing team wants to send a “thank you” message to all users who have interacted with the platform. Define “interaction” as posting, liking a post, or sending a message. Provide a list of users who have engaged in any of these activities.


2.	Posts Without Engagement
The product manager suspects that some posts lack proper targeting or visuals. Identify all posts that haven’t received any likes to help refine the content strategy.
3.	First-Time Liker
To analyze user behavior, SocialHive’s analytics team wants to identify users who liked a post for the first time. Generate a list of the first recorded likes for each user, along with the corresponding post.
________________________________________
Intermediate Scenarios(Attempt any 4)
4.	Top Engaged Posts
The analytics team needs to identify the top 5 most engaging posts based on the number of likes. Include the usernames of the users who created these posts to analyze content trends.
5.	Cross-Platform Influencers
SocialHive wants to identify content creators who focus solely on posting content but do not engage through messaging. Find users who have received a significant number of likes on their posts but have not sent or received any messages.
6.	User Pair Insights
A researcher studying user engagement wants to identify user pairs (sender and receiver) who have exchanged messages with each other more than 3 times.
7.	Weekly Engagement Metrics
Management needs a report summarizing the number of posts created and total likes received weekly. Focus on weeks with more than 50 posts created to identify high-activity periods.
8.	Engagement Timing
A behavioral analyst is studying user activity patterns. Identify users who liked a post within 5 minutes of its creation to understand content that drives immediate engagement.


________________________________________
Advanced Scenarios (Attempt any 1)
9.	 User Contribution Score
SocialHive wants to rank “power users” by calculating a contribution score:
1.	+2 points for each post created.
2.	+1 point for each like given.
3.	+1 point for each message sent. Generate a ranked list of users with their total contribution scores.
10.	Sentiment Analysis Pipeline
The team is building a sentiment analysis tool to train models using user messages. Extract all messages containing keywords like “great,” “happy,” or “excited.” Include the sender and receiver details for messages sent after January 2023.
________________________________________
Debugging Challenges
1. Identifying Inactive Users
•	Management wants to find users who have never interacted with the platform (no likes, posts, or messages).
•	Flawed Query:
SELECT user_id
FROM users_table
WHERE user_id NOT IN (
    SELECT DISTINCT user_id FROM likes_table
    UNION ALL
    SELECT DISTINCT sender_id FROM messages_table
    UNION ALL
    SELECT DISTINCT user_id FROM posts_table
);
•	Question:
o	Is this query correct?
o	If not, highlight the issues and suggest a fixed version.
________________________________________
2. Weekly Activity Report
•	
The analytics team needs a report showing the number of posts created and the total likes received weekly. Focus only on weeks where more than 50 posts were created.
•	Flawed Query:
SELECT 
    WEEK(created_at) AS week_number, 
    COUNT(post_id) AS total_posts, 
    (SELECT COUNT(*) FROM likes_table) AS total_likes
FROM posts_table
GROUP BY WEEK(created_at)
HAVING total_posts > 50;
•	Question:
o	Is this query correct?
o	If not, identify the issues and rewrite the query.
________________________________________
Submission Guidelines
1.	Format:
o	Submit a single .sql file containing solutions for all scenarios and debugging challenges.
o	Include comments in the .sql file to explain your corrections or optimizations.
2.	Evaluation Criteria:
o	Correctness of the queries.
o	Efficiency of the solutions.
o	Use of best practices (e.g., proper joins, indexing, and grouping).
3.	Presentation:
o	Be prepared to present and explain your solutions during the follow-up review session.

