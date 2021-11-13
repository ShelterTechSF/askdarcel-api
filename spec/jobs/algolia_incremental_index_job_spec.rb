# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Algolia Incremental Index Job' do
  let!(:resources) { create_list(:resource, 3, status: :approved) }
  let!(:services) { create_list(:service, 3, status: :approved, resource: resources.last) }
  let(:bookmark_identifier) { 'algolia-incremental-index-resources-bookmark' }

  context 'when this is the first time the job has run' do
    it 'creates bookmark for resources' do
      expect(Bookmark.count).to eq(0)

      AlgoliaIncrementalIndexJob.new.perform

      expect(Bookmark.count).to eq(1)
      bm = Bookmark.where(identifier: bookmark_identifier).take
      expect(bm.date_value).to eq(Resource.maximum(:updated_at))
    end
  end

  ## Broken test
  #  context 'when this job has run before and has prior bookmark' do
  #    let(:already_processed_resource) { Resource.order('(updated_at, id) ASC').take }
  #    let(:already_processed_services) do
  #      create_list(:service, 2, resource: already_processed_resource)
  #    end
  #
  #    before(:each) do
  #      create(:bookmark, identifier: bookmark_identifier,
  #                        date_value: already_processed_resource.updated_at,
  #                        id_value: already_processed_resource.id)
  #    end
  #
  #    it 'updates the bookmarks' do
  #      job = AlgoliaIncrementalIndexJob.new
  #
  #      updated = []
  #      allow(job).to receive(:update_in_algolia!) do |record|
  #        updated << record
  #      end
  #
  #      removed = []
  #      allow(job).to receive(:remove_from_algolia!) do |record|
  #        removed << record
  #      end
  #
  #      job.perform
  #
  #      expect(Bookmark.count).to eq(1)
  #      bm = Bookmark.where(identifier: bookmark_identifier).take
  #      expect(bm.date_value).to eq(Resource.maximum(:updated_at))
  #
  #      expect(removed).to be_empty
  #
  #      expect(updated.size).to eq(5)
  #      updated_resources = updated.select { |u| u.is_a?(Resource) }
  #      updated_services = updated.select { |u| u.is_a?(Service) }
  #      expect(updated_resources.size).to eq(2)
  #      expect(updated_services.size).to eq(3)
  #      expect(updated_resources.map(&:id)).not_to include(already_processed_resource.id)
  #      intersection = updated_services.map(&:id) & already_processed_services.map(&:id)
  #      expect(intersection).to be_empty
  #    end
  #  end

  context 'when some resources are not approved' do
    let!(:inactive_resource) do
      resource = Resource.order(id: :desc).take
      resource.update(status: :inactive)
      resource
    end

    it 'syncs approved resources to algolia but deletes all others' do
      job = AlgoliaIncrementalIndexJob.new

      updated = []
      allow(job).to receive(:update_in_algolia!) do |record|
        updated << record
      end

      removed = []
      allow(job).to receive(:remove_from_algolia!) do |record|
        removed << record
      end

      job.perform

      expect(updated.size).to eq(5)
      expect(updated.map(&:approved?).uniq).to eq([true])
      expect(removed.size).to eq(1)
      expect(removed.first.id).to eq(inactive_resource.id)

      expect(Bookmark.count).to eq(1)
      bm = Bookmark.where(identifier: bookmark_identifier).take
      expect(bm.date_value).to eq(Resource.maximum(:updated_at))
    end
  end
end
