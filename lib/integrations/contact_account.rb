module Integration
  class ContactAccount < Base
    attr_reader :object

    def initialize(config, object)
      @object = object
      super(config)
    end

    def upsert!
      contact_service.upsert!(customer_params['Email'], customer_params_with_account)
    end

    def fetch_updates
      return [] if latest_contacts.to_a.empty?

      latest_contacts.map do |contact|
        account = contact["Account"] || {}

        {
          id: account["AccountNumber"] || contact["Id"],
          first_name: contact["FirstName"],
          last_name: contact["LastName"],
          email: contact["Email"],
          account_name: account["Name"],
          salesforce_id: contact["Id"],
          shipping_address: build_address(account, "Shipping"),
          billing_address: build_address(account)
        }
      end
    end

    def latest_timestamp_update(contacts = nil)
      if contact = (contacts || latest_contacts).to_a.last
        Time.parse(contact["LastModifiedDate"]).utc.iso8601
      else
        Time.now.utc.iso8601
      end
    end

    def build_address(account, kind = "Billing")
      {
        address1: account["#{kind}Street"],
        zipcode: account["#{kind}PostalCode"],
        city: account["#{kind}City"],
        country: account["#{kind}Country"],
        state: account["#{kind}State"],
        phone: account["Phone"]
      }
    end

    private
    def latest_contacts
      @latest_contacts ||= contact_service.latest_updates config[:salesforce_contacts_since]
    end

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
      Builder::Contact.new(object).build.merge({ AccountId: account_id })
    end
  end
end
