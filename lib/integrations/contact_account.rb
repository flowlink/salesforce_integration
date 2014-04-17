module Integration
  class ContactAccount < Base

    attr_reader :object

    def initialize(config, object)
      @object = object.with_indifferent_access
      super(config)
    end

    def upsert!
      contact_service.upsert!(customer_params['Email'], customer_params_with_account)
    end

    private

    def account_id
      contact_service.find_account_id_by_email(customer_params['Email']) || account_service.create!(account_params)
    end

    def account_params
      Integration::Builder::Account.new(object).build
    end

    def customer_params
      Integration::Builder::Contact.new(object).build
    end

    def customer_params_with_account
      Integration::Builder::Contact.new(object).build.merge({ Account__c: account_id })
    end
  end
end
