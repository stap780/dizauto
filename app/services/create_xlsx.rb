require 'caxlsx'

class CreateXlsx < ApplicationService

    def initialize(collection, options={})
        @collection = collection
        @filename = options[:filename]
        @template = options[:template]
        # @host = Rails.env.development? ? 'http://localhost:3000' : 'http://68.183.209.231'
    end

    def call
        compressed_filestream = output_stream
        compressed_filestream.rewind
        compressed_filestream
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