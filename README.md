# Analytics engineering with dbt

Template repository for the projects and environment of the course: Analytics engineering with dbt

> Please note that this sets some environment variables so if you create some new terminals please load them again.

## License
GPL-3.0

# Week 1 Questions

1. How many users do we have?

130

2. On average, how many orders do we receive per hour?

7.68 orders per hour

3. On average, how long does an order take from being placed to being delivered?

93.4 hours

4. How many users have only made one purchase? Two purchases? Three+ purchases?

25 users have made 1 purchase. 28 users have made 2 purchases. 71 users have made three or more purchases.

5. On average, how many unique sessions do we have per hour?

10.1 sessions per hour

# Week 2 Questions

1. What is our user repeat rate?

79.8%

    with counts as (
        SELECT 
            user_id,
            count(distinct order_id) as orders
        FROM orders
        GROUP BY 1
    ),

    repeat_user as (
        SELECT
            CASE WHEN orders > 1 THEN 1
            WHEN orders = 1 THEN 0
            END AS repeat_user,
            user_id
        FROM counts
    )

    SELECT
        sum(repeat_user) / count(user_id)
    FROM repeat_user

2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

I would look into repeat purchase patterns by product and by size of first order. 

If I had more data, I might want to know some demographic information, such as age and gender. 

3. Explain the product mart models you added. Why did you organize the models in the way you did?

I created a fact_product_summary model for the product mart. This model allows users to get time series and snapshots of all events related to a product, so the user can track conversion performance related to the product.

I also created two other core models (fact_user_session and fact_orders) that allow users to look at user level conversion performance and order sizes.

4. Use the dbt docs to visualize your model DAGs to ensure the model layers make sense.

![Week 2 DAG](/week 2 dag.png)

5. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would set up a daily DAG to build the tables and immediately run tests after each table is built. If the tests are not passing, I would check the seriousness of the issue (whether it affects business processes) and decide whether to allow further tables to be built. I would then either fix the issue right there or create a ticket to fix it later. Regardless of the decision, I would notify stakeholders.

Regarding freshness of data, unless it would affect business processes seriously, I would also warn stakeholders and create a ticket to followup with where the data is coming from. If it is serious, I would put a hold on the tables being built and decide on a fix first. 

6. Which products had their inventory change from week 1 to week 2? 
- Monstera
- Philodendron
- Pothos
- String of pearls