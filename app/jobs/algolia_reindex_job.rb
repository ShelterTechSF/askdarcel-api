# frozen_string_literal: true

# Background job to reindex all relevant database records in Algolia.
#
# Usage:
#
# To send job to a background worker to execute:
#
# > AlgoliaReindexJob.perform_async
#
# To execute in-line immediately from Rails console:
#
# > AlgoliaReindexJob.new.perform
#
class AlgoliaReindexJob
  def perform
    Resource.where(status: :approved).reindex

    # Batch synonyms, with replica forwarding and atomic replacement of existing synonyms
    forward_to_replicas = true
    replace_existing_synonyms = true
    Resource.index.batch_synonyms(format_synonyms_list, forward_to_replicas, replace_existing_synonyms)

    # Since Service and Resource share an algolia index, we use `reindex!` so
    # Service reindexing does not clear out Resource index records.
    Service.where(status: :approved).reindex!
  end

  private

  def format_synonyms_list
    synonyms_list = []
    SynonymGroup.find_each do |group|
      word_list = []
      Synonym.where(synonym_group_id: group.id).each do |syn|
        word_list.push(syn.word)
      end
      synonyms_list.push(objectID: group.id.to_s, type: group.group_type, synonyms: word_list)
    end
    synonyms_list
  end
end
