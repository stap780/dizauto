module CompaniesHelper

    def collect_company_info(company)
        return '' unless company.short_title.present?
        tooltip_text = "#{company.title} ИНН: #{company.inn} КПП: #{company.kpp} Юрид: #{company.ur_address} Факт: #{company.fact_address}"
        content = content_tag(:span, "Название:" , class: "no-wrap")
        content << content_tag(:span, company.short_title , class: "no-wrap", "data-controller": "tooltip", "data-bs-trigger": 'hover click', "data-bs-placement": "right", "data-bs-title": tooltip_text)
        content_tag :div, class: "d-flex justify-content-start gap-2 align-items-center" do
            content
        end
    end

    def collect_company_bank_info(company)
        return '' unless company.bik.present?
        data = ["БИК: #{company.bik}", "Название: #{company.bank_title}", "Расч Счет: #{company.bank_account}"]
        content = content_tag(:span)
        data.each do |d|
            content << content_tag(:span, d)
        end
        content_tag :div, class: "d-flex justify-content-start gap-2 align-items-center" do
            content
        end
    end

end
