# Templ < ApplicationRecord
class Templ < ApplicationRecord
  belongs_to :print_template, class_name: 'Templ', foreign_key: 'print_template_id', optional: true

  validates :tip, presence: true
  validates :modelname, presence: true
  validates :title, presence: true
  validates :content, presence: true

  before_save :normalize_data_white_space

  scope :print, -> { where(tip: 'simple').order(:id) }
  scope :incase_print, -> { where(modelname: 'incase', tip: 'simple').order(:id) }
  scope :order_print, -> { where(modelname: 'order', tip: 'simple').order(:id) }
  scope :product_print, -> { where(modelname: 'product', tip: 'simple').order(:id) }
  scope :incase_import_print, -> { where(modelname: 'incase_import_print', tip: 'simple').order(:id) }
  scope :supply_print, -> { where(modelname: 'supply', tip: 'simple').order(:id) }
  scope :invoice_print, -> { where(modelname: 'invoice', tip: 'simple').order(:id) }
  scope :return_print, -> { where(modelname: 'return', tip: 'simple').order(:id) }
  scope :enter_print, -> { where(modelname: 'enter', tip: 'simple').order(:id) }
  scope :loss_print, -> { where(modelname: 'loss', tip: 'simple').order(:id) }
  scope :stock_transfer_print, -> { where(modelname: 'stock_transfer', tip: 'simple').order(:id) }
  scope :stock_print, -> { where(modelname: 'stock', tip: 'simple').order(:id) }

  RECEIVER = [%w[клиент client], %w[пользователь user]].freeze
  TIP = [%w[простое simple], %w[сообщение message]].freeze
  MODELNAME = [
    %w[Убытки incase],
    %w[Заказы order],
    %w[Товары product],
    %w[Поступления supply],
    %w[Накладные invoice],
    %w[Возвраты return]
  ].freeze

  def self.ransackable_attributes(auth_object = nil)
    attribute_names
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish) && self[key] != content
    end
  end

end