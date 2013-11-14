require 'cfpropertylist'

module BlastOff
  class Template
    def initialize(app_name:'', app_bundle_identifier:'', app_version:'')
      @app_name = app_name
      @app_bundle_identifier = app_bundle_identifier
      @app_version = app_version
    end

    def manifest_plist(ipa_file_url)
      {
        items: [
          assets: [
            {
              kind: 'software-package',
              url: ipa_file_url
            }
          ],
          metadata: {
            'bundle-identifier' => @app_bundle_identifier,
            'bundle-version' => @app_version,
            kind: 'software',
            title: @app_name
          }
        ]
      }.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
    end

    def html(manifest_plist_url)
      opts = OpenStruct.new({
        app_name:  @app_name,
        app_version: @app_version,
        manifest_plist_url: manifest_plist_url
      })
      template_file = File.join(File.dirname(File.expand_path(__FILE__)), 'template/index.html.erb')

      ::ERB.new(File.read(template_file)).result(opts.instance_eval {binding})
    end
  end
end
