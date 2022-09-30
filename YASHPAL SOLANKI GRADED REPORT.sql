use prod;

select * from auto_insurance_risk;

    select count(*) from auto_insurance_risk;
    select count (IDpol) from auto_insurance_risk;
    select count(IDpol) from auto_insurance_risk where claim_flag>0;
	/*(34060/678013)*100 = 5.235% (0.050235)*/
    

    ALTER TABLE auto_insurance_risk ADD claim_flag INTEGER;
    UPDATE auto_insurance_risk SET claim_flag =
     CASE when ClaimNb > 0 then 1 else 0
	 END;
     
    
/*3.1*/    select avg(Exposure) from auto_insurance_risk where claim_flag = 1;           /*(Average=0.6425)*/

/*3.2* We obtain an average exposure of 0.6425 for those who have claimed. We can group by claim_flag to obtain averages of 0 and >0 conditions.
    The sql query would be: */
	
           select claim_flag,avg(Exposure) from auto_insurance_risk GROUP BY claim_flag; 
	
    /* for 0 its 0.5227 and for >0 its 0.6425) */
	#Here we can infer that the average of those who claimed once is higher than that of zero claims.
    
    
/* 4.1    First we need to create a column of Exposure bucket. Then set the values using switch case */
         ALTER TABLE auto_insurance_risk ADD expBucket VARCHAR(100);
	     UPDATE auto_insurance_risk SET expBucket =
           CASE when Exposure >= 0 and Exposure <=0.25 then "E1"
				   when Exposure >= 0.26 and Exposure <=0.50 then "E2"
				   when Exposure >= 0.51 and Exposure <=0.75 then "E3"
				   when Exposure >= 0.76 then "E4"
				   END;

/* now we GROUP BY and find percentages. Multiplying 100 wasnt giving 100% sum so I divided denominator by it and that brought proper decimals. */

 select expBucket,count(ClaimNb),(count(ClaimNb)/6780.13) from auto_insurance_risk GROUP BY expBucket;
/*4.2   We can infer from here that E4 and E1 having 34.1298% and 32.86% are largest and second largest respectively.*/


/* 5 */   select area,count(ClaimNb),count(ClaimNb)/6780.13 'Percent' from auto_insurance_risk GROUP BY area order by count(ClaimNb) desc;

/*6.*/    select area,expBucket,sum(claim_flag)/6780.13 'Claim_Rate' ,sum(ClaimNb) from auto_insurance_risk
          GROUP BY Area,expBucket ORDER BY sum(ClaimNb) desc;
          
		 /* Here from the output we can observe that when claims are arranged in descending order , E4 is the maximum followed by E1, E2 and E3.
	      In 4.2 also we saw similar trend where E4 was max followed by E1.*/
	
		   select claim_flag,avg(VehAge) from auto_insurance_risk group by claim_flag;
/* 7.1     Observation: Here from the output we can see that those who did not claim have higher vehicle age than those who claimed*/
        
        
           select claim_flag,Area,avg(VehAge) from auto_insurance_risk  group by Area having claim_flag;
/* 7.2     Observation: We can see the pattern ABCDEF in decreasing order of Vehicle Age.*/
	
           select claim_flag, expBucket,avg(VehAge) from auto_insurance_risk GROUP BY expBucket,claim_flag;
/*8        Observation: In all the categories of exposure buckets, the vehicle age of those who have claimed is always lesser than that of not claimed.*/

/*9.1*/    ALTER TABLE auto_insurance_risk ADD Claim_ct VARCHAR(100);
	       UPDATE auto_insurance_risk SET Claim_ct =
           CASE when ClaimNb=1 then "1 Claim"
	       when ClaimNb>1 then "MT 1 Claims"
		   when ClaimNb=0 then "No Claims"    
	       END;
           
           
	       select Claim_ct, avg(BonusMalus) from auto_insurance_risk group by Claim_ct;
/*9.2      We can see from the output that Average bonusMalus is highest for MT 1 Claims , followed by 1 Claim and No Claims.*/


		   select Claim_ct, avg(Density) from auto_insurance_risk group by Claim_ct;
/*10           We can observe that Average density is higher for those having more than one 1 claims ( MT 1 Claims) followed by only 1 Claim and No claims are least.*/


           select VehBrand,VehGas,avg(ClaimNb) from auto_insurance_risk
           GROUP BY VehBrand, VehGas ORDER BY avg(ClaimNb) desc;
/*11	       Vehicle Brand B12 having Regular Vehicle Gas have highest average claims.*/
	
          select Region,Exposure,count(claim_flag)/6780.13 'claim_rate' from auto_insurance_risk
          GROUP BY Region,Exposure ORDER BY count(claim_flag)/6780.13 desc limit 5;
/*12	  The top 5 regions are R24,R82,R53,R52 and R93*/
	
    
/*13.2    Firstly we need to create age category column so doing 13.2 first */
          ALTER TABLE auto_insurance_risk ADD AgeCategory VARCHAR(100);
	      UPDATE auto_insurance_risk SET AgeCategory =
          CASE when DrivAge=18 then "1-Beginner"
	         when DrivAge>18 AND DrivAge<=30 then "2-Junior"
		     when DrivAge>30 AND DrivAge<=45 then "3-Middle Age"
		     when DrivAge>45 AND DrivAge<=60 then "4-Mid Senior"
			 when DrivAge>60 then "5-Senior"
	  END;
	  
		  select AgeCategory, avg(BonusMalus) from auto_insurance_risk group by AgeCategory;
/*	      We can see avg(BonusMalus) for 1-Beginner is higher than 5-Senior. Bonus is reward and Malus is the penalty.
	      This is due to the age and experience in driving. Caution is taken when senior age categories are driving.*/
	  
          select claim_flag,count(claim_flag) from auto_insurance_risk
          where AgeCategory="1-Beginner" group by claim_flag; 
/*          Observation : Here we can see 61 cases of illegal driving.*/

_________CONCEPTUAL QUESTIONS______________________________________________________________________

14. The main difference between unique and primary key is that the primary key is distinct for a table that is only one to be used.
    It does not accept any duplicate OR NULL values. A unique constraint contains unique values and a table can hold more than one unique KEY
	but it is not necessary to have a unique key in the table. Unique can contain NULL values but limited to only one.
	
15. We will obtain 50 records of data ( 5 * 10 ).

16. Difference between Inner Join and Left Outer Join 
    In Inner Join, two or more tables are combined having atleast one common attribute and combined data is obtained. We wont be obtaining
	anything if the tables dont have anything in common.
	Left Outer Join will return all the records from Left Table i.e, Table 1 and similar/matching records from the right table.
	
17. We will obtain 25 records.

18. DIFFERENCE BETWEEN HAVING AND WHERE CLAUSE:
    Where clause gives the records from the table on the given conditions. It can be used without GROUP BY.
	Having clause gives the records from the groups based on given conditions. It necessarily requires GROUP BY
