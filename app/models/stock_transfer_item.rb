class StockTransferItem < ApplicationRecord
  belongs_to :variant
  belongs_to :stock_transfer
end
