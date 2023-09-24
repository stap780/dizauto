module IncasesHelper

    def get_selected_value(of)
        selected_value = 'Регион' if of == 'region'
        selected_value = 'Страховая компания' if of == 'strah_id'
        selected_value = 'Номер З/Н СТОА' if of == 'stoanumber'
        selected_value = 'Номер дела' if of == 'unumber'
        selected_value = 'Гос номер' if of == 'carnumber'
        selected_value = 'Контрагент' if of == 'company_id'
        selected_value = 'Дата выкладки Акта п-п в папку СК' if of == 'date'
        selected_value = 'Деталь' if of == 'title'
        selected_value = 'Каталожный номер' if of == 'katnumber'
        selected_value = 'Сумма заказ наряда' if of == 'totalsum'
        selected_value = 'Сумма запчастей' if of == 'sum'
        selected_value
    end


end
