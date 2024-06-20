class StockTransferItem < ApplicationRecord
  belongs_to :product
  belongs_to :stock_transfer
end
