require 'tempfile'
require 'ostruct'
require 'qiniu-rs'
require 'erb'

module BlastOff
  module Services
    class Qiniu
      def initialize(ipa_file_path:nil, access_key:'', secret_key:'', bucket:'')
        @ipa_file_path = ipa_file_path
        @ipa_file = ::IpaReader::IpaFile.new(ipa_file_path)
        @bucket = bucket

        ::Qiniu::RS.establish_connection!(
          enable_debug: false,
          access_key: access_key,
          secret_key: secret_key
        )
        @upload_token = ::Qiniu::RS.generate_upload_token(scope: @bucket)
      end

      def distribute
        upload_string(
          template.manifest_plist("#{base_url}/#{@ipa_file.name}.ipa"),
          'manifest.plist',
          'application/octet-stream'
        )
        upload_string(
          template.html("#{base_url}/manifest.plist"),
          'index.html',
          'text/html'
        )
        upload_file(
          @ipa_file_path,
          "#{@ipa_file.name}.ipa",
          'application/octet-stream'
        )

        "#{base_url}/index.html"
      end

      private

      def base_path
        "#{@ipa_file.name}/#{@ipa_file.version}"
      end

      def base_url
        "http://#{@bucket}.qiniudn.com/#{base_path}"
      end

      def upload_string(string, key, mime_type)
        file = Tempfile.new(key)
        begin
          file.write(string)
          file.rewind
          upload_file(file.path, key, mime_type)
        ensure
          file.close
          file.unlink
        end
      end

      def upload_file(filepath, key, mime_type)
        ::Qiniu::RS.upload_file(
          uptoken: @upload_token,
          file: filepath,
          mime_type: mime_type,
          bucket: @bucket,
          key: "#{base_path}/#{key}"
        )
      end

      def template
        @template ||= Template.new(@ipa_file)
      end
    end
  end
end
