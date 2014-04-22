module Factories
  class << self
    # TODO put this in a specific fixture folder and loop through each file on that dir
    [:add_customer, :update_customer,
     :add_order, :update_order, :cancel_order,
     :add_product, :update_product].each do |message|
      define_method("#{message}_payload") do
        JSON.parse IO.read("#{File.dirname(__FILE__)}/factories/#{message}.json")
      end
    end
  end
end
