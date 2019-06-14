# frozen_string_literal: true

class AlgoliaController < ApplicationController
  def reindex
    AlgoliaReindexJob.new.perform
    render html: '<div>[algolia:reindex] Success.</div>'.html_safe
  end
end
