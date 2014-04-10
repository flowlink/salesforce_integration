$:.unshift File.dirname(__FILE__)

require 'restforce'
require 'executrix'

require 'salesforce_integration/services/base'
require 'salesforce_integration/services/contact_builder'
require 'salesforce_integration/services/contact'
require 'salesforce_integration/services/product_builder'
require 'salesforce_integration/services/product'
require 'salesforce_integration/services/order_builder'
require 'salesforce_integration/services/order'
require 'salesforce_integration/services/order_client_builder'

require 'salesforce_integration/base'
require 'salesforce_integration/order'
require 'salesforce_integration/customer'
require 'salesforce_integration/product'
require 'salesforce_integration/order_client'
