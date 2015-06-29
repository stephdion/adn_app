class FixDbDoubleEntity < ActiveRecord::Migration
  def change
  	#Erase, migrate double data from user
  	execute "delete FROM user_phones WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
  	execute "delete FROM user_emails WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
  	execute "delete FROM user_anthropometrics WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
  	execute "delete FROM family_members WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044) OR parent_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
  	execute "delete FROM memberships WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
  	execute "delete FROM participations WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
  	execute "delete FROM scat2_memories WHERE scat2_id IN 
  										(SELECT id FROM scat2s WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531));"
  	execute "delete FROM scat2_cognitions WHERE scat2_id IN 
  										(SELECT id FROM scat2s WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531));"
  	execute "delete FROM scat2_symptoms WHERE scat2_id IN 
  										(SELECT id FROM scat2s WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531));"
    execute "delete FROM scat2_concentrations WHERE scat2_id IN 
  										(SELECT id FROM scat2s WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531));"
  	execute "delete FROM scat2s WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"
    execute "delete FROM resultats WHERE athlete_id IN (817, 1066, 511, 1109, 1127, 1044, 531);"

    ##Run the update for user 531 for injuries 
    execute "update blessures SET user_id = 531 WHERE user_id = 766;"

    ##Delete others injuries related 
    execute "delete FROM blessures WHERE user_id IN (817, 1066, 511, 1109, 1127, 1044);"   

    ##Delete positions double entity relink to other entity
    execute "update participations SET position_id = 30 WHERE position_id = 28;"
    execute "update participations SET position_id = 21 WHERE position_id = 15;"
    execute "update participations SET position_id = 2 WHERE position_id = 1;"

    execute "delete FROM positions WHERE id = 28"
    execute "delete FROM positions WHERE id = 15"
    execute "delete FROM positions WHERE id = 1"

    ##Delete double memberships
    execute "delete FROM memberships WHERE id = 1119;"
    execute "delete FROM memberships WHERE id = 1122;"
    execute "delete FROM memberships WHERE id = 1123;"
    execute "delete FROM memberships WHERE id = 1124;"
    execute "delete FROM memberships WHERE id = 1104;"
    execute "delete FROM memberships WHERE id = 813;"
    execute "delete FROM memberships WHERE id = 1117;"
    execute "delete FROM memberships WHERE id = 1116;"
    execute "delete FROM memberships WHERE id = 1120;"
    execute "delete FROM memberships WHERE id = 1121;"
 end
end
