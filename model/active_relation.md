class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :partner_orders, through: :orders, dependent: :destroy
  has_many :partner_order_items, through: :orders, dependent: :destroy
  #  has_many :partner_order_items, through: :partner_orders, dependent: :destroy 同上一句一样
end

User.first.partner_orders 生成sql语句：
  PartnerOrder Load (3.8ms)  
  SELECT  "partner_orders".* FROM "partner_orders" 
  INNER JOIN "orders" ON "partner_orders"."order_id" = "orders"."id" 
  WHERE "orders"."user_id" = $1   [["user_id", 2006]
  
 User.first.partner_order_items 生成sql语句： 
  SELECT  "partner_order_items".* FROM "partner_order_items" 
  INNER JOIN "partner_orders" 
  ON "partner_order_items"."partner_order_id" = "partner_orders"."id" 
  INNER JOIN "orders" 
  ON "partner_orders"."order_id" = "orders"."id" WHERE "orders"."user_id" = $1

  
