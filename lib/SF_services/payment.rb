module SFService
  class Payment < Base
    def initialize(config)
      super("Note", config)
    end

    def find_note_by_title(title)
      results = salesforce.query("SELECT Id FROM Note WHERE Title = 'Payment:#{title}' LIMIT 1")
      results.any? ? results.first.fetch('Id') : nil
    end

    def upsert!(payment_attr = {}, opportunity_id)
      payment_attr = payment_attr.merge ParentId: opportunity_id

      note_id = find_note_by_title(payment_attr.fetch 'Title')
      note_id.present? ? update!(payment_attr.merge(Id: note_id)) : create!(payment_attr)
    end
  end
end
