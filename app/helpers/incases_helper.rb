module IncasesHelper
  def get_selected_value(of)
    selected_value = "incase#region" if of.include?("Регион")
    selected_value = "Страховая компания" if of == "strah_id"
    selected_value = "Номер З/Н СТОА" if of == "stoanumber"
    selected_value = "Номер дела" if of == "unumber"
    selected_value = "Гос номер" if of == "carnumber"
    selected_value = "Контрагент" if of == "company_id"
    selected_value = "Дата выкладки Акта п-п в папку СК" if of == "date"
    selected_value = "Деталь" if of == "title"
    selected_value = "Каталожный номер" if of == "katnumber"
    selected_value = "Сумма заказ наряда" if of == "totalsum"
    selected_value = "Сумма запчастей" if of == "sum"
    selected_value
  end

  def selected_value_from_group(of)
    selected_value = "incase#region" if of.include?("Регион")
    selected_value = "incase#strah_id" if of.include?("Страховая компания")
    selected_value = "incase#stoanumber" if of.include?("Номер З/Н СТОА")
    selected_value = "incase#unumber" if of.include?("Номер дела")
    selected_value = "incase#carnumber" if of.include?("Гос номер")
    selected_value = "incase#company_id" if of.include?("Контрагент")
    selected_value = "incase#date" if of.include?("Дата выкладки Акта п-п в папку СК")
    selected_value = "incase_item#title" if of.include?("Деталь")
    selected_value = "incase_item#katnumber" if of.include?("Каталожный номер")
    selected_value = "incase#totalsum" if of.include?("Сумма заказ наряда")
    selected_value = "incase_item#sum" if of.include?("Сумма запчастей")
    selected_value = "incase_item#price" if of.include?("Цена")
    selected_value
  end
end
