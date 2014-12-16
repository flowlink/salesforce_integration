$:.unshift File.dirname(__FILE__)

require 'restforce'

require 'Spree_services/base'
require 'Spree_services/return'

require 'integrations/base'
require 'integrations/contact_account'
require 'integrations/product'
require 'integrations/order'
require 'integrations/line_item'
require 'integrations/payment'
require 'integrations/return'

require 'integrations/builders/account'
require 'integrations/builders/contact'
require 'integrations/builders/product'
require 'integrations/builders/order'
require 'integrations/builders/order_from_sf'
require 'integrations/builders/line_item'
require 'integrations/builders/payment'
require 'integrations/builders/payment_from_return'
require 'integrations/builders/order_product'
require 'integrations/builders/return'

require 'SF_services/base'
require 'SF_services/account'
require 'SF_services/contact'
require 'SF_services/product'
require 'SF_services/order'
require 'SF_services/line_item'
require 'SF_services/payment'
require 'SF_services/return'

class SalesfoceIntegrationError < StandardError; end
