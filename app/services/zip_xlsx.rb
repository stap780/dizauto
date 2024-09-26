class ZipXlsx < ApplicationService
  require "caxlsx"

  def initialize(collection, options = {})
    @collection = collection
    @model = options[:model]
    @filename = @model.downcase + ".xlsx"
    @template = @model.downcase.pluralize + "/index"
    @error_message = "We have error while zip create"
  end

  def call
    compressed_filestream = output_stream
    compressed_filestream.rewind
    # compressed_filestream
    blob = ActiveStorage::Blob.create_and_upload!(io: compressed_filestream, filename: "#{@template.tr("/", "_")}.zip")
    if blob
      [true, blob]
    else
      [false, @error_message]
    end
  end

  private

  def output_stream
    renderer = ActionController::Base.new

    Zip::OutputStream.write_buffer do |zos|
      zos.put_next_entry(@filename)
      zos.print renderer.render_to_string(
        layout: false, handlers: [:axlsx], formats: [:xlsx], template: @template, locals: {collection: @collection}
      )
    end
  end
end
