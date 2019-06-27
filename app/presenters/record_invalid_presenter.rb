# frozen_string_literal: true

# Presents ActiveRecord::RecordInvalid error objects.
#
# Example output:
#
# { error: "Validation errors: Name is required, Rank is required" }
class RecordInvalidPresenter < Jsonite
  let(:error) do
    msgs = record.errors.messages.map do |field, validation_error|
      "#{field} (#{validation_error.join(', ')})"
    end
    "Validation errors: #{msgs.join(', ')}"
  end

  property :error
end
