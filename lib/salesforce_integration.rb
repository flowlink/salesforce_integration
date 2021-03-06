$:.unshift File.dirname(__FILE__)

require 'restforce'

require 'integrations/base'
require 'integrations/contact_account'
require 'integrations/product'
require 'integrations/order'
require 'integrations/return'
require 'integrations/shipment'

require 'integrations/builders/account'
require 'integrations/builders/contact'
require 'integrations/builders/product'
require 'integrations/builders/order'
require 'integrations/builders/line_item'
require 'integrations/builders/payment'
require 'integrations/builders/payment_from_return'
require 'integrations/builders/return'

require 'SF_services/base'
require 'SF_services/account'
require 'SF_services/contact'
require 'SF_services/product'
require 'SF_services/order'
require 'SF_services/line_item'
require 'SF_services/note'

class SalesfoceIntegrationError < StandardError; end
