require "rubygems"
require "exotic_migrator"

#migrating all registered user irrespective of whether they have bought something or not
DiscountTable.migrate_discount_table

#migrating all customer who has bought something but not registered
Customer.migrate_non_registered_user
#User.migrate_register_user_who_has_also_bought
