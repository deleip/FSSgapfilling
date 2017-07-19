************* filling data gaps in agricultural data *************

$onlisting
$stars $$$$


$include "C:\Users\Debbora\jrc\incl_d\display\croptypes_sum.txt"
$include "C:\Users\Debbora\jrc\incl_d\display\croptypes.txt"

set hierarchy_0(croptypes) /AGRAREA/;
set hierarchy_1(croptypes) /'B_1','B_2','B_3', 'B_4'/;
set hierarchy_2(croptypes) /'B_1_1','B_1_2' ,'B_1_3' ,'B_1_4','B_1_5','B_1_6','B_1_7','B_1_8', 'B_1_9','B_1_10','B_1_11','B_1_12'
                            'B_3_1','B_3_2' ,'B_3_3'
                            'B_4_1','B_4_2' ,'B_4_3' ,'B_4_4','B_4_5','B_4_6','B_4_7'
                            'B_5_1','B_5_2','B_5_3'/;
set hierarchy_3(croptypes) /'B_1_1_1','B_1_1_2','B_1_1_3','B_1_1_4', 'B_1_1_5','B_1_1_6','B_1_1_7','B_1_1_99'
                            'B_1_2_1','B_1_2_2'
                            'B_1_6_1','B_1_6_2','B_1_6_3' ,'B_1_6_4' ,'B_1_6_5' ,'B_1_6_6', 'B_1_6_7','B_1_6_8','B_1_6_9' ,'B_1_6_10','B_1_6_11','B_1_6_12',  'B_1_6_99'
                            'B_1_7_1','B_1_7_2'
                            'B_1_8_1','B_1_8_2'
                            'B_1_9_1','B_1_9_2'
                            'B_1_12_1','B_1_12_2'
                            'B_4_1_1_1','B_4_1_1_2'
                            'B_4_3_1','B_4_3_2'
                            'B_4_4_1','B_4_4_2','B_4_4_3', 'B_4_4_4'/;
set hierarchy_4(croptypes) /'B_1_7_1_1','B_1_7_1_2'
                            'B_1_9_2_1','B_1_9_2_2','B_1_9_2_99'
                            'B_4_1_1_1','B_4_1_1_2'/;


set hierarchy_mappings(croptypes, croptypes) /
$include "C:\Users\Debbora\jrc\incl_d\crop_sets_d.txt"
/;

*regions
$include "C:\Users\Debbora\jrc\incl_d\display\all_reg_sum.txt"
$include "C:\Users\Debbora\jrc\incl_d\display\all_reg.txt"
$include "C:\Users\Debbora\jrc\incl_d\n0.txt"
$include "C:\Users\Debbora\jrc\incl_d\n1_2.txt"
$include "C:\Users\Debbora\jrc\incl_d\n2_3.txt"
*mappings between different region levels
$include "C:\Users\Debbora\jrc\incl_d\nuts_mappings.txt"


parameter p_data(all_reg_sum, croptypes_sum);
variable v_data(all_reg, croptypes);
execute_load "C:\Users\Debbora\jrc\tests\complete_run\data_8.gdx" v_data;

singleton set region(all_reg) /AT22/;
singleton set croptype(croptypes) /b_1_9/;

p_data(region, croptype) = v_data.l(region, croptype);
p_data(all_reg, croptype) $ nuts_mappings(region, all_reg) = v_data.l(all_reg, croptype);
p_data(region, croptypes)  $ hierarchy_mappings(croptype, croptypes) = v_data.l(region, croptypes);
p_data(all_reg, croptypes)  $ (nuts_mappings(region, all_reg) AND hierarchy_mappings(croptype, croptypes))
         = v_data.l(all_reg, croptypes);

p_data("summe", croptype) = sum(all_reg $ nuts_mappings(region, all_reg), p_data(all_reg, croptype));
p_data("summe", croptypes) $ hierarchy_mappings(croptype, croptypes) = sum(all_reg $ nuts_mappings(region, all_reg), p_data(all_reg, croptypes));
p_data(region, "summe") = sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(region, croptypes));
p_data(all_reg, "summe") $ nuts_mappings(region, all_reg) =  sum(croptypes $ hierarchy_mappings(croptype, croptypes), p_data(all_reg, croptypes));

display p_data;
