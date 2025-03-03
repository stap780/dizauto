# frozen_string_literal: true

# Helper methods for companies
module CompaniesHelper

  def collect_company_info(company)
    return '' unless company.short_title.present?

    content = content_tag(:span, '', class: 'no-wrap')
    content << content_tag(
      :span,
      company.short_title,
      class: 'no-wrap fw-bold cursor-pointer',
      'data-controller': 'tooltip',
      'data-bs-trigger': 'hover click',
      'data-bs-placement': 'right',
      'data-bs-title': generate_tooltip_text(company)
    )
    content_tag :div, class: 'd-flex justify-content-start gap-2 align-items-center' do
      content
    end
  end

  def collect_company_bank_info(company)
    return '' unless company.bik.present?

    data = ["БИК: #{company.bik}", "Название: #{company.bank_title}", "Расч Счет: #{company.bank_account}"]
    content = content_tag(:span)
    data.each do |dat|
      content << content_tag(:span, dat)
    end
    content_tag :div, class: 'd-flex justify-content-start gap-2 align-items-center' do
      content
    end
  end

  private

  def generate_tooltip_text(company)
    "#{company.title} ИНН: #{company.inn} КПП: #{company.kpp} Юрид: #{company.ur_address} Факт: #{company.fact_address}"
  end

end