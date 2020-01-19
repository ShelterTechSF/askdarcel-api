# frozen_string_literal: true

require 'json'

namespace :synonyms do
  task populate: :environment do
    puts '[synonyms:populate] Incorporating synonyms from JSON...'

    algolia_synonyms_json = File.join(File.dirname(__FILE__), 'algolia-synonyms.json')
    synonyms = File.open(algolia_synonyms_json) do |f|
      JSON.parse(f.read)
    end

    synonyms.each do |syn|
      syn = syn.to_h
      group = SynonymGroup.create(group_type: syn["type"])
      syn["synonyms"].each do |word|
        Synonym.create(word: word, synonym_group_id: group.id)
      end
    end

    puts '[synonyms:populate] Success.'
  end
end
