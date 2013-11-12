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
        @qiniu_bucket = bucket

        ::Qiniu::RS.establish_connection!(
          access_key: access_key,
          secret_key: secret_key
        )
      end

      def distribute
        manifest_file = Tempfile.new('manifest')
        begin
          manifest_file.write(manifest_template)
          manifest_file.rewind
          upload(manifest_file.path, 'manifest.plist')
        ensure
          manifest_file.close
          manifest_file.unlink
        end

        html_file = Tempfile.new('html')
        begin
          html_file.write(html_template)
          html_file.rewind
          upload(html_file.path, 'index.html')
        ensure
          html_file.close
          html_file.unlink
        end

        upload(@ipa_file_path, "#{@ipa_file.name}.ipa")

        puts "#{base_url}/index.html".foreground(:white).background(:blue)
      end

      private

      def base_path
        "#{@ipa_file.name}/#{@ipa_file.version}"
      end

      def base_url
        "http://#{@qiniu_bucket}.qiniudn.com/#{base_path}"
      end

      def upload(file, key)
        upload_token = ::Qiniu::RS.generate_upload_token scope: @qiniu_bucket

        ::Qiniu::RS.upload_file uptoken: upload_token,
          file: file,
          bucket: @qiniu_bucket,
          key: "#{base_path}/#{key}"
      end

      def manifest_template
        {
          items: [
            assets: [
              {
                kind: 'software-package',
                url: "#{base_url}/#{@ipa_file.name}.ipa"
              }
            ],
            metadata: {
              'bundle-identifier' => @ipa_file.bundle_identifier,
              'bundle-version' => @ipa_file.version,
              kind: 'software',
              title: @ipa_file.name
            }
          ]
        }.to_plist
      end

      def html_template
        opts = OpenStruct.new({
          app_name:  @ipa_file.name,
          app_version: @ipa_file.version,
          base_url: base_url
        })
        template_file = File.join(File.dirname(File.expand_path(__FILE__)), '../template/index.html.erb')

        ::ERB.new(File.read(template_file)).result(opts.instance_eval {binding})
      end

    end
  end
end
