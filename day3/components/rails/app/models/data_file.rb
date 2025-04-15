class DataFile < ApplicationRecord
  enum status: { raw: 0, processed: 1 }
end
