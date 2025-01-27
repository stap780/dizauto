# CreatePdf < ApplicationService
class CreatePdf < ApplicationService
  attr_reader :path, :error_message

  def initialize(object, options = {})
    @object = object
    @templ = options[:templ]
    @drop_object = @object.model_name.singular
    @drop = "Drop::#{@object.model_name.name}".constantize.new(@object)
    @filename = "#{@drop_object}_#{@object.id}_#{@templ.id}.pdf"
    @path = Rails.root.join('public/pdfs', @filename)
    @error_message = nil
  end

  def call
    create_path if @templ
    if @templ && create_path
      [true, @path]
    else
      [false, @error_message]
    end
  end

  private

  def create_path
    delete_file
    utf8_content = convert_content(@templ.content)
    if utf8_content
      template = Liquid::Template.parse(utf8_content)
      html_as_string = template.render({@drop_object => @drop}, {strict_variables: true})
      pdf = WickedPdf.new.pdf_from_string(html_as_string)
      File.open(@path, 'wb') do |file|
        file << pdf
      end
    end
  end

  def delete_file
    File.delete(@path) if File.file?(@path).present?
  end

  def convert_content(content)
    if content.include?('utf-8')
      content
    else
      new_content = Nokogiri::HTML(content)
      new_content.inner_html.gsub('<html>', '<html><meta http-equiv="content-type" content="text/html; charset=utf-8" />')

      # puts "convert_content error"
      # @error_message = "don't have utf-8"
      # false
    end
  end

end

# testing
# incase = Incase.last
# pdf_file_name = "#{incase.id.to_s}.pdf"
# tmpl = Liquid::Template.parse( File.read("#{Rails.root.join('public', 'example.liquid')}" ) )
# html_as_string = tmpl.render({'incase' => Drop::Incase.new(incase)}, { strict_variables: true })
# pdf = WickedPdf.new.pdf_from_string(html_as_string)
# save_path = Rails.root.join( 'public/pdfs', pdf_file_name )
# File.open(save_path, 'wb') do |file|
#   file << pdf
# end
# 
# work test
# product = Product.last
# utf8_content = "{% for variant in product.variants %} {{variant.id}}{% endfor%}"
# template = Liquid::Template.parse(utf8_content)
# html_as_string = template.render({'product' => Drop::Product.new(product)}, { strict_variables: true })
# template.errors
# 
# invoice = Invoice.last
# utf8_content = "{% for item in invoice.items %} {{item.id}}{% endfor %}"
# template = Liquid::Template.parse(utf8_content)
# html_as_string = template.render({'invoice' => Drop::Invoice.new(invoice)}, { strict_variables: true })