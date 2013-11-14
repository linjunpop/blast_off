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
          access_key: access_key,
          secret_key: secret_key
        )
        @upload_token = ::Qiniu::RS.generate_upload_token(scope: @bucket)
      end

      def distribute
        upload_string(template.manifest_plist("#{base_url}/#{@ipa_file.name}.ipa"), 'manifest.plist')
        upload_string(template.html("#{base_url}/manifest.plist"), 'index.html')
        upload_file(@ipa_file_path, "#{@ipa_file.name}.ipa")

        "#{base_url}/index.html"
      end

      private

      def base_path
        "#{@ipa_file.name}/#{@ipa_file.version}"
      end

      def base_url
        "http://#{@bucket}.qiniudn.com/#{base_path}"
      end

      def upload_string(string, key)
        file = Tempfile.new(key)
        begin
          file.write(string)
          file.rewind
          upload_file(file.path, key)
        ensure
          file.close
          file.unlink
        end
      end

      def upload_file(filepath, key)
        ::Qiniu::RS.upload_file(
          uptoken: @upload_token,
          file: filepath,
          bucket: @bucket,
          key: "#{base_path}/#{key}"
        )
      end

      def template
        @template ||= Template.new(
          app_name: @ipa_file.name,
          app_bundle_identifier: @ipa_file.bundle_identifier,
          app_version: @ipa_file.version
        )
      end
    end
  end
end
