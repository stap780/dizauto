class Incase < ApplicationRecord
  audited
  belongs_to :incase_status, optional: true # это убирает проверку presence: true , которая стоит по дефолту
  belongs_to :incase_tip, optional: true # это убирает проверку presence: true , которая стоит по дефолту
  belongs_to :company
  belongs_to :strah, class_name: "Company", foreign_key: "strah_id"
  has_many :incase_items, dependent: :destroy
  accepts_nested_attributes_for :incase_items, allow_destroy: true, reject_if: :all_blank
  has_many :comments, as: :commentable, dependent: :destroy
  accepts_nested_attributes_for :comments, allow_destroy: true

  has_associated_audits

  before_save :normalize_data_white_space
  
  after_create_commit :automation_on_create
  after_create_commit { broadcast_prepend_to "incases_list" }
  after_update_commit :automation_on_update
  # after_commit :update_counter, on: [ :create, :destroy ]

  validates :date, presence: true
  validates :unumber, presence: true

  REGION = ["МСК", "СПБ"].freeze

  def self.ransackable_attributes(auth_object = nil)
    Incase.attribute_names
  end

  def self.ransackable_associations(auth_object = nil)
    ["associated_audits", "audits", "company", "incase_items", "strah", "incase_status", "incase_tip"]
  end


  # def self.import_attributes
  #   our_fields = []
  #   incases = []
  #   incase_items = []
  #   Incase.attribute_names.each do |fi|
  #     # fi = 'company' if fi == 'company_id' # fi = 'strah' if fi == 'strah_id'
  #     incases.push(fi) if fi != "id" && fi != "created_at" && fi != "updated_at" && fi != "incase_status_id" && fi != "incase_tip_id"
  #   end
  #   incase_hash = {}
  #   incase_hash["incase"] = incases.reject(&:blank?)
  #   our_fields.push(incase_hash)
  #   IncaseItem.attribute_names.each do |fi|
  #     incase_items.push(fi) if fi != "incase_id" && fi != "id" && fi != "created_at" && fi != "updated_at" && fi != "incase_item_status_id"
  #   end
  #   incase_item_hash = {}
  #   incase_item_hash["incase_item"] = incase_items.reject(&:blank?)
  #   our_fields.push(incase_item_hash)
  #   # puts our_fields.to_s
  #   our_fields
  # end

  def send_excel
    email_data = {
      email_setup: EmailSetup.all.first,
      incase: self,
      subject: "Test subject",
      content: "Test content",
      receiver: strah.main_email
    }
    check_email = IncaseMailer.with(email_data).send_info_email.deliver_now # .deliver_later(wait: '1'.to_i.minutes)
    check_email.present? ? true : false
  end

  def automation_on_create
    Automation.new(self).create
  end

  def automation_on_update
    Automation.new(self).update
  end

  private

  def normalize_data_white_space
    attributes.each do |key, value|
      self[key] = value.squish if value.respond_to?(:squish)
    end
  end

  # def update_counter
  #   broadcast_update_to('incases_list', target: 'count_info', partial: "incases/count_info", locals: {incases: nil})
  # end

end

# [{"region" => "МСК", "strah_id" => 1835, "unumber" => "0191/046/00098/23", "stoanumber" => "ЗН-0167347", "company_id" => 1549, "carnumber" => "А377АА777", "date" => "Fri, 02 Jun 2023", "totalsum" => 281371.49, "incase_item_data" => {"title" => "БАМПЕР ПЕРЕДНИЙ", "sum" => nil, "katnumber" => "A22288095009999"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0191/046/00098/23", "stoanumber" => "ЗН-0167347", "company_id" => 1549, "carnumber" => "А377АА777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "РЕШЕТКА ПЕРЕДНЕГО БАМПЕРА", "sum" => nil, "katnumber" => "A2228857100"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0191/046/00098/23", "stoanumber" => "ЗН-0167347", "company_id" => 1549, "carnumber" => "А377АА777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "МОЛДИНГ ПЕРЕДНЕГО БАМПЕРА", "sum" => nil, "katnumber" => "A2228857600"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0191/046/00098/23", "stoanumber" => "ЗН-0167347", "company_id" => 1549, "carnumber" => "А377АА777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "НАКЛАДКА БАМПЕРА ЛЕВАЯ", "sum" => nil, "katnumber" => "A2228857700"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0191/046/00098/23", "stoanumber" => "ЗН-0167347", "company_id" => 1549, "carnumber" => "А377АА777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "НАКЛАДКА БАМПЕРА ПРАВАЯ", "sum" => nil, "katnumber" => "A2228857800"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0194/046/00170/23", "stoanumber" => "023-0995", "company_id" => 1763, "carnumber" => "К029СХ777", "date" => "Fri, 02 Jun 2023", "totalsum" => 353408.0, "incase_item_data" => {"title" => "БАМПЕР ПЕРЕДНИЙ", "sum" => nil, "katnumber" => "521193T910"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0194/046/00170/23", "stoanumber" => "023-0995", "company_id" => 1763, "carnumber" => "К029СХ777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "НАКЛАДКА ПРОТИВОТУМАННОЙ ФАРЫ", "sum" => nil, "katnumber" => "8148233070"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0194/046/00170/23", "stoanumber" => "023-0995", "company_id" => 1763, "carnumber" => "К029СХ777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "НАПРАВЛЯЮЩАЯ БАМПЕРА ПЕР ЛЕВАЯ", "sum" => nil, "katnumber" => "5214633070"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0194/046/00170/23", "stoanumber" => "023-0995", "company_id" => 1763, "carnumber" => "К029СХ777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "НАПОЛНИТЕЛЬ БАМПЕРА ПЕРЕДНЕГО", "sum" => nil, "katnumber" => "5261133280"}}, {"region" => "МСК", "strah_id" => 1835, "unumber" => "0194/046/00170/23", "stoanumber" => "023-0995", "company_id" => 1763, "carnumber" => "К029СХ777", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "МОЛДИНГ РЕШЕТКИ РАДИАТОРА", "sum" => nil, "katnumber" => "5312133090"}}, {"region" => "МСК", "strah_id" => 1849, "unumber" => "009-23.01223716", "stoanumber" => "023-0999", "company_id" => 1763, "carnumber" => "Н631АК799", "date" => "Fri, 02 Jun 2023", "totalsum" => 23854.84, "incase_item_data" => {"title" => "МОЛДИНГ ПЕРЕДНЕЙ ДВЕРИ ЛЕВЫЙ", "sum" => nil, "katnumber" => "8450000409"}}, {"region" => "МСК", "strah_id" => 1849, "unumber" => "009-23.01223716", "stoanumber" => "023-0999", "company_id" => 1763, "carnumber" => "Н631АК799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "ФАРТУК ПЕР КРЫЛА ЛЕВ", "sum" => nil, "katnumber" => "8450000980"}}, {"region" => "МСК", "strah_id" => 1849, "unumber" => "009-23.01223716", "stoanumber" => "023-0999", "company_id" => 1763, "carnumber" => "Н631АК799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "МОЛДИНГ АРКИ КРЫЛА ПЕРЕДНИЙ ЛЕВ", "sum" => nil, "katnumber" => "6001548285"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => 220100.4, "incase_item_data" => {"title" => "БАМПЕР ЗАДНИЙ", "sum" => nil, "katnumber" => "521590K950"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "ГЛУШИТЕЛЬ ЗАДНЯЯ ЧАСТЬ", "sum" => nil, "katnumber" => "174050L220"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "КРЫШКА БАГАЖНИКА", "sum" => nil, "katnumber" => "67005KK140"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "ПЕТЛЯ БУКСИР ЗАДНЯЯ", "sum" => nil, "katnumber" => "510950K010"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "ПЫЛЬНИК ЗАДНЕГО БАМПЕРА ПРАВЫЙ", "sum" => nil, "katnumber" => "662510K020"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "РАСШИРИТЕЛЬ ЗАДНИЙ ПРАВЫЙ", "sum" => nil, "katnumber" => "527060K010"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "СПОЙЛЕР ЗАДНЕГО БАМПЕРА НИЖН Ч", "sum" => nil, "katnumber" => "521690K170"}}, {"region" => "МСК", "strah_id" => 1848, "unumber" => "23MT0674D№0000001", "stoanumber" => "ШМТ0000344", "company_id" => 1808, "carnumber" => "Н081ВУ799", "date" => "Fri, 02 Jun 2023", "totalsum" => nil, "incase_item_data" => {"title" => "УСИЛИТЕЛЬ ЗАДНЕГО БАМПЕРА", "sum" => nil, "katnumber" => "523460K020"}}]
