*****************************

*        %1 e.g. "n0"                    the regional level of the supercategory of the regions that should be filled. i.e. either n0 or n1_2
*        $2 e.g. "h2"                    the hierarchical level of the supercategory of the cropcategories that should be filled, i.e. either h0, h1, h2 or h3


*****************************

*                    | b_1 b_2 b_3 b_4 | SUM                                         where:                            here, the supercategory of the regions
*     e.g          __|_________________|___                                                                            would be "SK", and therefore %1 "n0".
*               SK01 |                 | data("SK01", "AGRAREA")                d1 = data("SK", "b_1")                 the supercategory of the cropcategories
*               SK02 |                 | data("SK02", "AGRAREA")                d2 = data("SK", "b_2")                 would be "AGRAREA", and %2 "h0"
*               SK03 |                 | data("SK012, "AGRAREA")                d3 = data("SK", "b_3")
*               SK04_|_________________|_data("SK012, "AGRAREA")                d4 = data("SK", "b_4")                 interior of table: data(sub_regions, sub_cropcategories)
*                SUM | d1  d2  d3  d4  | data_n0("SK", "AGRAREA")                                                      super_region = "SK", super_cropcategories = "AGRAREA"
*
** the sums are given, the interior of the table can be everything between completly filled and completly empty
** to use a solve statement, we need startvalues in the interior of the table. Therefore, this program distributes
** missing area on data.l in each row (missing area = real row sum - needed row sum (e.g. data("SK01", "AGRAREA"))),
** using the column sums as shares.

*****************************


super_region(all_reg) = NO;
super_cropcategory(croptypes) = NO;

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
);


sub_regions(all_reg) = NO;
sub_cropcategories(croptypes) = NO;


if(sameas("%1", "n0"),
     sub_regions(n1_2) = YES $ nuts_mappings(super_region, n1_2);
     elseif sameas("%1", "n1_2"),
         sub_regions(n2_3) = YES $ nuts_mappings(super_region, n2_3);
);

if(sameas("%2", "h0"),
     sub_cropcategories(hierarchy_1) = YES $ hierarchy_mappings(super_cropcategory, hierarchy_1);
     elseif sameas("%2", "h1"),
         sub_cropcategories(hierarchy_2) = YES $ hierarchy_mappings(super_cropcategory, hierarchy_2);
         elseif sameas("%2", "h2"),
             sub_cropcategories(hierarchy_3) = YES $ hierarchy_mappings(super_cropcategory, hierarchy_3);
             elseif sameas("%2", "h3"),
                 sub_cropcategories(hierarchy_4) = YES $ hierarchy_mappings(super_cropcategory, hierarchy_4);
);


display super_region, super_cropcategory, sub_regions, sub_cropcategories;



loop(sub_regions,
     needed_sum_row = v_data.lo(sub_regions, super_cropcategory);
     sum_row = sum(sub_cropcategories, v_data.lo(sub_regions, sub_cropcategories));
     sum_for_shares = sum(sub_cropcategories $ (v_data.lo(sub_regions, sub_cropcategories) ne v_data.up(sub_regions, sub_cropcategories)), v_data.lo(super_region, sub_cropcategories));
     if(((needed_sum_row - sum_row ne 0) AND sum_for_shares = 0),
         v_data.l(sub_regions, sub_cropcategories) = v_data.lo(sub_regions, sub_cropcategories);
         v_data.lo(sub_regions, sub_cropcategories) = 0;
         v_data.up(sub_regions, sub_cropcategories) = inf;
     elseif(needed_sum_row - sum_row ne 0),
         loop(sub_cropcategories $ (v_data.lo(sub_regions, sub_cropcategories) ne v_data.up(sub_regions, sub_cropcategories)),
             v_data.l(sub_regions, sub_cropcategories) = (needed_sum_row - sum_row) * (v_data.lo(super_region, sub_cropcategories) / sum_for_shares)
         );
     );
);


p_data(all_reg, croptypes) = v_data.l(all_reg, croptypes);    

solve taloe USING NLP MINIMIZING v_hpd;