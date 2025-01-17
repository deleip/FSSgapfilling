*****************************

*        %1 e.g. "n0"                    the regional level of the supercategory of the regions that should be filled. i.e. either n0 or n1_2
*        %2 e.g. "h2"                    the hierarchical level of the supercategory of the cropcategories that should be filled, i.e. either h0, h1, h2 or h3


*****************************
*                    sub_cropcategories  super_cropcategory
*                    | b_1 b_2 b_3 b_4 | AGRAREA                                     where:                            here, the supercategory of the regions
*     e.g          __|_________________|___                                                                            would be "SK", and therefore %1 "n0".
*               SK01 |                 | data("SK01", "AGRAREA")                d1 = data("SK", "b_1")                 the supercategory of the cropcategories
*  sub_regions  SK02 |                 | data("SK02", "AGRAREA")                d2 = data("SK", "b_2")                 would be "AGRAREA", and %2 "h0"
*               SK03 |                 | data("SK012, "AGRAREA")                d3 = data("SK", "b_3")
*               SK04_|_________________|_data("SK012, "AGRAREA")                d4 = data("SK", "b_4")                 interior of table: data(sub_regions, sub_cropcategories)
*  super_region  SK  | d1  d2  d3  d4  | data_n0("SK", "AGRAREA")                                                      super_region = "SK", super_cropcategories = "AGRAREA"
*
** the sums are given, the interior of the table can be everything between completly filled and completly empty
** to use a solve statement, we need startvalues in the interior of the table. Therefore, this program first distributes
** missing area on data.l in each row (missing area = real row sum - needed row sum (e.g. data("SK01", "AGRAREA"))),
** using the column sums as shares and then solves the table.

*****************************



* first we have to find out how the table looks like, i.e. fill the sets for sub/super regions/cropcategories correctly!
super_region(all_nuts) = NO;
super_cropcategory(cropcategories) = NO;

if(sameas("%1", "n0"),
     super_region(n0) = YES;
     elseif sameas("%1", "n1_2"),
         super_region(n1_2) = YES
);

if(sameas("%2", "h0"),
     super_cropcategory(hierarchy_0) = YES;
     elseif sameas("%2", "h1"),
         super_cropcategory(hierarchy_1) = YES;
         elseif sameas("%2", "h2"),
             super_cropcategory(hierarchy_2) = YES;
             elseif sameas("%2", "h3"),
                 super_cropcategory(hierarchy_3) = YES;
                 elseif sameas("%2", "h4"),
                     super_cropcategory(hierarchy_4) = YES;
);


sub_regions(all_nuts) = NO;
sub_cropcategories(cropcategories) = NO;

sub_regions(all_nuts) = YES $ nuts_mappings(super_region, all_nuts);
sub_cropcategories(cropcategories) = YES $ hierarchy_mappings(super_cropcategory, cropcategories);




* next we have to find startvalues
loop(sub_regions,
     needed_sum_row = v_data_nuts.l(sub_regions, super_cropcategory);
     sum_row = sum(sub_cropcategories, v_data_nuts.l(sub_regions, sub_cropcategories));
     sum_for_shares_row = sum(sub_cropcategories $ (p_std_nuts(sub_regions, sub_cropcategories) = 0.05), v_data_nuts.l(super_region, sub_cropcategories));
     if((sum_for_shares_row ne 0) AND (needed_sum_row - sum_row gt 0),
         loop(sub_cropcategories $ (p_std_nuts(sub_regions, sub_cropcategories) = 0.05),
             v_data_nuts.l(sub_regions, sub_cropcategories) = v_data_nuts.l(sub_regions, sub_cropcategories) +
                         (needed_sum_row - sum_row) * (v_data_nuts.lo(super_region, sub_cropcategories) / sum_for_shares_row)
         );
     );
);


* and now we can solve
p_data_nuts(all_nuts, cropcategories) = v_data_nuts.l(all_nuts, cropcategories);

solve single_table USING NLP MINIMIZING v_hpd;

* after solving we need to fix the results, as we need them for filling the next level
v_data_nuts.fx(sub_regions, sub_cropcategories) = v_data_nuts.l(sub_regions, sub_cropcategories);

