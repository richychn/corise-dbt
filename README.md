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

![Week 2 DAG](https://github.com/richychn/corise-dbt/blob/b9e96c9d1f99f50150a70d2ef7fbcc2813379f02/week%202%20dag.png)

5. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would set up a daily DAG to build the tables and immediately run tests after each table is built. If the tests are not passing, I would check the seriousness of the issue (whether it affects business processes) and decide whether to allow further tables to be built. I would then either fix the issue right there or create a ticket to fix it later. Regardless of the decision, I would notify stakeholders.

Regarding freshness of data, unless it would affect business processes seriously, I would also warn stakeholders and create a ticket to followup with where the data is coming from. If it is serious, I would put a hold on the tables being built and decide on a fix first. 

6. Which products had their inventory change from week 1 to week 2? 

- Monstera
- Philodendron
- Pothos
- String of pearls

# Week 3 Questions
## Part 1
1. What is our overall conversion rate?

Our overall conversion rate is 62.5%

2. What is our conversion rate by product?

NAME	CONV
String of pearls	0.609375
Arrow Head	0.555556
Cactus	0.545455
ZZ Plant	0.539683
Bamboo	0.537313
Rubber Plant	0.518519
Monstera	0.510204
Calathea Makoyana	0.509434
Fiddle Leaf Fig	0.5
Majesty Palm	0.492537
Aloe Vera	0.492308
Devil's Ivy	0.488889
Philodendron	0.483871
Jade Plant	0.478261
Spider Plant	0.474576
Pilea Peperomioides	0.474576
Dragon Tree	0.467742
Money Tree	0.464286
Orchid	0.453333
Bird of Paradise	0.45
Ficus	0.426471
Birds Nest Fern	0.423077
Pink Anthurium	0.418919
Boston Fern	0.412698
Alocasia Polly	0.411765
Peace Lily	0.409091
Ponytail Palm	0.4
Snake Plant	0.39726
Angel Wings Begonia	0.393443
Pothos	0.344262

Hypothesis: the higher conversion items might die faster.

## Part 2: Create a Macro

I created a macro called sum_events, which helps sum up a events of a certain type.

## Part 3: Post hook

Granted access to reporting role in the dbt_project.yml

## Part 4: dbt package

I am using dbt_utils and dbt_expectations. In dbt_utils, I am using the group_by macro. In dbt_expectations, I am using expect_column_values_to_be_in_set to test for the allowed values in a column.

## Part 5: dbt docs and DAG

![week 3 dag](https://github.com/richychn/corise-dbt/blob/b9e96c9d1f99f50150a70d2ef7fbcc2813379f02/Screenshot%202023-05-07%20at%204.03.11%20PM.png)

## Part 6: Snapshot

These products changed:
Bamboo
String of pearls
Monstera
Pothos
Philodendron
ZZ Plant

# Week 4 Questions
## Part 1: Snapshot
1. Which products had their inventory change from week 3 to week 4? 

Philodendron
String of pearls
Pothos
Bamboo
ZZ Plant
Monstera

2. Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? Did we have any items go out of stock in the last 3 weeks?

These products had the most fluctuations, changing 3 times in the last 3 weeks:
Philodendron
Monstera
Pothos
String of pearls 

Pothos and String of pearls went out of stock in the last 3 weeks.

## Part 2 Modeling Challenge

    SELECT
        sum(has_page_view::int) as page_views,
        sum(has_atc::int) as adds_to_cart,
        sum(has_checkout::int) as checkouts,
        sum(has_atc::int) / sum(has_page_view::int) as atc_rate,
        sum(has_checkout::int) / sum(has_atc::int) as checkout_rate
    FROM fact_user_sessions;

1. How are our users moving through the product funnel?

578 users start with a page view. Only 467 get to an add to cart, and 361 get to a checkout.

2. Which steps in the funnel have largest drop off points?

The largest drop off point is between add to cart and checkout.

## Part 3 Reflection

3A. if your organization is using dbt, what are 1-2 things you might do differently / recommend to your organization based on learning from this course?

Our organization does not strictly follow the Kimball dimensional modeling method. Although there are complications to using that method in our business, it could help make models clearer to first time analysts. Coincidentally, we acquired a company after I started this course that does follow the Kimball dimensional modeling method, but does not use dbt. This course helped me understand what was going on in their data warehouse. 

Our organization uses most of the other coursework already, which was fun to learn properly about, since I had a little exposure already. 
