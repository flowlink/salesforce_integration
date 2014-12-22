module SFService
  class Note < Base
    def initialize(config)
      super("Note", config)
    end

    def find_note_by_title(title, parent_id)
      filter = "Title = '#{title}' AND ParentId = '#{parent_id}'"
      results = salesforce.query("SELECT Id FROM Note WHERE #{filter} LIMIT 1")
      results.any? ? results.first.fetch('Id') : nil
    end

    def upsert!(attributes = {}, opportunity_id)
      attributes = attributes.merge ParentId: opportunity_id

      note_id = find_note_by_title attributes['Title'], opportunity_id
      note_id.present? ? update!(attributes.merge(Id: note_id)) : create!(attributes)
    end
  end
end
