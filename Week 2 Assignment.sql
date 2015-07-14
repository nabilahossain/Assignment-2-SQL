# By: Nabila Hossain

# 1. What weather conditions are associated with New York City departure delays? 
#Answer: Based on the query below, some of the weather condition that associate with New York City departure delays are shown. Weather condition 
that associate with precipitation, visibility  and wind speed are rain, snow, sleet, hail, fog, storm and other windy conditions. The average delay 
per plane when there is precipitation is 28 min. When visibility is less than 6 the average delay is 25 min/flight and the wind speed > 15 is 
14 min/flight. While when there is no precipitation, visibility >=6 and wind speed <=15, the average delay per flight is 10 min.


SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) as "Total Departure Delay in Min", 
  sum(f.dep_delay)/count(f.flight)as "Average Departure Delay per Flight",
 'precipitation' as "Weather Condition"
FROM flights f LEFT JOIN weather w
ON 
  w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  where (f.origin = 'LGA' or f.origin = 'JFK')and w.precip > 0
 Union
 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) as "Total Departure Delay in Min", 
  sum(f.dep_delay)/count(f.flight)as "Average Departure Delay per Flight",
 'no precipitation' as "Weather Condition"
FROM flights f LEFT JOIN weather w
ON 
 w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  where (f.origin = 'LGA' or f.origin = 'JFK')and w.precip <= 0 
Union
 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) as "Total Departure Delay in Min", 
  sum(f.dep_delay)/count(f.flight)as "Average Departure Delay per Flight",
 'visibility >= 6' as "Weather Condition"
FROM flights f LEFT JOIN weather w
ON 
 w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  where (f.origin = 'LGA' or f.origin = 'JFK')and w.visib >= 6 
 Union
 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) as "Total Departure Delay in Min", 
  sum(f.dep_delay)/count(f.flight)as "Average Departure Delay per Flight",
 'visibility < 6' as "Weather Condition"
FROM flights f LEFT JOIN weather w
ON 
 w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  where (f.origin = 'LGA' or f.origin = 'JFK')and w.visib < 6
Union
 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) as "Total Departure Delay in Min", 
  sum(f.dep_delay)/count(f.flight)as "Average Departure Delay per Flight",
 'wind speed > 15' as "Weather Condition"
FROM flights f LEFT JOIN weather w
ON 
 w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  where (f.origin = 'LGA' or f.origin = 'JFK')and w.wind_speed > 15 
 Union
 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) as "Total Departure Delay in Min", 
  sum(f.dep_delay)/count(f.flight)as "Average Departure Delay per Flight",
 'wind speed <= 15' as "Weather Condition"
FROM flights f LEFT JOIN weather w
ON 
 w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  where (f.origin = 'LGA' or f.origin = 'JFK')and w.wind_speed <= 15
 Order By "Average Departure Delay per Flight" desc;



#2. Are older planes more likely to be delayed? 
#Answer: Based on the query below, the older planes are less likely to be delayed. Planes that are 10 years or less old seem to have an average of
 21 minutes delay per flight. While planes that are more than 20 years old seem to have an average of 14 minutes delay per flight.

SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  '<= 10' as "Years Old"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum
  Where (2013 - p.year) <= 10
Union
SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  'year between 10 and 20' as "Years"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum
  Where (2013 - p.year) between 11 and 20
  UNION
 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  '> 20' as "Years Old"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum
  Where (2013 - p.year) > 20
  Order By "Average Delay per Flight" desc;


#3. Ask (and if possible answer) a third question that also requires joining information from two or more tables in the flights database, and/or 
assumes that additional information can be collected in advance of answering your question. 
      # Question: Are older planes more likely to be delayed due to high wind speed then newer planes?
#My answer: Based on the query below, the older planes are less likely to be delayed due to high wind speed, then newer planes.

 SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  '<= 15' as "Years Old",
  '> 15' as "Wind Speed"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum LEFT JOIN weather w
 ON w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
 Where (2013 - p.year) <= 15 and w.wind_speed > 15
Union
  SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  '> 15' as "Years Old",
  '> 15' as "Wind Speed"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum LEFT JOIN weather w
ON w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  Where (2013 - p.year) > 15 and w.wind_speed > 15
Union
   SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  '<= 15' as "Years Old",
  '<= 15' as "Wind Speed"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum LEFT JOIN weather w
 ON w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
 Where (2013 - p.year) <= 15 and w.wind_speed <= 15
Union
  SELECT 
  count(f.flight) as "Total Number of Flights", 
  sum(f.dep_delay) + sum(f.arr_delay) As "Total Delay in Min",
  (sum(f.dep_delay) + sum(f.arr_delay))/count(f.flight)as "Average Delay per Flight",
  '> 15' as "Years Old",
  '<= 15' as "Wind Speed"
FROM flights f 
 LEFT JOIN planes p ON f.tailnum = p.tailnum LEFT JOIN weather w
ON w.month = f.month AND w.day = f.day AND w.hour = f.hour AND w.year = f.year
  Where (2013 - p.year) > 15 and w.wind_speed <= 15
    Order By "Average Delay per Flight" desc;
  
