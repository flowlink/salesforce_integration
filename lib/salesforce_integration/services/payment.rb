module SalesforceIntegration
  module Service
    class Payment < Base

      def initialize(config)
        super("Payment__c", config)
      end

      def get_payment(number)
        results = salesforce.query("select Id from Payment where Number__c = '#{number}'")
        results.any? ? results.first.fetch('Id') : nil
      end

      def upsert!(number, payment_attr = {})
        payment_id = get_payment(number)
        payment_id.present? ? update!(payment_attr.merge({ Id: payment_id })) : create!(payment_attr)
      end

    end
  end
end
