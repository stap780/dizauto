class Templ < ApplicationRecord
  validates :tip, presence: true
  validates :modelname, presence: true
  validates :title, presence: true
  validates :content, presence: true

  before_save :normalize_data_white_space

  scope :incase_print, -> { where(modelname: "incase", tip: "simple").order(:id) }
  scope :order_print, -> { where(modelname: "order", tip: "simple").order(:id) }
  scope :product_print, -> { where(modelname: "product", tip: "simple").order(:id) }
  scope :incase_import_print, -> { where(modelname: "incase_import_print", tip: "simple").order(:id) }
  scope :supply_print, -> { where(modelname: "supply", tip: "simple").order(:id) }
  scope :invoice_print, -> { where(modelname: "invoice", tip: "simple").order(:id) }
  scope :return_print, -> { where(modelname: "return", tip: "simple").order(:id) }
  scope :enter_print, -> { where(modelname: "enter", tip: "simple").order(:id) }
  scope :loss_print, -> { where(modelname: "loss", tip: "simple").order(:id) }
  scope :stock_transfer_print, -> { where(modelname: "stock_transfer", tip: "simple").order(:id) }
  scope :stock_print, -> { where(modelname: "stock", tip: "simple").order(:id) }
  scope :product_print, -> { where(modelname: "product", tip: "simple").order(:id) }


  Templ::RECEIVER = [["Клиент", "client"], ["Пользователь", "user"]].freeze
  Templ::TIP = [["Простое", "simple"], ["Сообщения", "message"]].freeze
  Templ::MODELNAME = [["Убытки", "incase"], 
                      ["Заказы", "order"],
                      ["Товары", "product"],
                      ["Поступления","supply"],
                      ["Накладные","invoice"],
                      ["Возвраты","return"],].freeze  #, ["incase_supply","incase_supply"]

  def self.ransackable_attributes(auth_object = nil)
    Templ.attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish) && self[key] != content
    end
  end
  
end
