require 'caxlsx'

class ZipXlsx < ApplicationService

    def initialize(collection, options={})
        @collection = collection
        @filename = options[:filename]
        @template = options[:template]
        @error_message = "We have error while zip create"
    end

    def call
        compressed_filestream = output_stream
        compressed_filestream.rewind
        #compressed_filestream
        blob = ActiveStorage::Blob.create_and_upload!( io: compressed_filestream, filename: "#{@template.gsub('/','_')}.zip")
        if blob
            return true,  blob
        else
            return false, @error_message
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